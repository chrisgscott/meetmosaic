
-- Bundle products table
CREATE TABLE bundle_products (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    
    name TEXT NOT NULL,
    description TEXT NOT NULL,
    type TEXT NOT NULL,  -- 'social', 'blog', 'email', 'upgrade'
    
    -- Product details
    content_count INTEGER NOT NULL,  -- e.g., 365 social posts, 12 blog posts
    time_period TEXT NOT NULL,       -- e.g., '1 year', '1 quarter'
    features JSONB NOT NULL,         -- array of included features
    
    -- Pricing
    base_price INTEGER NOT NULL,     -- in cents
    is_active BOOLEAN DEFAULT true,
    
    -- Optional volume discount tiers
    volume_discounts JSONB DEFAULT '[]'::jsonb
    /*
      [
        {"min_quantity": 2, "discount_percent": 10},
        {"min_quantity": 5, "discount_percent": 20}
      ]
    */
);

-- Orders table
CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    business_id UUID REFERENCES businesses(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    
    status TEXT NOT NULL DEFAULT 'pending',  -- pending, paid, failed, refunded
    total_amount INTEGER NOT NULL,           -- in cents
    currency TEXT NOT NULL DEFAULT 'usd',
    
    -- Payment details
    payment_intent_id TEXT,          -- Stripe payment intent ID
    payment_status TEXT,
    payment_method TEXT,
    
    -- Metadata
    metadata JSONB DEFAULT '{}'::jsonb
);

-- Order items table
CREATE TABLE order_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id UUID REFERENCES orders(id) ON DELETE CASCADE,
    product_id UUID REFERENCES bundle_products(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    
    quantity INTEGER NOT NULL DEFAULT 1,
    unit_price INTEGER NOT NULL,      -- in cents
    subtotal INTEGER NOT NULL,        -- in cents
    discount_amount INTEGER DEFAULT 0, -- in cents
    
    -- Links to generated content
    content_bundle_id UUID REFERENCES content_bundles(id),
    
    -- Configuration options
    options JSONB DEFAULT '{}'::jsonb  -- product-specific options
);

-- Subscriptions table
CREATE TABLE subscriptions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    business_id UUID REFERENCES businesses(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    
    status TEXT NOT NULL,              -- active, canceled, past_due
    plan_type TEXT NOT NULL,           -- optimization, scheduling, analytics
    current_period_start TIMESTAMP WITH TIME ZONE NOT NULL,
    current_period_end TIMESTAMP WITH TIME ZONE NOT NULL,
    
    -- Stripe subscription details
    stripe_subscription_id TEXT,
    stripe_customer_id TEXT,
    
    -- Plan details
    monthly_price INTEGER NOT NULL,    -- in cents
    features JSONB NOT NULL,           -- array of included features
    
    -- Usage tracking
    usage_limits JSONB NOT NULL,
    current_usage JSONB DEFAULT '{}'::jsonb
);

-- Subscription invoices table
CREATE TABLE subscription_invoices (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    subscription_id UUID REFERENCES subscriptions(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    
    amount INTEGER NOT NULL,          -- in cents
    status TEXT NOT NULL,            -- paid, pending, failed
    billing_period_start TIMESTAMP WITH TIME ZONE NOT NULL,
    billing_period_end TIMESTAMP WITH TIME ZONE NOT NULL,
    
    stripe_invoice_id TEXT,
    payment_intent_id TEXT
);

-- Feature flags table
CREATE TABLE feature_flags (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    
    name TEXT NOT NULL UNIQUE,
    description TEXT,
    is_enabled BOOLEAN DEFAULT false,
    
    -- Optional targeting rules
    rules JSONB DEFAULT '{}'::jsonb,
    /*
      {
        "allowlist": ["business_id1", "business_id2"],
        "percentage": 50,
        "criteria": {
          "subscription_required": true,
          "min_order_count": 1
        }
      }
    */
    
    -- Metadata
    metadata JSONB DEFAULT '{}'::jsonb
);

-- API keys table
CREATE TABLE api_keys (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    business_id UUID REFERENCES businesses(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    
    key_hash TEXT NOT NULL,           -- hashed API key
    name TEXT NOT NULL,               -- user-provided name for the key
    last_used_at TIMESTAMP WITH TIME ZONE,
    expires_at TIMESTAMP WITH TIME ZONE,
    is_active BOOLEAN DEFAULT true,
    
    -- Permissions
    scopes TEXT[] NOT NULL,           -- array of permitted actions
    rate_limit INTEGER DEFAULT 1000,  -- requests per hour
    
    -- Usage tracking
    usage_count INTEGER DEFAULT 0
);

-- Create indexes for payment infrastructure
CREATE INDEX idx_orders_business_id ON orders(business_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_created_at ON orders(created_at);

CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);
CREATE INDEX idx_order_items_content_bundle_id ON order_items(content_bundle_id);

CREATE INDEX idx_subscriptions_business_id ON subscriptions(business_id);
CREATE INDEX idx_subscriptions_status ON subscriptions(status);
CREATE INDEX idx_subscriptions_stripe_subscription_id ON subscriptions(stripe_subscription_id);

CREATE INDEX idx_api_keys_business_id ON api_keys(business_id);
CREATE INDEX idx_api_keys_key_hash ON api_keys(key_hash);
CREATE INDEX idx_api_keys_is_active ON api_keys(is_active);