# Mosaic: AI-Powered Content Funnel Optimizer

## Project Description
Mosaic is a web application that helps small businesses create cohesive content strategies by generating customized content bundles that guide customers through all stages of awareness. The platform uses AI (CrewAI) to generate hyper-customized content including social posts, blog posts, lead magnets, and email sequences.

## Technical Stack
- **Framework**: Next.js 14 (App Router)
- **Authentication**: Supabase Auth
- **Database**: Supabase PostgreSQL
- **AI Engine**: CrewAI
- **Styling**: Tailwind CSS
- **UI Components**: Custom components with Radix UI primitives
- **State Management**: React Server Components + Server Actions
- **Deployment**: Vercel
- **Future Integrations**: 
  - Zapier for performance data collection
  - Buffer, WordPress, Mailchimp for content scheduling

## Core Features (MVP - Phase 1)
1. Authentication System (✓ Completed)
   - Email/Password authentication
   - Email verification
   - Password reset functionality
   - Protected routes
   - Session management

2. Business Profile Management
   - Company information
   - Industry selection
   - Target audience definition
   - Competitor analysis
   - Core offer details

3. Content Bundle Generation
   - Social media posts
   - SEO blog posts
   - Content upgrades/Lead magnets
   - Email nurture sequences
   - Sales sequences

4. Bundle Management & Delivery
   - Bundle preview
   - ZIP/Drive export
   - Purchase history
   - Download management

## Project Structure
```
mosaic/
├── app/                    # Next.js 14 app directory
│   ├── (auth-pages)/      # Authentication-related pages
│   ├── auth/              # Auth API routes
│   ├── dashboard/         # User dashboard
│   ├── profile/          # Business profile management
│   └── bundles/          # Bundle generation & management
├── components/            # Reusable React components
├── lib/                  # Core business logic
│   ├── crewai/           # AI generation system
│   └── content/          # Content processing utilities
├── utils/                # Utility functions and helpers
│   ├── supabase/         # Supabase client and middleware
│   └── routes.ts         # Route definitions
├── middleware.ts         # Global Next.js middleware
└── docs/                 # Project documentation
```

## Getting Started
1. Clone the repository
2. Copy `.env.example` to `.env.local` and fill in the required environment variables
3. Install dependencies: `npm install`
4. Run development server: `npm run dev`

## Environment Variables
Required environment variables for the project:
- `NEXT_PUBLIC_SUPABASE_URL`: Supabase project URL
- `NEXT_PUBLIC_SUPABASE_ANON_KEY`: Supabase anonymous key
- `SUPABASE_SERVICE_ROLE_KEY`: Supabase service role key
- `RESEND_API_KEY`: API key for email service
- `OPENAI_API_KEY`: OpenAI API key for CrewAI
- Additional environment variables as needed

## Development Workflow
1. Feature branches should be created from `main`
2. Pull requests should include relevant tests and documentation
3. Code should follow the established patterns and best practices
4. All commits should use conventional commit messages

## Documentation Structure
- `/docs/architecture/`: System design and technical decisions
  - `auth-flow.md`: Authentication system design
  - `ai-pipeline.md`: CrewAI integration architecture
  - `database-schema.md`: Supabase database structure
  
- `/docs/guides/`: Development guides and tutorials
  - `content-generation.md`: How the AI content pipeline works
  - `bundle-creation.md`: Bundle assembly process
  - `testing.md`: Testing guidelines
  
- `/docs/api/`: API documentation
  - `endpoints.md`: API endpoint documentation
  - `models.md`: Data models and types
  
- `/docs/deployment/`: Deployment procedures
  - `vercel.md`: Vercel deployment guide
  - `environment.md`: Environment setup guide

## Monetization Model
- Pay-per-bundle pricing
- Volume discounts for larger bundles
- Future subscription features planned
- See `docs/mosaic.md` for detailed pricing strategy

## Development Phases
1. **MVP Launch** (Current)
   - Core authentication ✓
   - Basic profile management
   - Initial bundle generation
   - Payment processing
   
2. **Optimization** (Next)
   - Upsells
   - Performance tracking
   - Enhanced AI generation

3. **Automation** (Future)
   - Content scheduling
   - Platform integrations
   - Analytics dashboard
