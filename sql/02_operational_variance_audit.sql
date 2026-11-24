-- ============================================================================
-- 02_operational_variance_audit.sql
-- Isolating 18% Operational Variance Anomalies via CTEs & Window Functions
-- Author: Rahul
-- ============================================================================

WITH vendor_rolling_metrics AS (
    SELECT
        transaction_id,
        transaction_date,
        region,
        vendor_name,
        expected_cost,
        actual_billed_cost,
        variance_pct,
        AVG(variance_pct) OVER (
            PARTITION BY vendor_name 
            ORDER BY transaction_date 
            ROWS BETWEEN 14 PRECEDING AND CURRENT ROW
        ) AS rolling_15d_variance_pct,
        RANK() OVER (PARTITION BY region ORDER BY ABS(cost_variance) DESC) AS regional_anomaly_rank
    FROM vw_consolidated_operations_audit
)
SELECT
    transaction_id,
    transaction_date,
    region,
    vendor_name,
    expected_cost,
    actual_billed_cost,
    variance_pct,
    ROUND(rolling_15d_variance_pct, 2) AS rolling_15d_variance_pct,
    CASE 
        WHEN ABS(variance_pct) >= 18.0 THEN 'CRITICAL_VARIANCE_FLAG'
        WHEN ABS(variance_pct) >= 10.0 THEN 'MODERATE_REVIEW'
        ELSE 'WITHIN_TOLERANCE'
    END AS audit_status
FROM vendor_rolling_metrics
WHERE ABS(variance_pct) >= 18.0
ORDER BY ABS(variance_pct) DESC;
