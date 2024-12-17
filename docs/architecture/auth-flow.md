# Authentication System Architecture

## Overview
The authentication system is built on Supabase Auth, providing secure email/password authentication with email verification. The system uses Next.js middleware for route protection and session management.

## Components

### 1. Authentication Pages
- `/sign-up`: New user registration
- `/sign-in`: Existing user login
- `/forgot-password`: Password reset request
- `/reset-password`: Password reset completion
- `/auth/callback`: OAuth and email verification handler

### 2. Middleware Layer
```typescript
// middleware.ts
- Global middleware checks authentication state
- Handles public vs. protected routes
- Manages session updates
- Redirects unauthenticated users

// utils/supabase/middleware.ts
- Supabase client initialization
- Cookie management
- Session refresh logic
```

### 3. Server Actions
```typescript
// app/actions.ts
- signUpAction: Handles new user registration
- signInAction: Processes user login
- signOutAction: Manages user logout
- resetPasswordAction: Handles password resets
```

### 4. Security Features
- CSRF Protection
- Secure session cookies
- Email verification requirement
- Password strength requirements
- Rate limiting (via Supabase)

## Authentication Flow

### Sign Up
1. User submits email/password
2. Server validates input
3. Creates Supabase auth record
4. Sends verification email
5. Redirects to verification notice

### Sign In
1. User submits credentials
2. Server validates
3. Creates session
4. Sets secure cookies
5. Redirects to dashboard

### Session Management
1. Middleware checks auth state
2. Refreshes session if needed
3. Redirects if unauthorized
4. Updates cookies as needed

### Password Reset
1. User requests reset
2. Receives email with token
3. Submits new password
4. Server validates token
5. Updates password
6. Redirects to login

## Security Considerations
1. All sensitive routes are protected
2. Cookies are HTTP-only
3. CSRF tokens on forms
4. Rate limiting on auth endpoints
5. Secure password hashing (Supabase)

## Environment Variables
```env
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_ANON_KEY=
SUPABASE_SERVICE_ROLE_KEY=
```

## Future Enhancements
1. Social authentication
2. MFA support
3. Session management dashboard
4. Enhanced security logging
