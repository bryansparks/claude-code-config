-- Metrics Dashboard Database Schema
-- PostgreSQL 14+

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Enable TimescaleDB (optional, for time-series optimization)
-- CREATE EXTENSION IF NOT EXISTS timescaledb;

-- ============================================================================
-- USERS AND TEAMS
-- ============================================================================

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    team_id UUID,
    persona VARCHAR(50) NOT NULL, -- 'engineer', 'qa', 'pm', 'em', 'ux'
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE teams (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) UNIQUE NOT NULL,
    description TEXT,
    manager_id UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE users ADD CONSTRAINT fk_team FOREIGN KEY (team_id) REFERENCES teams(id);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_team ON users(team_id);
CREATE INDEX idx_users_persona ON users(persona);

-- ============================================================================
-- REPOSITORIES AND PROJECTS
-- ============================================================================

CREATE TABLE repositories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) UNIQUE NOT NULL,
    url VARCHAR(500),
    default_branch VARCHAR(100) DEFAULT 'main',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_repositories_name ON repositories(name);

-- ============================================================================
-- SKILLS
-- ============================================================================

CREATE TABLE skills (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) UNIQUE NOT NULL,
    display_name VARCHAR(255) NOT NULL,
    description TEXT,
    persona VARCHAR(50) NOT NULL,
    category VARCHAR(100),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Seed skills data
INSERT INTO skills (name, display_name, description, persona, category) VALUES
('code-review', 'Code Review', 'Comprehensive code quality, security, and performance analysis', 'engineer', 'core_quality'),
('debug-analysis', 'Debug Analysis', 'Systematic root cause analysis with fix recommendations', 'engineer', 'core_quality'),
('performance-optimization', 'Performance Optimization', 'Bottleneck identification and optimization roadmap', 'engineer', 'core_quality'),
('security-analysis', 'Security Analysis', 'OWASP Top 10, dependency vulnerabilities, security scanning', 'engineer', 'security_architecture'),
('api-design-review', 'API Design Review', 'RESTful design, OpenAPI validation, versioning strategies', 'engineer', 'security_architecture'),
('accessibility-development', 'Accessibility Development', 'WCAG 2.1/2.2 compliant code with accessible components', 'engineer', 'development_standards'),
('iso-standards-compliance', 'ISO Standards Compliance', 'ISO/IEC 25010 quality model assessment and scoring', 'engineer', 'development_standards'),
('unit-test-generator', 'Unit Test Generator', 'Automatic test generation with TDD workflow support', 'engineer', 'development_standards'),
('test-automation', 'Test Automation', 'Auto-generate comprehensive test cases from requirements', 'qa', 'testing'),
('accessibility-audit', 'Accessibility Audit', 'WCAG 2.1/2.2 compliance analysis with remediation', 'qa', 'testing'),
('bug-analysis', 'Bug Analysis', 'Root cause analysis using 5 Whys with fix recommendations', 'qa', 'testing'),
('visual-regression', 'Visual Regression', 'UI change detection through screenshot comparison', 'qa', 'testing');

CREATE INDEX idx_skills_persona ON skills(persona);
CREATE INDEX idx_skills_category ON skills(category);

-- ============================================================================
-- SKILL INVOCATIONS
-- ============================================================================

CREATE TABLE skill_invocations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    skill_id UUID NOT NULL REFERENCES skills(id),
    user_id UUID NOT NULL REFERENCES users(id),
    repository_id UUID REFERENCES repositories(id),
    branch VARCHAR(255),
    commit_sha VARCHAR(40),
    trigger_method VARCHAR(50) NOT NULL, -- 'manual', 'automatic'
    input_files TEXT[], -- Array of file paths
    output_files TEXT[], -- Array of file paths
    duration_seconds INTEGER,
    tokens_used INTEGER,
    status VARCHAR(50) DEFAULT 'success', -- 'success', 'error', 'partial'
    error_message TEXT,
    metadata JSONB, -- Flexible storage for skill-specific data
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_invocations_skill ON skill_invocations(skill_id);
CREATE INDEX idx_invocations_user ON skill_invocations(user_id);
CREATE INDEX idx_invocations_repo ON skill_invocations(repository_id);
CREATE INDEX idx_invocations_created ON skill_invocations(created_at DESC);
CREATE INDEX idx_invocations_status ON skill_invocations(status);

-- Convert to hypertable for time-series optimization (if TimescaleDB enabled)
-- SELECT create_hypertable('skill_invocations', 'created_at', if_not_exists => TRUE);

-- ============================================================================
-- QUALITY METRICS
-- ============================================================================

CREATE TABLE quality_metrics (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    repository_id UUID NOT NULL REFERENCES repositories(id),
    branch VARCHAR(255) NOT NULL,
    commit_sha VARCHAR(40),
    metric_type VARCHAR(100) NOT NULL, -- 'test_coverage', 'security', 'accessibility', etc.
    overall_score DECIMAL(5,2), -- 0-100
    values JSONB NOT NULL, -- Flexible storage for metric-specific values
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_quality_repo ON quality_metrics(repository_id);
CREATE INDEX idx_quality_type ON quality_metrics(metric_type);
CREATE INDEX idx_quality_created ON quality_metrics(created_at DESC);
CREATE INDEX idx_quality_branch ON quality_metrics(branch);

-- ============================================================================
-- TEST COVERAGE HISTORY
-- ============================================================================

CREATE TABLE test_coverage_history (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    repository_id UUID NOT NULL REFERENCES repositories(id),
    branch VARCHAR(255) NOT NULL,
    commit_sha VARCHAR(40),
    coverage_statements DECIMAL(5,2),
    coverage_branches DECIMAL(5,2),
    coverage_functions DECIMAL(5,2),
    coverage_lines DECIMAL(5,2),
    total_tests INTEGER,
    passing_tests INTEGER,
    failing_tests INTEGER,
    execution_time_seconds INTEGER,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_coverage_repo ON test_coverage_history(repository_id);
CREATE INDEX idx_coverage_created ON test_coverage_history(created_at DESC);
CREATE INDEX idx_coverage_branch ON test_coverage_history(branch);

-- ============================================================================
-- SECURITY SCAN RESULTS
-- ============================================================================

CREATE TABLE security_scan_results (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    repository_id UUID NOT NULL REFERENCES repositories(id),
    branch VARCHAR(255) NOT NULL,
    commit_sha VARCHAR(40),
    scan_tool VARCHAR(100) NOT NULL, -- 'snyk', 'owasp-zap', 'custom'
    overall_score DECIMAL(5,2), -- 0-100
    critical_count INTEGER DEFAULT 0,
    high_count INTEGER DEFAULT 0,
    medium_count INTEGER DEFAULT 0,
    low_count INTEGER DEFAULT 0,
    vulnerabilities JSONB, -- Array of vulnerability details
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_security_repo ON security_scan_results(repository_id);
CREATE INDEX idx_security_created ON security_scan_results(created_at DESC);
CREATE INDEX idx_security_branch ON security_scan_results(branch);

-- ============================================================================
-- ACCESSIBILITY AUDIT RESULTS
-- ============================================================================

CREATE TABLE accessibility_audit_results (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    repository_id UUID NOT NULL REFERENCES repositories(id),
    branch VARCHAR(255) NOT NULL,
    commit_sha VARCHAR(40),
    audit_tool VARCHAR(100) NOT NULL, -- 'axe-core', 'lighthouse', 'pa11y'
    wcag_compliance_score DECIMAL(5,2), -- 0-100
    level_a_violations INTEGER DEFAULT 0,
    level_aa_violations INTEGER DEFAULT 0,
    level_aaa_violations INTEGER DEFAULT 0,
    violations JSONB, -- Array of violation details
    pages_tested INTEGER,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_a11y_repo ON accessibility_audit_results(repository_id);
CREATE INDEX idx_a11y_created ON accessibility_audit_results(created_at DESC);
CREATE INDEX idx_a11y_branch ON accessibility_audit_results(branch);

-- ============================================================================
-- PERFORMANCE MEASUREMENTS
-- ============================================================================

CREATE TABLE performance_measurements (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    repository_id UUID NOT NULL REFERENCES repositories(id),
    environment VARCHAR(50) NOT NULL, -- 'production', 'staging', 'development'
    measurement_type VARCHAR(100) NOT NULL, -- 'api_latency', 'frontend_vitals', 'db_query'
    endpoint VARCHAR(500), -- For API measurements
    metric_name VARCHAR(100) NOT NULL, -- 'p95', 'p99', 'lcp', 'fid', 'cls'
    value DECIMAL(10,2) NOT NULL,
    unit VARCHAR(20) NOT NULL, -- 'ms', 's', 'score'
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_perf_repo ON performance_measurements(repository_id);
CREATE INDEX idx_perf_env ON performance_measurements(environment);
CREATE INDEX idx_perf_type ON performance_measurements(measurement_type);
CREATE INDEX idx_perf_created ON performance_measurements(created_at DESC);

-- ============================================================================
-- API DESIGN REVIEWS
-- ============================================================================

CREATE TABLE api_design_reviews (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    repository_id UUID NOT NULL REFERENCES repositories(id),
    branch VARCHAR(255) NOT NULL,
    commit_sha VARCHAR(40),
    endpoint_path VARCHAR(500) NOT NULL,
    http_method VARCHAR(10) NOT NULL,
    design_score DECIMAL(5,2), -- 0-100
    restful_compliance BOOLEAN,
    openapi_documented BOOLEAN,
    versioned BOOLEAN,
    issues JSONB, -- Array of issues found
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_api_review_repo ON api_design_reviews(repository_id);
CREATE INDEX idx_api_review_created ON api_design_reviews(created_at DESC);
CREATE INDEX idx_api_review_endpoint ON api_design_reviews(endpoint_path);

-- ============================================================================
-- ISO QUALITY ASSESSMENTS
-- ============================================================================

CREATE TABLE iso_assessments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    repository_id UUID NOT NULL REFERENCES repositories(id),
    branch VARCHAR(255) NOT NULL,
    commit_sha VARCHAR(40),
    overall_quality_score DECIMAL(5,2), -- 0-100
    functional_suitability DECIMAL(5,2),
    performance_efficiency DECIMAL(5,2),
    compatibility DECIMAL(5,2),
    usability DECIMAL(5,2),
    reliability DECIMAL(5,2),
    security DECIMAL(5,2),
    maintainability DECIMAL(5,2),
    portability DECIMAL(5,2),
    assessment_notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_iso_repo ON iso_assessments(repository_id);
CREATE INDEX idx_iso_created ON iso_assessments(created_at DESC);
CREATE INDEX idx_iso_branch ON iso_assessments(branch);

-- ============================================================================
-- ALERTS AND NOTIFICATIONS
-- ============================================================================

CREATE TABLE alerts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    alert_type VARCHAR(100) NOT NULL, -- 'security', 'coverage', 'quality', 'performance'
    severity VARCHAR(20) NOT NULL, -- 'critical', 'high', 'medium', 'low'
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    repository_id UUID REFERENCES repositories(id),
    user_id UUID REFERENCES users(id),
    metadata JSONB,
    status VARCHAR(50) DEFAULT 'active', -- 'active', 'acknowledged', 'resolved'
    acknowledged_by UUID REFERENCES users(id),
    acknowledged_at TIMESTAMP WITH TIME ZONE,
    resolved_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_alerts_type ON alerts(alert_type);
CREATE INDEX idx_alerts_severity ON alerts(severity);
CREATE INDEX idx_alerts_status ON alerts(status);
CREATE INDEX idx_alerts_created ON alerts(created_at DESC);

-- ============================================================================
-- AGGREGATE STATISTICS (Materialized Views for Performance)
-- ============================================================================

-- Team-wide skill adoption rates
CREATE MATERIALIZED VIEW mv_team_skill_adoption AS
SELECT
    t.id AS team_id,
    t.name AS team_name,
    s.id AS skill_id,
    s.name AS skill_name,
    COUNT(DISTINCT u.id) AS users_who_used_skill,
    COUNT(si.id) AS total_invocations,
    AVG(si.duration_seconds) AS avg_duration_seconds
FROM teams t
CROSS JOIN skills s
LEFT JOIN users u ON u.team_id = t.id
LEFT JOIN skill_invocations si ON si.user_id = u.id AND si.skill_id = s.id
    AND si.created_at >= NOW() - INTERVAL '30 days'
WHERE s.persona = 'engineer' -- Adjust based on team persona
GROUP BY t.id, t.name, s.id, s.name;

CREATE UNIQUE INDEX idx_mv_team_skill ON mv_team_skill_adoption(team_id, skill_id);

-- User skill usage summary
CREATE MATERIALIZED VIEW mv_user_skill_summary AS
SELECT
    u.id AS user_id,
    u.email,
    u.name,
    u.team_id,
    COUNT(DISTINCT si.skill_id) AS unique_skills_used,
    COUNT(si.id) AS total_invocations,
    SUM(CASE WHEN si.created_at >= NOW() - INTERVAL '7 days' THEN 1 ELSE 0 END) AS invocations_last_7_days,
    MAX(si.created_at) AS last_skill_usage
FROM users u
LEFT JOIN skill_invocations si ON si.user_id = u.id
GROUP BY u.id, u.email, u.name, u.team_id;

CREATE UNIQUE INDEX idx_mv_user_skill ON mv_user_skill_summary(user_id);

-- Repository quality summary
CREATE MATERIALIZED VIEW mv_repository_quality AS
SELECT
    r.id AS repository_id,
    r.name AS repository_name,
    (SELECT coverage_statements FROM test_coverage_history
     WHERE repository_id = r.id ORDER BY created_at DESC LIMIT 1) AS latest_coverage,
    (SELECT overall_score FROM security_scan_results
     WHERE repository_id = r.id ORDER BY created_at DESC LIMIT 1) AS latest_security_score,
    (SELECT wcag_compliance_score FROM accessibility_audit_results
     WHERE repository_id = r.id ORDER BY created_at DESC LIMIT 1) AS latest_a11y_score,
    (SELECT overall_quality_score FROM iso_assessments
     WHERE repository_id = r.id ORDER BY created_at DESC LIMIT 1) AS latest_iso_score
FROM repositories r;

CREATE UNIQUE INDEX idx_mv_repo_quality ON mv_repository_quality(repository_id);

-- ============================================================================
-- FUNCTIONS AND TRIGGERS
-- ============================================================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger for users table
CREATE TRIGGER update_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Function to refresh materialized views (call periodically)
CREATE OR REPLACE FUNCTION refresh_all_materialized_views()
RETURNS void AS $$
BEGIN
    REFRESH MATERIALIZED VIEW CONCURRENTLY mv_team_skill_adoption;
    REFRESH MATERIALIZED VIEW CONCURRENTLY mv_user_skill_summary;
    REFRESH MATERIALIZED VIEW CONCURRENTLY mv_repository_quality;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- SAMPLE DATA (for testing)
-- ============================================================================

-- Insert sample team
INSERT INTO teams (id, name, description) VALUES
('00000000-0000-0000-0000-000000000001', 'Platform Engineering', 'Core platform team');

-- Insert sample repository
INSERT INTO repositories (id, name, url, default_branch) VALUES
('00000000-0000-0000-0000-000000000001', 'backend-api', 'https://github.com/company/backend-api', 'main');

-- Insert sample users
INSERT INTO users (id, email, name, team_id, persona) VALUES
('00000000-0000-0000-0000-000000000001', 'jane.doe@company.com', 'Jane Doe', '00000000-0000-0000-0000-000000000001', 'engineer'),
('00000000-0000-0000-0000-000000000002', 'john.smith@company.com', 'John Smith', '00000000-0000-0000-0000-000000000001', 'engineer');

-- ============================================================================
-- GRANTS (adjust based on your security model)
-- ============================================================================

-- Create read-only role for dashboard queries
CREATE ROLE metrics_readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO metrics_readonly;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO metrics_readonly;

-- Create read-write role for metrics ingestion
CREATE ROLE metrics_readwrite;
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA public TO metrics_readwrite;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO metrics_readwrite;

-- ============================================================================
-- MAINTENANCE
-- ============================================================================

-- Data retention policy (delete old detailed records, keep aggregates)
CREATE OR REPLACE FUNCTION cleanup_old_metrics()
RETURNS void AS $$
BEGIN
    -- Delete skill invocations older than 90 days
    DELETE FROM skill_invocations WHERE created_at < NOW() - INTERVAL '90 days';

    -- Delete performance measurements older than 90 days
    DELETE FROM performance_measurements WHERE created_at < NOW() - INTERVAL '90 days';

    -- Keep quality metrics, security scans, and accessibility audits for 2 years
    DELETE FROM quality_metrics WHERE created_at < NOW() - INTERVAL '2 years';
    DELETE FROM security_scan_results WHERE created_at < NOW() - INTERVAL '2 years';
    DELETE FROM accessibility_audit_results WHERE created_at < NOW() - INTERVAL '2 years';

    -- Refresh materialized views after cleanup
    PERFORM refresh_all_materialized_views();
END;
$$ LANGUAGE plpgsql;

-- Schedule cleanup (requires pg_cron extension)
-- SELECT cron.schedule('cleanup-old-metrics', '0 2 * * 0', 'SELECT cleanup_old_metrics();');

-- ============================================================================
-- INDEXES FOR PERFORMANCE
-- ============================================================================

-- Composite indexes for common queries
CREATE INDEX idx_invocations_user_skill_date ON skill_invocations(user_id, skill_id, created_at DESC);
CREATE INDEX idx_invocations_repo_skill_date ON skill_invocations(repository_id, skill_id, created_at DESC);
CREATE INDEX idx_quality_repo_type_date ON quality_metrics(repository_id, metric_type, created_at DESC);

-- Partial indexes for active alerts
CREATE INDEX idx_alerts_active ON alerts(created_at DESC) WHERE status = 'active';

-- JSONB indexes for faster queries on metadata
CREATE INDEX idx_invocations_metadata ON skill_invocations USING gin(metadata);
CREATE INDEX idx_quality_values ON quality_metrics USING gin(values);

COMMENT ON DATABASE postgres IS 'Metrics Dashboard - Tracks Claude Code skill usage and quality metrics';
