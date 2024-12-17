-- Drop indexes first
DROP INDEX IF EXISTS idx_blog_posts_next_action;
DROP INDEX IF EXISTS idx_social_posts_next_action;
DROP INDEX IF EXISTS idx_content_upgrades_next_action;
DROP INDEX IF EXISTS idx_email_sequences_next_action;
DROP INDEX IF EXISTS idx_emails_next_action;

-- Remove columns from blog posts
ALTER TABLE blog_posts
DROP COLUMN IF EXISTS next_action_type,
DROP COLUMN IF EXISTS next_action_id,
DROP COLUMN IF EXISTS previous_action_type,
DROP COLUMN IF EXISTS previous_action_id,
DROP COLUMN IF EXISTS conversion_goal,
DROP COLUMN IF EXISTS cta_text,
DROP COLUMN IF EXISTS cta_url;

-- Remove columns from social posts
ALTER TABLE social_posts
DROP COLUMN IF EXISTS next_action_type,
DROP COLUMN IF EXISTS next_action_id,
DROP COLUMN IF EXISTS previous_action_type,
DROP COLUMN IF EXISTS previous_action_id,
DROP COLUMN IF EXISTS conversion_goal,
DROP COLUMN IF EXISTS cta_text,
DROP COLUMN IF EXISTS cta_url;

-- Remove columns from content upgrades
ALTER TABLE content_upgrades
DROP COLUMN IF EXISTS next_action_type,
DROP COLUMN IF EXISTS next_action_id,
DROP COLUMN IF EXISTS previous_action_type,
DROP COLUMN IF EXISTS previous_action_id,
DROP COLUMN IF EXISTS conversion_goal,
DROP COLUMN IF EXISTS cta_text,
DROP COLUMN IF EXISTS cta_url;

-- Remove columns from email sequences
ALTER TABLE email_sequences
DROP COLUMN IF EXISTS next_action_type,
DROP COLUMN IF EXISTS next_action_id,
DROP COLUMN IF EXISTS previous_action_type,
DROP COLUMN IF EXISTS previous_action_id,
DROP COLUMN IF EXISTS conversion_goal,
DROP COLUMN IF EXISTS sequence_goal;

-- Remove columns from emails
ALTER TABLE emails
DROP COLUMN IF EXISTS next_action_type,
DROP COLUMN IF EXISTS next_action_id,
DROP COLUMN IF EXISTS previous_action_type,
DROP COLUMN IF EXISTS previous_action_id,
DROP COLUMN IF EXISTS cta_text,
DROP COLUMN IF EXISTS cta_url;
