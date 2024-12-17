-- Drop all RLS policies
DROP POLICY IF EXISTS businesses_access_policy ON businesses;
DROP POLICY IF EXISTS content_bundles_access_policy ON content_bundles;
DROP POLICY IF EXISTS social_posts_access_policy ON social_posts;
DROP POLICY IF EXISTS blog_posts_access_policy ON blog_posts;
DROP POLICY IF EXISTS content_upgrades_access_policy ON content_upgrades;
DROP POLICY IF EXISTS email_sequences_access_policy ON email_sequences;
DROP POLICY IF EXISTS emails_access_policy ON emails;
DROP POLICY IF EXISTS bundle_products_access_policy ON bundle_products;
DROP POLICY IF EXISTS orders_access_policy ON orders;
DROP POLICY IF EXISTS order_items_access_policy ON order_items;
DROP POLICY IF EXISTS subscriptions_access_policy ON subscriptions;
DROP POLICY IF EXISTS subscription_invoices_access_policy ON subscription_invoices;
DROP POLICY IF EXISTS feature_flags_access_policy ON feature_flags;
DROP POLICY IF EXISTS api_keys_access_policy ON api_keys;

-- Disable RLS on all tables
ALTER TABLE businesses DISABLE ROW LEVEL SECURITY;
ALTER TABLE content_bundles DISABLE ROW LEVEL SECURITY;
ALTER TABLE social_posts DISABLE ROW LEVEL SECURITY;
ALTER TABLE blog_posts DISABLE ROW LEVEL SECURITY;
ALTER TABLE content_upgrades DISABLE ROW LEVEL SECURITY;
ALTER TABLE email_sequences DISABLE ROW LEVEL SECURITY;
ALTER TABLE emails DISABLE ROW LEVEL SECURITY;
ALTER TABLE bundle_products DISABLE ROW LEVEL SECURITY;
ALTER TABLE orders DISABLE ROW LEVEL SECURITY;
ALTER TABLE order_items DISABLE ROW LEVEL SECURITY;
ALTER TABLE subscriptions DISABLE ROW LEVEL SECURITY;
ALTER TABLE subscription_invoices DISABLE ROW LEVEL SECURITY;
ALTER TABLE feature_flags DISABLE ROW LEVEL SECURITY;
ALTER TABLE api_keys DISABLE ROW LEVEL SECURITY;

-- Drop helper functions
DROP FUNCTION IF EXISTS is_admin();
DROP FUNCTION IF EXISTS owns_business(business_uuid UUID);
