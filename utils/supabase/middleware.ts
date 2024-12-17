import { createServerClient } from "@supabase/ssr";
import { type SupabaseClient } from "@supabase/supabase-js";
import { type NextRequest, NextResponse } from "next/server";
import { publicRoutes } from "@/utils/routes"; // Import shared public routes

// Extend NextResponse to include Supabase client
export type SupabaseResponse = NextResponse & {
  supabase: SupabaseClient;
};

export const updateSession = async (request: NextRequest) => {
  try {
    // Create response object
    let response = NextResponse.next({
      request: { headers: request.headers },
    });

    // Create Supabase client
    const supabase = createServerClient(
      process.env.NEXT_PUBLIC_SUPABASE_URL!,
      process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
      {
        cookies: {
          get: (name) => request.cookies.get(name)?.value,
          set: (name, value, options) => {
            request.cookies.set({ name, value, ...options });
            response.cookies.set({ name, value, ...options });
          },
          remove: (name, options) => {
            request.cookies.set({ name, value: "", ...options });
            response.cookies.set({ name, value: "", ...options });
          },
        },
      }
    );

    // Attach Supabase client to response
    (response as SupabaseResponse).supabase = supabase;

    const { data: { user }, error } = await supabase.auth.getUser();
    const path = request.nextUrl.pathname;

    // Skip auth checks for public routes
    if (publicRoutes.includes(path)) {
      return response as SupabaseResponse;
    }

    // Redirect unauthenticated users
    if (!user || error) {
      const loginUrl = new URL("/sign-in", request.url);
      loginUrl.searchParams.set("redirect", path);
      return NextResponse.redirect(loginUrl);
    }

    // Return response with attached Supabase client
    return response as SupabaseResponse;
  } catch (e) {
    console.error("Error in updateSession:", e);
    // Return to login on error
    const loginUrl = new URL("/sign-in", request.url);
    return NextResponse.redirect(loginUrl);
  }
};
