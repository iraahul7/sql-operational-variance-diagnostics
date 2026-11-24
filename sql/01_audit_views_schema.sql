-- ============================================================================
-- 01_audit_views_schema.sql
-- Consolidating 75,000+ Transactional Records into Audit-Ready Views
-- Author: Rahul
-- ============================================================================

CREATE OR REPLACE VIEW vw_consolidated_operations_audit AS
SELECT
    t.transaction_id,
    t.transaction_date,
    w.warehouse_code,
    w.region,
    v.vendor_name,
    t.expected_cost,
    t.actual_billed_cost,
    (t.actual_billed_cost - t.expected_cost) AS cost_variance,
    ROUND(((t.actual_billed_cost - t.expected_cost) / NULLIF(t.expected_cost, 0)) * 100, 2) AS variance_pct,
    t.sla_hours_expected,
    t.sla_hours_actual
FROM fact_transactions t
INNER JOIN dim_warehouses w ON t.warehouse_id = w.warehouse_id
INNER JOIN dim_vendors v ON t.vendor_id = v.vendor_id
WHERE t.transaction_status = 'SETTLED';
