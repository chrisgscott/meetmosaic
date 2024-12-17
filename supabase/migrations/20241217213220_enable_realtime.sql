
-- Enable realtime for specific tables
ALTER PUBLICATION supabase_realtime ADD TABLE content_bundles;  -- For real-time status updates
ALTER PUBLICATION supabase_realtime ADD TABLE social_posts;     -- For collaborative editing
ALTER PUBLICATION supabase_realtime ADD TABLE blog_posts;       -- For collaborative editing
ALTER PUBLICATION supabase_realtime ADD TABLE email_sequences;  -- For sequence status updates
ALTER PUBLICATION supabase_realtime ADD TABLE orders;           -- For order status updates
ALTER PUBLICATION supabase_realtime ADD TABLE feature_flags;    -- For immediate feature updates

-- Create publication for specific columns to optimize performance
CREATE PUBLICATION supabase_realtime_selective WITH (publish = 'insert, update, delete');

-- Add tables with specific columns
ALTER PUBLICATION supabase_realtime_selective ADD TABLE content_bundles (id, status, updated_at);
ALTER PUBLICATION supabase_realtime_selective ADD TABLE social_posts (id, version, is_winner, performance_metrics);
ALTER PUBLICATION supabase_realtime_selective ADD TABLE blog_posts (id, version, is_winner, performance_metrics);
ALTER PUBLICATION supabase_realtime_selective ADD TABLE email_sequences (id, version, is_winner, performance_metrics);
ALTER PUBLICATION supabase_realtime_selective ADD TABLE orders (id, status, payment_status);
ALTER PUBLICATION supabase_realtime_selective ADD TABLE feature_flags (id, is_enabled, rules);