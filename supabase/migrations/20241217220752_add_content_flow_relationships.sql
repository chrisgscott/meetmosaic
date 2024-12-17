-- Add content flow relationships to blog posts
ALTER TABLE blog_posts
ADD COLUMN next_action_type TEXT, -- 'content_upgrade', 'social_post', 'email_sequence'
ADD COLUMN next_action_id UUID,
ADD COLUMN previous_action_type TEXT,
ADD COLUMN previous_action_id UUID,
ADD COLUMN conversion_goal TEXT NOT NULL DEFAULT 'lead_magnet', -- 'lead_magnet', 'sale', 'share'
ADD COLUMN cta_text TEXT,
ADD COLUMN cta_url TEXT;

-- Add constraints to validate action types
ALTER TABLE blog_posts
ADD CONSTRAINT blog_posts_valid_next_action 
CHECK (next_action_type IN ('content_upgrade', 'email_sequence'));

-- Add content flow relationships to social posts
ALTER TABLE social_posts
ADD COLUMN next_action_type TEXT, -- 'blog_post', 'content_upgrade', 'email_sequence'
ADD COLUMN next_action_id UUID,
ADD COLUMN previous_action_type TEXT,
ADD COLUMN previous_action_id UUID,
ADD COLUMN conversion_goal TEXT NOT NULL DEFAULT 'website_visit', -- 'website_visit', 'lead_magnet', 'sale'
ADD COLUMN cta_text TEXT,
ADD COLUMN cta_url TEXT;

-- Add constraints to validate action types
ALTER TABLE social_posts
ADD CONSTRAINT social_posts_valid_next_action 
CHECK (next_action_type IN ('blog_post', 'content_upgrade'));

-- Add content flow relationships to content upgrades
ALTER TABLE content_upgrades
ADD COLUMN next_action_type TEXT, -- 'email_sequence', 'social_post', 'blog_post'
ADD COLUMN next_action_id UUID,
ADD COLUMN previous_action_type TEXT,
ADD COLUMN previous_action_id UUID,
ADD COLUMN conversion_goal TEXT NOT NULL DEFAULT 'email_signup', -- 'email_signup', 'sale', 'share'
ADD COLUMN cta_text TEXT,
ADD COLUMN cta_url TEXT;

-- Add constraints to validate action types
ALTER TABLE content_upgrades
ADD CONSTRAINT content_upgrades_valid_next_action 
CHECK (next_action_type IN ('email_sequence'));

-- Add content flow relationships to email sequences
ALTER TABLE email_sequences
ADD COLUMN next_action_type TEXT, -- 'blog_post', 'social_post', 'content_upgrade'
ADD COLUMN next_action_id UUID,
ADD COLUMN previous_action_type TEXT,
ADD COLUMN previous_action_id UUID,
ADD COLUMN conversion_goal TEXT NOT NULL DEFAULT 'sale', -- 'sale', 'referral', 'testimonial'
ADD COLUMN sequence_goal TEXT NOT NULL DEFAULT 'nurture'; -- 'nurture', 'onboarding', 'sales', 'retention'

-- Add constraints to validate action types
ALTER TABLE email_sequences
ADD CONSTRAINT email_sequences_valid_next_action 
CHECK (next_action_type IN ('blog_post', 'content_upgrade'));

-- Add content flow relationships to individual emails
ALTER TABLE emails
ADD COLUMN next_action_type TEXT,
ADD COLUMN next_action_id UUID,
ADD COLUMN previous_action_type TEXT,
ADD COLUMN previous_action_id UUID,
ADD COLUMN cta_text TEXT,
ADD COLUMN cta_url TEXT;

-- Create indexes for content flow queries
CREATE INDEX idx_blog_posts_next_action ON blog_posts(next_action_type, next_action_id);
CREATE INDEX idx_social_posts_next_action ON social_posts(next_action_type, next_action_id);
CREATE INDEX idx_content_upgrades_next_action ON content_upgrades(next_action_type, next_action_id);
CREATE INDEX idx_email_sequences_next_action ON email_sequences(next_action_type, next_action_id);
CREATE INDEX idx_emails_next_action ON emails(next_action_type, next_action_id);

COMMENT ON COLUMN blog_posts.next_action_type IS 'Type of content that follows this blog post in the customer journey';
COMMENT ON COLUMN blog_posts.next_action_id IS 'ID of the next piece of content in the customer journey';
COMMENT ON COLUMN blog_posts.conversion_goal IS 'Primary conversion goal for this blog post';

COMMENT ON COLUMN social_posts.next_action_type IS 'Type of content that follows this social post in the customer journey';
COMMENT ON COLUMN social_posts.next_action_id IS 'ID of the next piece of content in the customer journey';
COMMENT ON COLUMN social_posts.conversion_goal IS 'Primary conversion goal for this social post';

COMMENT ON COLUMN content_upgrades.next_action_type IS 'Type of content that follows this content upgrade in the customer journey';
COMMENT ON COLUMN content_upgrades.next_action_id IS 'ID of the next piece of content in the customer journey';
COMMENT ON COLUMN content_upgrades.conversion_goal IS 'Primary conversion goal for this content upgrade';

COMMENT ON COLUMN email_sequences.next_action_type IS 'Type of content that follows this email sequence in the customer journey';
COMMENT ON COLUMN email_sequences.next_action_id IS 'ID of the next piece of content in the customer journey';
COMMENT ON COLUMN email_sequences.conversion_goal IS 'Primary conversion goal for this email sequence';
COMMENT ON COLUMN email_sequences.sequence_goal IS 'Primary goal of this email sequence in the customer journey';
