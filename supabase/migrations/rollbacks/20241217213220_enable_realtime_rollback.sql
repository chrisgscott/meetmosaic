-- Disable realtime for all tables
ALTER PUBLICATION supabase_realtime DROP TABLE IF EXISTS content_bundles;
ALTER PUBLICATION supabase_realtime DROP TABLE IF EXISTS social_posts;
ALTER PUBLICATION supabase_realtime DROP TABLE IF EXISTS blog_posts;
ALTER PUBLICATION supabase_realtime DROP TABLE IF EXISTS email_sequences;
ALTER PUBLICATION supabase_realtime DROP TABLE IF EXISTS orders;
ALTER PUBLICATION supabase_realtime DROP TABLE IF EXISTS feature_flags;

-- Drop selective publications
ALTER PUBLICATION supabase_realtime_selective DROP TABLE IF EXISTS content_bundles;
ALTER PUBLICATION supabase_realtime_selective DROP TABLE IF EXISTS social_posts;
ALTER PUBLICATION supabase_realtime_selective DROP TABLE IF EXISTS blog_posts;
ALTER PUBLICATION supabase_realtime_selective DROP TABLE IF EXISTS email_sequences;
ALTER PUBLICATION supabase_realtime_selective DROP TABLE IF EXISTS orders;
ALTER PUBLICATION supabase_realtime_selective DROP TABLE IF EXISTS feature_flags;
