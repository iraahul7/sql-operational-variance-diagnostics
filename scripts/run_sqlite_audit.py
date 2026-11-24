import sqlite3
import numpy as np
import pandas as pd

conn = sqlite3.connect(":memory:")
np.random.seed(77)
n_tx = 5000
tx_df = pd.DataFrame({
    "transaction_id": range(1, n_tx + 1),
    "region": np.random.choice(["North", "South", "East", "West"], n_tx),
    "vendor_name": np.random.choice(["Delhivery", "BlueDart", "EcomExpress", "XpressBees", "Shadowfax"], n_tx),
    "expected_cost": np.round(np.random.uniform(400, 2500, n_tx), 2)
})
anomaly_mask = np.random.rand(n_tx) < 0.18
multiplier = np.where(anomaly_mask, np.random.uniform(1.19, 1.38, n_tx), np.random.uniform(0.95, 1.05, n_tx))
tx_df["actual_billed_cost"] = np.round(tx_df["expected_cost"] * multiplier, 2)
tx_df.to_sql("fact_transactions", conn, index=False)

query = """
WITH variance_calc AS (
    SELECT vendor_name, expected_cost, actual_billed_cost,
           ROUND(((actual_billed_cost - expected_cost) / expected_cost) * 100, 2) AS variance_pct
    FROM fact_transactions
)
SELECT vendor_name, COUNT(*) AS total_shipments,
       SUM(CASE WHEN ABS(variance_pct) >= 18.0 THEN 1 ELSE 0 END) AS critical_anomalies,
       ROUND(AVG(variance_pct), 2) AS avg_variance_pct
FROM variance_calc
GROUP BY vendor_name
ORDER BY critical_anomalies DESC;
"""
print(pd.read_sql_query(query, conn).to_string(index=False))
conn.close()
