
-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Businesses table
CREATE TABLE businesses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    
    profile_id UUID NOT NULL,
    name TEXT NOT NULL,
    industry TEXT NOT NULL,
    website_url TEXT,
    blog_url_structure TEXT,
    
    -- Business details
    overview TEXT NOT NULL,
    target_audience TEXT NOT NULL,
    content_strategy TEXT NOT NULL,
    social_media_preferences JSONB NOT NULL,
    
    -- Demographics and psychographics
    audience_demographics JSONB NOT NULL,
    audience_psychographics JSONB NOT NULL
);

-- Content bundles table
CREATE TABLE content_bundles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    
    business_id UUID REFERENCES businesses(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'draft',
    generation_date TIMESTAMP WITH TIME ZONE
);

-- Social posts table
CREATE TABLE social_posts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    
    bundle_id UUID REFERENCES content_bundles(id) ON DELETE CASCADE,
    platform TEXT NOT NULL,
    content TEXT NOT NULL,
    media_prompt TEXT,
    version INTEGER DEFAULT 1,
    
    -- Performance metrics
    performance_metrics JSONB DEFAULT '{}'::jsonb,
    
    -- A/B testing
    is_winner BOOLEAN,
    winning_threshold NUMERIC
);

-- Blog posts table
CREATE TABLE blog_posts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    
    bundle_id UUID REFERENCES content_bundles(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    version INTEGER DEFAULT 1,
    
    -- SEO metadata
    meta_description TEXT,
    keywords TEXT[],
    slug TEXT,
    
    -- Performance metrics
    performance_metrics JSONB DEFAULT '{}'::jsonb,
    
    -- A/B testing
    is_winner BOOLEAN,
    winning_threshold NUMERIC
);

-- Content upgrades table
CREATE TABLE content_upgrades (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    
    blog_post_id UUID REFERENCES blog_posts(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT NOT NULL,
    content TEXT NOT NULL,
    version INTEGER DEFAULT 1,
    
    -- Performance metrics
    performance_metrics JSONB DEFAULT '{}'::jsonb,
    
    -- A/B testing
    is_winner BOOLEAN,
    winning_threshold NUMERIC
);

-- Email sequences table
CREATE TABLE email_sequences (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    
    bundle_id UUID REFERENCES content_bundles(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    sequence_type TEXT NOT NULL,
    description TEXT,
    version INTEGER DEFAULT 1,
    
    -- Performance metrics
    performance_metrics JSONB DEFAULT '{}'::jsonb,
    
    -- A/B testing
    is_winner BOOLEAN,
    winning_threshold NUMERIC
);

-- Emails table
CREATE TABLE emails (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    
    sequence_id UUID REFERENCES email_sequences(id) ON DELETE CASCADE,
    subject_line TEXT NOT NULL,
    content TEXT NOT NULL,
    sequence_position INTEGER NOT NULL,
    version INTEGER DEFAULT 1,
    
    -- Performance metrics
    performance_metrics JSONB DEFAULT '{}'::jsonb,
    
    -- A/B testing
    is_winner BOOLEAN,
    winning_threshold NUMERIC
);

-- Create indexes for core schema
CREATE INDEX idx_businesses_profile_id ON businesses(profile_id);
CREATE INDEX idx_content_bundles_business_id ON content_bundles(business_id);
CREATE INDEX idx_social_posts_bundle_id ON social_posts(bundle_id);
CREATE INDEX idx_blog_posts_bundle_id ON blog_posts(bundle_id);
CREATE INDEX idx_content_upgrades_blog_post_id ON content_upgrades(blog_post_id);
CREATE INDEX idx_email_sequences_bundle_id ON email_sequences(bundle_id);
CREATE INDEX idx_emails_sequence_id ON emails(sequence_id);
CREATE INDEX idx_emails_sequence_position ON emails(sequence_position);