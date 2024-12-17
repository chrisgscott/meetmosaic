-- First, disable realtime
ALTER PUBLICATION supabase_realtime DROP TABLE IF EXISTS esp_integrations;
ALTER PUBLICATION supabase_realtime_selective DROP TABLE IF EXISTS esp_integrations;

-- Drop policies
DROP POLICY IF EXISTS audit_logs_view_policy ON audit_logs;
DROP POLICY IF EXISTS content_versions_access_policy ON content_versions;
DROP POLICY IF EXISTS esp_integrations_access_policy ON esp_integrations;
DROP POLICY IF EXISTS managed_urls_access_policy ON managed_urls;

-- Drop indexes
DROP INDEX IF EXISTS idx_audit_logs_entity;
DROP INDEX IF EXISTS idx_audit_logs_actor;
DROP INDEX IF EXISTS idx_content_versions_entity;
DROP INDEX IF EXISTS idx_esp_integrations_business;
DROP INDEX IF EXISTS idx_managed_urls_business;
DROP INDEX IF EXISTS idx_managed_urls_source;

-- Drop tables in reverse order of their dependencies
DROP TABLE IF EXISTS managed_urls;
DROP TABLE IF EXISTS esp_integrations;
DROP TABLE IF EXISTS content_versions;
DROP TABLE IF EXISTS audit_logs;
