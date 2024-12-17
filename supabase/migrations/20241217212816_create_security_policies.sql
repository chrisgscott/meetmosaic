
-- Enable Row Level Security on all tables
ALTER TABLE businesses ENABLE ROW LEVEL SECURITY;
ALTER TABLE content_bundles ENABLE ROW LEVEL SECURITY;
ALTER TABLE social_posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE blog_posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE content_upgrades ENABLE ROW LEVEL SECURITY;
ALTER TABLE email_sequences ENABLE ROW LEVEL SECURITY;
ALTER TABLE emails ENABLE ROW LEVEL SECURITY;
ALTER TABLE bundle_products ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE subscription_invoices ENABLE ROW LEVEL SECURITY;
ALTER TABLE feature_flags ENABLE ROW LEVEL SECURITY;
ALTER TABLE api_keys ENABLE ROW LEVEL SECURITY;

-- Helper functions
CREATE OR REPLACE FUNCTION is_admin()
RETURNS BOOLEAN AS $$
BEGIN
  RETURN (
    SELECT CASE 
      WHEN auth.jwt()->>'role' = 'admin' THEN true
      ELSE false
    END
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION owns_business(business_id UUID)
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM businesses
    WHERE id = business_id
    AND profile_id = auth.uid()
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Business Data Security Policies
CREATE POLICY business_select_policy ON businesses
    FOR SELECT USING (profile_id = auth.uid());

CREATE POLICY business_modify_policy ON businesses
    FOR ALL USING (profile_id = auth.uid());

CREATE POLICY bundle_access_policy ON content_bundles
    FOR ALL USING (
        business_id IN (
            SELECT id FROM businesses 
            WHERE profile_id = auth.uid()
        )
    );

CREATE POLICY social_posts_access_policy ON social_posts
    FOR ALL USING (
        bundle_id IN (
            SELECT id FROM content_bundles 
            WHERE business_id IN (
                SELECT id FROM businesses 
                WHERE profile_id = auth.uid()
            )
        )
    );

CREATE POLICY blog_posts_access_policy ON blog_posts
    FOR ALL USING (
        bundle_id IN (
            SELECT id FROM content_bundles 
            WHERE business_id IN (
                SELECT id FROM businesses 
                WHERE profile_id = auth.uid()
            )
        )
    );

CREATE POLICY upgrades_access_policy ON content_upgrades
    FOR ALL USING (
        blog_post_id IN (
            SELECT id FROM blog_posts 
            WHERE bundle_id IN (
                SELECT id FROM content_bundles 
                WHERE business_id IN (
                    SELECT id FROM businesses 
                    WHERE profile_id = auth.uid()
                )
            )
        )
    );

CREATE POLICY sequences_access_policy ON email_sequences
    FOR ALL USING (
        bundle_id IN (
            SELECT id FROM content_bundles 
            WHERE business_id IN (
                SELECT id FROM businesses 
                WHERE profile_id = auth.uid()
            )
        )
    );

CREATE POLICY emails_access_policy ON emails
    FOR ALL USING (
        sequence_id IN (
            SELECT id FROM email_sequences 
            WHERE bundle_id IN (
                SELECT id FROM content_bundles 
                WHERE business_id IN (
                    SELECT id FROM businesses 
                    WHERE profile_id = auth.uid()
                )
            )
        )
    );

-- Payment and Subscription Security Policies
CREATE POLICY products_view_policy ON bundle_products
    FOR SELECT USING (
        is_active = true OR 
        auth.jwt()->>'role' = 'admin'
    );

CREATE POLICY products_modify_policy ON bundle_products
    FOR ALL USING (
        auth.jwt()->>'role' = 'admin'
    );

CREATE POLICY orders_access_policy ON orders
    FOR ALL USING (
        business_id IN (
            SELECT id FROM businesses 
            WHERE profile_id = auth.uid()
        )
    );

CREATE POLICY order_items_access_policy ON order_items
    FOR ALL USING (
        order_id IN (
            SELECT id FROM orders 
            WHERE business_id IN (
                SELECT id FROM businesses 
                WHERE profile_id = auth.uid()
            )
        )
    );

CREATE POLICY subscriptions_access_policy ON subscriptions
    FOR ALL USING (
        business_id IN (
            SELECT id FROM businesses 
            WHERE profile_id = auth.uid()
        )
    );

CREATE POLICY subscription_invoices_access_policy ON subscription_invoices
    FOR ALL USING (
        subscription_id IN (
            SELECT id FROM subscriptions 
            WHERE business_id IN (
                SELECT id FROM businesses 
                WHERE profile_id = auth.uid()
            )
        )
    );

-- Infrastructure Security Policies
CREATE POLICY feature_flags_view_policy ON feature_flags
    FOR SELECT USING (
        is_enabled = true OR 
        auth.jwt()->>'role' = 'admin' OR
        (rules->>'allowlist')::jsonb ? auth.uid()::text
    );

CREATE POLICY feature_flags_modify_policy ON feature_flags
    FOR ALL USING (
        auth.jwt()->>'role' = 'admin'
    );

CREATE POLICY api_keys_access_policy ON api_keys
    FOR ALL USING (
        business_id IN (
            SELECT id FROM businesses 
            WHERE profile_id = auth.uid()
        )
    );