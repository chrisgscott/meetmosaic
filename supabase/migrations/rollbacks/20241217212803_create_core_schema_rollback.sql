-- Drop indexes first
DROP INDEX IF EXISTS idx_content_bundles_business;
DROP INDEX IF EXISTS idx_social_posts_bundle;
DROP INDEX IF EXISTS idx_blog_posts_bundle;
DROP INDEX IF EXISTS idx_content_upgrades_bundle;
DROP INDEX IF EXISTS idx_email_sequences_bundle;
DROP INDEX IF EXISTS idx_emails_sequence;

-- Drop tables in reverse order of dependencies
DROP TABLE IF EXISTS emails;
DROP TABLE IF EXISTS email_sequences;
DROP TABLE IF EXISTS content_upgrades;
DROP TABLE IF EXISTS blog_posts;
DROP TABLE IF EXISTS social_posts;
DROP TABLE IF EXISTS content_bundles;
DROP TABLE IF EXISTS businesses;
