
-- Audit trail for tracking all changes
CREATE TABLE audit_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    entity_type TEXT NOT NULL,
    entity_id UUID NOT NULL,
    action TEXT NOT NULL,
    actor_id UUID NOT NULL,
    changes JSONB NOT NULL,
    ai_generated BOOLEAN DEFAULT false,
    ai_model TEXT,
    ai_prompt TEXT
);

-- Version history for content
CREATE TABLE content_versions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    entity_type TEXT NOT NULL,
    entity_id UUID NOT NULL,
    version_number INTEGER NOT NULL,
    content TEXT NOT NULL,
    reason TEXT,
    performance_snapshot JSONB,
    created_by UUID NOT NULL
);

-- ESP integration configuration
CREATE TABLE esp_integrations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    business_id UUID REFERENCES businesses(id) ON DELETE CASCADE,
    provider TEXT NOT NULL,
    credentials JSONB NOT NULL,
    settings JSONB NOT NULL,
    last_sync_at TIMESTAMP WITH TIME ZONE,
    sync_status TEXT,
    error_log JSONB
);

-- URL management and tracking
CREATE TABLE managed_urls (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    business_id UUID REFERENCES businesses(id) ON DELETE CASCADE,
    source_type TEXT NOT NULL,
    source_id UUID NOT NULL,
    url TEXT NOT NULL,
    utm_params JSONB,
    click_count INTEGER DEFAULT 0,
    last_checked_at TIMESTAMP WITH TIME ZONE,
    is_valid BOOLEAN DEFAULT true
);

-- Enable RLS
ALTER TABLE audit_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE content_versions ENABLE ROW LEVEL SECURITY;
ALTER TABLE esp_integrations ENABLE ROW LEVEL SECURITY;
ALTER TABLE managed_urls ENABLE ROW LEVEL SECURITY;

-- Create indexes
CREATE INDEX idx_audit_logs_entity ON audit_logs(entity_type, entity_id);
CREATE INDEX idx_audit_logs_actor ON audit_logs(actor_id);
CREATE INDEX idx_content_versions_entity ON content_versions(entity_type, entity_id);
CREATE INDEX idx_esp_integrations_business ON esp_integrations(business_id);
CREATE INDEX idx_managed_urls_business ON managed_urls(business_id);
CREATE INDEX idx_managed_urls_source ON managed_urls(source_type, source_id);

-- RLS Policies
CREATE POLICY audit_logs_view_policy ON audit_logs
    FOR SELECT USING (
        actor_id = auth.uid() OR
        auth.jwt()->>'role' = 'admin'
    );

CREATE POLICY content_versions_access_policy ON content_versions
    FOR ALL USING (
        created_by = auth.uid() OR
        auth.jwt()->>'role' = 'admin'
    );

CREATE POLICY esp_integrations_access_policy ON esp_integrations
    FOR ALL USING (
        business_id IN (
            SELECT id FROM businesses 
            WHERE profile_id = auth.uid()
        )
    );

CREATE POLICY managed_urls_access_policy ON managed_urls
    FOR ALL USING (
        business_id IN (
            SELECT id FROM businesses 
            WHERE profile_id = auth.uid()
        )
    );

-- Enable realtime for relevant tables
ALTER PUBLICATION supabase_realtime ADD TABLE esp_integrations;
ALTER PUBLICATION supabase_realtime_selective ADD TABLE esp_integrations (id, sync_status, error_log);