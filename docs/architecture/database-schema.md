# Database Schema Design

## Overview
The database is designed to support a comprehensive content generation and management platform. It handles everything from business profiles and content creation to payment processing and API integrations. The schema is built on Supabase PostgreSQL with Row Level Security (RLS) enabled for all tables.

## Core Content Tables

### 1. businesses
The central table that stores business profiles and content generation preferences. Each business represents a customer using our platform.

```sql
CREATE TABLE businesses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    profile_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),

    -- Basic Info
    name TEXT NOT NULL,
    industry TEXT NOT NULL,
    website TEXT,
    
    -- Business Overview
    business_type TEXT NOT NULL,
    primary_product TEXT NOT NULL,
    core_offer_description TEXT NOT NULL,
    
    -- Target Audience
    audience_demographics JSONB NOT NULL DEFAULT '{}'::jsonb,  -- age, gender, location, income
    audience_psychographics JSONB NOT NULL DEFAULT '{}'::jsonb, -- goals, values, interests
    audience_job_role TEXT,
    audience_pain_points TEXT[],
    audience_desired_outcomes TEXT[],
    
    -- Content Strategy
    primary_topics TEXT[],
    tone_of_voice TEXT,
    brand_keywords TEXT[],
    competitors TEXT[],
    
    -- Content Preferences
    primary_cta TEXT,
    awareness_stage TEXT,
    promotions JSONB[],
    
    -- Platform Preferences
    social_platforms TEXT[],
    platform_preferences JSONB,  -- specific requirements per platform
    competitor_social_accounts TEXT[],
    
    -- Blog Preferences
    blog_style TEXT,
    content_upgrade_type TEXT,
    
    -- Email Preferences
    email_tone TEXT,
    email_frequency TEXT,
    list_building_goals TEXT[],
    
    -- Goals
    primary_content_goal TEXT,
    revenue_targets TEXT
);
```

Key Features:
- Links to Supabase auth system via `profile_id`
- Comprehensive business profiling for AI content generation
- Flexible JSONB fields for evolving preferences
- Separate sections for different content types

### 2. content_bundles
Organizes generated content into logical groups, typically by time period or campaign.

```sql
CREATE TABLE content_bundles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    business_id UUID REFERENCES businesses(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    
    name TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'draft',
    generation_date DATE NOT NULL DEFAULT CURRENT_DATE,
    time_period TEXT NOT NULL  -- e.g., 'Q1 2024', 'January 2024'
);
```

Key Features:
- Groups related content together
- Tracks content generation progress
- Enables bulk operations on content sets

### 3. social_posts
Stores social media content with platform-specific formatting and metrics.

```sql
CREATE TABLE social_posts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    bundle_id UUID REFERENCES content_bundles(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    
    platform TEXT NOT NULL,
    content TEXT NOT NULL,
    media_prompts TEXT[],
    hashtags TEXT[],
    scheduled_for TIMESTAMP WITH TIME ZONE,
    engagement_metrics JSONB DEFAULT '{}'::jsonb,
    post_type TEXT,  -- e.g., 'carousel', 'single', 'video'
    
    -- A/B Testing
    is_variant BOOLEAN DEFAULT false,
    variant_group_id UUID,
    is_winner BOOLEAN,
    winning_threshold INTEGER  -- engagement difference needed to declare winner
);
```

Key Features:
- Platform-specific content formatting
- Built-in A/B testing capabilities
- Engagement tracking
- Media generation prompts

### 4. blog_posts
Manages long-form content with SEO optimization and performance tracking.

```sql
CREATE TABLE blog_posts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    bundle_id UUID REFERENCES content_bundles(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    meta_description TEXT,
    keywords TEXT[],
    estimated_reading_time INTEGER,
    primary_cta TEXT,
    performance_metrics JSONB DEFAULT '{}'::jsonb,
    
    -- A/B Testing
    is_variant BOOLEAN DEFAULT false,
    variant_group_id UUID,
    is_winner BOOLEAN,
    winning_threshold INTEGER
);
```

Key Features:
- SEO metadata fields
- Performance tracking
- A/B testing support
- Content upgrade linking

### 5. content_upgrades
Manages downloadable content used for lead generation.

```sql
CREATE TABLE content_upgrades (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    blog_post_id UUID REFERENCES blog_posts(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    
    title TEXT NOT NULL,
    type TEXT NOT NULL,  -- e.g., 'checklist', 'template', 'guide'
    content TEXT NOT NULL,
    download_metrics JSONB DEFAULT '{}'::jsonb
);
```

Key Features:
- Links to parent blog posts
- Download tracking
- Various content types
- Lead generation metrics

### 6. email_sequences
Organizes email marketing campaigns and nurture sequences.

```sql
CREATE TABLE email_sequences (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    bundle_id UUID REFERENCES content_bundles(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    
    sequence_type TEXT NOT NULL,  -- e.g., 'nurture', 'sales', 'onboarding'
    sequence_name TEXT NOT NULL,
    total_emails INTEGER NOT NULL
);
```

Key Features:
- Different sequence types
- Campaign organization
- Email flow management

### 7. emails
Individual email content within sequences.

```sql
CREATE TABLE emails (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sequence_id UUID REFERENCES email_sequences(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    
    subject_line TEXT NOT NULL,
    content TEXT NOT NULL,
    sequence_position INTEGER NOT NULL,
    delay_days INTEGER,  -- days after previous email
    performance_metrics JSONB DEFAULT '{}'::jsonb,
    
    -- A/B Testing
    is_variant BOOLEAN DEFAULT false,
    variant_group_id UUID,
    is_winner BOOLEAN,
    winning_threshold INTEGER
);
```

Key Features:
- Email sequencing
- Timing controls
- Performance tracking
- A/B testing support

## Content Flow Relationships

The platform implements a sophisticated content journey system that connects different content types together, creating a cohesive user experience. The typical flow is:

```
Social Post -> Blog Post -> Content Upgrade -> Email Sequence
```

Each content type includes the following flow-related fields:
- `next_action_type`: Type of the next content in the journey
- `next_action_id`: UUID reference to the next content
- `previous_action_type`: Type of the previous content
- `previous_action_id`: UUID reference to the previous content
- `conversion_goal`: Primary goal for this content piece
- `cta_text`: Call-to-action text (where applicable)
- `cta_url`: Call-to-action URL (where applicable)

### Valid Next Actions

Each content type has specific constraints on valid next actions:

- **Social Posts**: Can link to `blog_post` or `content_upgrade`
- **Blog Posts**: Can link to `content_upgrade` or `email_sequence`
- **Content Upgrades**: Can link to `email_sequence`
- **Email Sequences**: Can link to `blog_post` or `content_upgrade`

### Content Goals

Different content types have specific conversion goals:
- **Social Posts**: `website_visit`, `lead_magnet`, `sale`
- **Blog Posts**: `lead_magnet`, `sale`, `share`
- **Content Upgrades**: `email_signup`, `sale`, `share`
- **Email Sequences**: `sale`, `referral`, `testimonial`
  - Additional `sequence_goal`: `nurture`, `onboarding`, `sales`, `retention`

## Core Content Tables

### Blog Posts Table (`blog_posts`)

Stores all blog post content and metadata.

```sql
CREATE TABLE blog_posts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    business_id UUID REFERENCES businesses(id) NOT NULL,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'draft',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    published_at TIMESTAMPTZ,
    next_action_type TEXT,
    next_action_id UUID,
    previous_action_type TEXT,
    previous_action_id UUID,
    conversion_goal TEXT NOT NULL DEFAULT 'lead_magnet',
    cta_text TEXT,
    cta_url TEXT,
    CONSTRAINT blog_posts_valid_next_action CHECK (next_action_type IN ('content_upgrade', 'email_sequence'))
);
```

### Social Posts Table (`social_posts`)

Manages social media content across different platforms.

```sql
CREATE TABLE social_posts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    business_id UUID REFERENCES businesses(id) NOT NULL,
    platform TEXT NOT NULL,
    content TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'draft',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    scheduled_for TIMESTAMPTZ,
    next_action_type TEXT,
    next_action_id UUID,
    previous_action_type TEXT,
    previous_action_id UUID,
    conversion_goal TEXT NOT NULL DEFAULT 'website_visit',
    cta_text TEXT,
    cta_url TEXT,
    CONSTRAINT social_posts_valid_next_action CHECK (next_action_type IN ('blog_post', 'content_upgrade'))
);
```

### Content Upgrades Table (`content_upgrades`)

Stores lead magnets and other downloadable content.

```sql
CREATE TABLE content_upgrades (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    business_id UUID REFERENCES businesses(id) NOT NULL,
    title TEXT NOT NULL,
    description TEXT,
    file_url TEXT,
    status TEXT NOT NULL DEFAULT 'draft',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    next_action_type TEXT,
    next_action_id UUID,
    previous_action_type TEXT,
    previous_action_id UUID,
    conversion_goal TEXT NOT NULL DEFAULT 'email_signup',
    cta_text TEXT,
    cta_url TEXT,
    CONSTRAINT content_upgrades_valid_next_action CHECK (next_action_type IN ('email_sequence'))
);
```

### Email Sequences Table (`email_sequences`)

Manages email marketing sequences and automation.

```sql
CREATE TABLE email_sequences (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    business_id UUID REFERENCES businesses(id) NOT NULL,
    name TEXT NOT NULL,
    description TEXT,
    status TEXT NOT NULL DEFAULT 'draft',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    next_action_type TEXT,
    next_action_id UUID,
    previous_action_type TEXT,
    previous_action_id UUID,
    conversion_goal TEXT NOT NULL DEFAULT 'sale',
    sequence_goal TEXT NOT NULL DEFAULT 'nurture',
    CONSTRAINT email_sequences_valid_next_action CHECK (next_action_type IN ('blog_post', 'content_upgrade'))
);
```

## Payment Infrastructure

### 8. bundle_products
Product catalog for content bundles and subscriptions.

```sql
CREATE TABLE bundle_products (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    
    name TEXT NOT NULL,
    description TEXT NOT NULL,
    type TEXT NOT NULL,  -- 'social', 'blog', 'email', 'upgrade'
    
    -- Product details
    content_count INTEGER NOT NULL,  -- e.g., 365 social posts, 12 blog posts
    time_period TEXT NOT NULL,       -- e.g., '1 year', '1 quarter'
    features JSONB NOT NULL,         -- array of included features
    
    -- Pricing
    base_price INTEGER NOT NULL,     -- in cents
    is_active BOOLEAN DEFAULT true,
    
    -- Optional volume discount tiers
    volume_discounts JSONB DEFAULT '[]'::jsonb
);
```

Key Features:
- Flexible product configuration
- Volume pricing support
- Feature tracking
- Multiple content types

### 9. orders
Tracks customer purchases and payment processing.

```sql
CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    business_id UUID REFERENCES businesses(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    
    status TEXT NOT NULL DEFAULT 'pending',  -- pending, paid, failed, refunded
    total_amount INTEGER NOT NULL,           -- in cents
    currency TEXT NOT NULL DEFAULT 'usd',
    
    -- Payment details
    payment_intent_id TEXT,          -- Stripe payment intent ID
    payment_status TEXT,
    payment_method TEXT,
    
    -- Metadata
    metadata JSONB DEFAULT '{}'::jsonb
);
```

Key Features:
- Stripe integration
- Order status tracking
- Multiple currency support
- Flexible metadata

### 10. order_items
Individual items within an order.

```sql
CREATE TABLE order_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id UUID REFERENCES orders(id) ON DELETE CASCADE,
    product_id UUID REFERENCES bundle_products(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    
    quantity INTEGER NOT NULL DEFAULT 1,
    unit_price INTEGER NOT NULL,      -- in cents
    subtotal INTEGER NOT NULL,        -- in cents
    discount_amount INTEGER DEFAULT 0, -- in cents
    
    -- Links to generated content
    content_bundle_id UUID REFERENCES content_bundles(id),
    
    -- Configuration options
    options JSONB DEFAULT '{}'::jsonb  -- product-specific options
);
```

Key Features:
- Quantity and pricing tracking
- Discount support
- Links to generated content
- Custom options

### 11. subscriptions
Manages recurring billing and feature access.

```sql
CREATE TABLE subscriptions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    business_id UUID REFERENCES businesses(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    
    status TEXT NOT NULL,              -- active, canceled, past_due
    plan_type TEXT NOT NULL,           -- optimization, scheduling, analytics
    current_period_start TIMESTAMP WITH TIME ZONE NOT NULL,
    current_period_end TIMESTAMP WITH TIME ZONE NOT NULL,
    
    -- Stripe subscription details
    stripe_subscription_id TEXT,
    stripe_customer_id TEXT,
    
    -- Plan details
    monthly_price INTEGER NOT NULL,    -- in cents
    features JSONB NOT NULL,           -- array of included features
    
    -- Usage tracking
    usage_limits JSONB NOT NULL,
    current_usage JSONB DEFAULT '{}'::jsonb
);
```

Key Features:
- Stripe subscription integration
- Usage tracking
- Feature management
- Period tracking

### 12. subscription_invoices
Tracks recurring payments for subscriptions.

```sql
CREATE TABLE subscription_invoices (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    subscription_id UUID REFERENCES subscriptions(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    
    amount INTEGER NOT NULL,          -- in cents
    status TEXT NOT NULL,            -- paid, pending, failed
    billing_period_start TIMESTAMP WITH TIME ZONE NOT NULL,
    billing_period_end TIMESTAMP WITH TIME ZONE NOT NULL,
    
    stripe_invoice_id TEXT,
    payment_intent_id TEXT
);
```

Key Features:
- Invoice tracking
- Period management
- Payment status
- Stripe integration

### 13. feature_flags
Controls feature availability and rollout.

```sql
CREATE TABLE feature_flags (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    
    name TEXT NOT NULL UNIQUE,
    description TEXT,
    is_enabled BOOLEAN DEFAULT false,
    
    -- Optional targeting rules
    rules JSONB DEFAULT '{}'::jsonb,
    
    -- Metadata
    metadata JSONB DEFAULT '{}'::jsonb
);
```

Key Features:
- Feature toggling
- Targeted rollouts
- Business rules
- Metadata tracking

## API Integration

### 14. api_keys
Enables programmatic access to the platform.

```sql
CREATE TABLE api_keys (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    business_id UUID REFERENCES businesses(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    
    key_hash TEXT NOT NULL,           -- hashed API key
    name TEXT NOT NULL,               -- user-provided name for the key
    last_used_at TIMESTAMP WITH TIME ZONE,
    expires_at TIMESTAMP WITH TIME ZONE,
    is_active BOOLEAN DEFAULT true,
    
    -- Permissions
    scopes TEXT[] NOT NULL,           -- array of permitted actions
    rate_limit INTEGER DEFAULT 1000,  -- requests per hour
    
    -- Usage tracking
    usage_count INTEGER DEFAULT 0
);
```

Key Features:
- Secure key management
- Usage tracking
- Rate limiting
- Scope-based permissions

## Future Tables

### 15. audit_logs
Tracks all changes to content and configuration.

```sql
CREATE TABLE audit_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    
    entity_type TEXT NOT NULL,    -- 'blog_post', 'social_post', etc.
    entity_id UUID NOT NULL,
    action TEXT NOT NULL,         -- 'create', 'update', 'delete'
    actor_id UUID NOT NULL,       -- profile_id of who made the change
    changes JSONB NOT NULL,       -- what changed
    
    -- For tracking AI-generated changes
    ai_generated BOOLEAN DEFAULT false,
    ai_model TEXT,
    ai_prompt TEXT
);
```

Key Features:
- Complete audit trail
- AI generation tracking
- Change history
- Actor tracking

### 16. content_versions
Stores version history for all content types.

```sql
CREATE TABLE content_versions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    
    entity_type TEXT NOT NULL,    -- 'blog_post', 'social_post', etc.
    entity_id UUID NOT NULL,
    version_number INTEGER NOT NULL,
    content TEXT NOT NULL,
    
    -- Metadata
    reason TEXT,                  -- why this version was created
    performance_snapshot JSONB,   -- metrics at time of version
    created_by UUID NOT NULL      -- profile_id or AI identifier
);
```

Key Features:
- Version control
- Performance tracking
- Change reasoning
- Creator tracking

### 17. esp_integrations
Manages email service provider integrations.

```sql
CREATE TABLE esp_integrations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    
    business_id UUID REFERENCES businesses(id) ON DELETE CASCADE,
    provider TEXT NOT NULL,       -- 'mailchimp', 'convertkit', etc.
    credentials JSONB NOT NULL,   -- encrypted API keys, etc.
    settings JSONB NOT NULL,      -- provider-specific settings
    
    -- Sync status
    last_sync_at TIMESTAMP WITH TIME ZONE,
    sync_status TEXT,
    error_log JSONB
);
```

Key Features:
- Multiple ESP support
- Secure credential storage
- Sync tracking
- Error logging

### 18. managed_urls
Tracks and manages all generated URLs.

```sql
CREATE TABLE managed_urls (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    
    business_id UUID REFERENCES businesses(id) ON DELETE CASCADE,
    source_type TEXT NOT NULL,    -- 'blog_post', 'content_upgrade', etc.
    source_id UUID NOT NULL,
    url TEXT NOT NULL,
    utm_params JSONB,
    
    -- For tracking
    click_count INTEGER DEFAULT 0,
    last_checked_at TIMESTAMP WITH TIME ZONE,
    is_valid BOOLEAN DEFAULT true
);
```

Key Features:
- URL management
- Click tracking
- UTM parameter tracking
- Link validation

## Realtime Configuration
The following tables have realtime updates enabled:
- `content_bundles`
- `social_posts`
- `blog_posts`
- `email_sequences`
- `orders`
- `feature_flags`
- `esp_integrations`

## Security
All tables have Row Level Security (RLS) enabled with policies that:
1. Restrict access to business-owned data
2. Allow admin access where appropriate
3. Enable proper sharing and collaboration
4. Prevent unauthorized access

## Indexes
Indexes are created on frequently queried fields and foreign keys to optimize performance. Key indexes include:
- Business ID references
- Status fields
- Creation dates
- Search fields
- Foreign key relationships
