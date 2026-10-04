-- ============================================================
-- 04_business_analysis.sql
--
-- Propósito:
-- Responder las preguntas de negocio del proyecto usando
-- el modelo dimensional.
--
-- Bloques:
--   A. Evolución de la demanda
--   B. Crecimiento de demanda vs. inventario
--   C. Inventory coverage
--   D. Clasificación de riesgo (High Risk, Watch, Overstock, Normal)
--   E. Data quality checks y business rules
--
-- Cada consulta responde a una pregunta de negocio específica.
-- ============================================================

-- ============================================================
-- A. EVOLUCIÓN DE LA DEMANDA
-- Pregunta: ¿Cómo está evolucionando la demanda?
-- ============================================================
SELECT
    d.year,
    d.month_number,
    d.month_name,
    SUM(fd.demand_qty) AS total_demand
FROM analytics.fact_demand fd
INNER JOIN analytics.dim_date d
    ON fd.date_key = d.date_key
WHERE
    fd.demand_type = 'Actual'
    AND d.month_number BETWEEN 1 AND 8
GROUP BY
    d.year,
    d.month_number,
    d.month_name
ORDER BY
    d.year,
    d.month_number;

-- ============================================================
-- B. PRODUCTOS QUE IMPULSAN EL CRECIMIENTO
-- Pregunta: ¿Qué productos están creciendo?
-- ============================================================
SELECT
    p.product_code,
    p.product_name,
    SUM(CASE WHEN d.year = 2025 THEN fd.demand_qty ELSE 0 END) AS demand_2025,
    SUM(CASE WHEN d.year = 2026 THEN fd.demand_qty ELSE 0 END) AS demand_2026,
    SUM(CASE WHEN d.year = 2026 THEN fd.demand_qty ELSE 0 END)
        - SUM(CASE WHEN d.year = 2025 THEN fd.demand_qty ELSE 0 END) AS demand_change
FROM analytics.fact_demand AS fd
JOIN analytics.dim_date AS d
    ON fd.date_key = d.date_key
JOIN analytics.dim_product AS p
    ON fd.product_key = p.product_key
WHERE
    fd.demand_type = 'Actual'
    AND d.month_number BETWEEN 1 AND 8
    AND d.year IN (2025, 2026)
GROUP BY
    p.product_code,
    p.product_name
ORDER BY
    demand_change DESC;

-- ============================================================
-- C. INVENTORY COVERAGE
-- Pregunta: ¿Cuántos meses de demanda cubre el inventario?
-- ============================================================
WITH demand_2026 AS (
    SELECT
        fd.product_key,
        SUM(fd.demand_qty) / 8.0 AS avg_monthly_demand
    FROM analytics.fact_demand AS fd
    JOIN analytics.dim_date AS d
        ON fd.date_key = d.date_key
    WHERE
        fd.demand_type = 'Actual'
        AND d.year = 2026
        AND d.month_number BETWEEN 1 AND 8
    GROUP BY
        fd.product_key
),
inventory_2026 AS (
    SELECT
        fi.product_key,
        AVG(fi.inventory_qty) AS avg_inventory
    FROM analytics.fact_inventory AS fi
    JOIN analytics.dim_date AS d
        ON fi.date_key = d.date_key
    WHERE
        d.year = 2026
    GROUP BY
        fi.product_key
)
SELECT
    p.product_code,
    p.product_name,
    ROUND(d.avg_monthly_demand, 2) AS avg_monthly_demand,
    ROUND(i.avg_inventory, 2) AS avg_inventory,
    ROUND(
        i.avg_inventory / NULLIF(d.avg_monthly_demand, 0),
        2
    ) AS inventory_coverage_months
FROM demand_2026 AS d
JOIN inventory_2026 AS i
    ON d.product_key = i.product_key
JOIN analytics.dim_product AS p
    ON d.product_key = p.product_key
ORDER BY
    inventory_coverage_months ASC;

-- ============================================================
-- D. CLASIFICACIÓN DE RIESGO
-- Pregunta: ¿Qué productos son High Risk, Watch, Overstock o Normal?
-- ============================================================
WITH demand_comparison AS (
    SELECT
        fd.product_key,
        SUM(CASE WHEN d.year = 2025 THEN fd.demand_qty ELSE 0 END) AS demand_2025,
        SUM(CASE WHEN d.year = 2026 THEN fd.demand_qty ELSE 0 END) AS demand_2026
    FROM analytics.fact_demand AS fd
    JOIN analytics.dim_date AS d
        ON fd.date_key = d.date_key
    WHERE
        fd.demand_type = 'Actual'
        AND d.month_number BETWEEN 1 AND 8
        AND d.year IN (2025, 2026)
    GROUP BY
        fd.product_key
),
inventory_2026 AS (
    SELECT
        fi.product_key,
        AVG(fi.inventory_qty) AS avg_inventory
    FROM analytics.fact_inventory AS fi
    JOIN analytics.dim_date AS d
        ON fi.date_key = d.date_key
    WHERE
        d.year = 2026
    GROUP BY
        fi.product_key
)
SELECT
    p.product_code,
    p.product_name,
    ROUND(dc.demand_2025, 0) AS demand_2025,
    ROUND(dc.demand_2026, 0) AS demand_2026,
    ROUND(
        (
            (dc.demand_2026::numeric - dc.demand_2025::numeric)
            / NULLIF(dc.demand_2025::numeric, 0)
        ) * 100,
        1
    ) AS demand_growth_pct,
    ROUND(dc.demand_2026 / 8.0, 2) AS avg_monthly_demand,
    ROUND(i.avg_inventory, 2) AS avg_inventory,
    ROUND(
        i.avg_inventory / NULLIF(dc.demand_2026 / 8.0, 0),
        2
    ) AS inventory_coverage_months,
    CASE
        WHEN
            i.avg_inventory / NULLIF(dc.demand_2026 / 8.0, 0) < 0.50
            AND dc.demand_2026 > dc.demand_2025
        THEN 'High Risk'
        WHEN
            i.avg_inventory / NULLIF(dc.demand_2026 / 8.0, 0) < 1.00
        THEN 'Watch'
        WHEN
            i.avg_inventory / NULLIF(dc.demand_2026 / 8.0, 0) > 4.00
        THEN 'Overstock'
        ELSE 'Normal'
    END AS inventory_risk
FROM demand_comparison AS dc
JOIN inventory_2026 AS i
    ON dc.product_key = i.product_key
JOIN analytics.dim_product AS p
    ON dc.product_key = p.product_key
ORDER BY
    inventory_coverage_months ASC;

-- ============================================================
-- E. DATA QUALITY CHECKS
-- Validaciones de volumen, nulos, duplicados y reglas de negocio
-- ============================================================

-- E1. Volumen de productos
SELECT COUNT(*) AS total_products
FROM raw.raw_products;

-- E2. Nulos por columna
SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE product_code IS NULL) AS null_product_code,
    COUNT(*) FILTER (WHERE product_name IS NULL) AS null_product_name,
    COUNT(*) FILTER (WHERE plant_code IS NULL) AS null_plant_code,
    COUNT(*) FILTER (WHERE standard_cost IS NULL) AS null_standard_cost
FROM raw.raw_products;

-- E3. Duplicados
SELECT
    product_code,
    COUNT(*) AS occurrences
FROM raw.raw_products
GROUP BY product_code
HAVING COUNT(*) > 1;

-- E4. Integridad referencial
SELECT DISTINCT d.product_code
FROM raw.raw_demand d
LEFT JOIN raw.raw_products p
    ON d.product_code = p.product_code
WHERE p.product_code IS NULL;

-- E5. Reglas de negocio
-- Demanda no puede ser negativa
SELECT *
FROM raw.raw_demand
WHERE demand_qty <= 0;

-- Inventario no puede ser negativo
SELECT *
FROM raw.raw_inventory
WHERE inventory_qty < 0;

-- Costos no pueden ser negativos
SELECT *
FROM raw.raw_products
WHERE standard_cost < 0;

-- Producción no puede ser negativa
SELECT *
FROM raw.raw_production_orders
WHERE planned_qty < 0
   OR actual_qty < 0;

-- Una PO no puede recibirse antes de ser creada
SELECT *
FROM raw.raw_purchase_orders
WHERE receipt_date IS NOT NULL
  AND receipt_date < order_date;

-- Producción: fecha real no puede ser antes de la planeada
SELECT *
FROM raw.raw_production_orders
WHERE actual_start_date IS NOT NULL
  AND actual_start_date < planned_start_date;

-- Producción real no puede exceder la planeada
SELECT *
FROM raw.raw_production_orders
WHERE actual_qty > planned_qty;