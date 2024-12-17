import { type NextRequest, NextResponse } from "next/server";
import { updateSession } from "@/utils/supabase/middleware";
import { publicRoutes } from "@/utils/routes";
import type { SupabaseResponse } from "@/utils/supabase/middleware";

export async function middleware(request: NextRequest) {
  try {
    const path = request.nextUrl.pathname;

    // Skip middleware for auth callback route
    if (path === "/auth/callback") {
      return NextResponse.next();
    }

    // Special handling for root path
    if (path === "/") {
      const response = (await updateSession(request)) as SupabaseResponse;
      const { data } = await response.supabase.auth.getSession();
      
      if (!data.session) {
        return NextResponse.redirect(new URL("/sign-in", request.url));
      }
      
      return response;
    }

    // Check if the route is public
    const isPublicRoute = publicRoutes.includes(path);

    if (isPublicRoute) {
      return NextResponse.next();
    }

    // Update session and check for authentication
    const response = (await updateSession(request)) as SupabaseResponse;
    const { data } = await response.supabase.auth.getSession();

    if (!data.session) {
      const loginUrl = new URL("/sign-in", request.url);
      loginUrl.searchParams.set("redirect", path);
      return NextResponse.redirect(loginUrl);
    }

    return response;
  } catch (error) {
    console.error("Middleware error:", error);
    return NextResponse.redirect(new URL("/sign-in", request.url));
  }
}

export const config = {
  matcher: [
    /*
     * Match all request paths except:
     * - _next/static (static files)
     * - _next/image (image optimization)
     * - favicon.ico
     * - Images
     */
    "/((?!_next/static|_next/image|favicon.ico|.*\\.(?:svg|png|jpg|jpeg|gif|webp)$).*)",
  ],
};
