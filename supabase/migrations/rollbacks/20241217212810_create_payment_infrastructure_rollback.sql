-- Drop indexes first
DROP INDEX IF EXISTS idx_bundle_products_bundle;
DROP INDEX IF EXISTS idx_orders_business;
DROP INDEX IF EXISTS idx_orders_customer;
DROP INDEX IF EXISTS idx_order_items_order;
DROP INDEX IF EXISTS idx_subscriptions_business;
DROP INDEX IF EXISTS idx_subscriptions_customer;
DROP INDEX IF EXISTS idx_subscription_invoices_subscription;
DROP INDEX IF EXISTS idx_feature_flags_business;
DROP INDEX IF EXISTS idx_api_keys_business;

-- Drop tables in reverse order of dependencies
DROP TABLE IF EXISTS api_keys;
DROP TABLE IF EXISTS feature_flags;
DROP TABLE IF EXISTS subscription_invoices;
DROP TABLE IF EXISTS subscriptions;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS bundle_products;
