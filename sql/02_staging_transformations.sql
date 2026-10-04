-- ============================================================
-- 02_staging_transformations.sql
--
-- Propósito:
-- Limpiar y normalizar los datos RAW antes de modelarlos.
--
-- Transformaciones aplicadas:
--   - TRIM() en campos de texto
--   - Eliminación de duplicados con ROW_NUMBER()
--   - Filtros de reglas de negocio (demand_qty > 0, etc.)
--   - Validación de integridad referencial
--
-- Tablas generadas:
--   staging.stg_products
--   staging.stg_suppliers
--   staging.stg_plants
--   staging.stg_work_centers
--   staging.stg_demand
--   staging.stg_inventory
--   staging.stg_purchase_orders
--   staging.stg_production_orders
-- ============================================================

-- ============================================================
-- STG PRODUCTS (limpieza + deduplicación)
-- ============================================================
DROP TABLE IF EXISTS staging.stg_products;

CREATE TABLE staging.stg_products AS
SELECT
    product_code,
    product_name,
    product_category,
    product_family,
    unit_of_measure,
    plant_code,
    standard_cost,
    product_status
FROM (
    SELECT
        TRIM(product_code) AS product_code,
        TRIM(product_name) AS product_name,
        TRIM(product_category) AS product_category,
        TRIM(product_family) AS product_family,
        TRIM(unit_of_measure) AS unit_of_measure,
        TRIM(plant_code) AS plant_code,
        standard_cost,
        TRIM(product_status) AS product_status,
        ROW_NUMBER() OVER (
            PARTITION BY TRIM(product_code)
            ORDER BY product_code
        ) AS rn
    FROM raw.raw_products
) p
WHERE rn = 1;

-- Verificación
SELECT COUNT(*) AS total_products
FROM staging.stg_products;

-- ============================================================
-- STG SUPPLIERS
-- ============================================================
DROP TABLE IF EXISTS staging.stg_suppliers;

CREATE TABLE staging.stg_suppliers AS
SELECT
    TRIM(supplier_code) AS supplier_code,
    TRIM(supplier_name) AS supplier_name,
    TRIM(country) AS country,
    TRIM(supplier_category) AS supplier_category,
    default_lead_time_days,
    TRIM(supplier_status) AS supplier_status
FROM raw.raw_suppliers;

-- ============================================================
-- STG PLANTS
-- ============================================================
DROP TABLE IF EXISTS staging.stg_plants;

CREATE TABLE staging.stg_plants AS
SELECT
    TRIM(plant_code) AS plant_code,
    TRIM(plant_name) AS plant_name,
    TRIM(city) AS city,
    TRIM(state) AS state,
    TRIM(country) AS country,
    TRIM(plant_type) AS plant_type
FROM raw.raw_plants;

-- ============================================================
-- STG WORK CENTERS
-- ============================================================
DROP TABLE IF EXISTS staging.stg_work_centers;

CREATE TABLE staging.stg_work_centers AS
SELECT
    TRIM(work_center_code) AS work_center_code,
    TRIM(work_center_name) AS work_center_name,
    TRIM(plant_code) AS plant_code,
    TRIM(production_area) AS production_area,
    capacity_units_day,
    TRIM(status) AS status
FROM raw.raw_work_centers;

-- ============================================================
-- STG DEMAND
-- ============================================================
DROP TABLE IF EXISTS staging.stg_demand;

CREATE TABLE staging.stg_demand AS
SELECT
    demand_date,
    TRIM(product_code) AS product_code,
    TRIM(plant_code) AS plant_code,
    demand_qty,
    TRIM(demand_type) AS demand_type,
    TRIM(customer_segment) AS customer_segment
FROM raw.raw_demand
WHERE demand_qty > 0;

-- ============================================================
-- STG INVENTORY
-- ============================================================
DROP TABLE IF EXISTS staging.stg_inventory;

CREATE TABLE staging.stg_inventory AS
SELECT
    snapshot_date,
    TRIM(product_code) AS product_code,
    TRIM(plant_code) AS plant_code,
    inventory_qty,
    TRIM(inventory_status) AS inventory_status,
    inventory_value
FROM raw.raw_inventory
WHERE inventory_qty >= 0;

-- ============================================================
-- STG PURCHASE ORDERS (deduplicación con DISTINCT)
-- ============================================================
DROP TABLE IF EXISTS staging.stg_purchase_orders;

CREATE TABLE staging.stg_purchase_orders AS
SELECT DISTINCT
    TRIM(po_number) AS po_number,
    po_line,
    order_date,
    TRIM(supplier_code) AS supplier_code,
    TRIM(product_code) AS product_code,
    TRIM(plant_code) AS plant_code,
    ordered_qty,
    promised_date,
    receipt_date,
    TRIM(po_status) AS po_status
FROM raw.raw_purchase_orders
WHERE ordered_qty > 0;

-- ============================================================
-- STG PRODUCTION ORDERS
-- ============================================================
DROP TABLE IF EXISTS staging.stg_production_orders;

CREATE TABLE staging.stg_production_orders AS
SELECT
    TRIM(production_order) AS production_order,
    production_date,
    TRIM(product_code) AS product_code,
    TRIM(plant_code) AS plant_code,
    TRIM(work_center_code) AS work_center_code,
    planned_qty,
    actual_qty,
    TRIM(production_status) AS production_status,
    planned_start_date,
    actual_start_date
FROM raw.raw_production_orders
WHERE planned_qty >= 0
  AND actual_qty >= 0;

-- ============================================================
-- VALIDACIÓN DE INTEGRIDAD REFERENCIAL
-- ============================================================

-- Demand → Products
SELECT DISTINCT d.product_code
FROM staging.stg_demand d
LEFT JOIN staging.stg_products p
    ON d.product_code = p.product_code
WHERE p.product_code IS NULL;

-- Inventory → Products
SELECT DISTINCT i.product_code
FROM staging.stg_inventory i
LEFT JOIN staging.stg_products p
    ON i.product_code = p.product_code
WHERE p.product_code IS NULL;

-- Purchase Orders → Suppliers
SELECT DISTINCT po.supplier_code
FROM staging.stg_purchase_orders po
LEFT JOIN staging.stg_suppliers s
    ON po.supplier_code = s.supplier_code
WHERE s.supplier_code IS NULL;

-- Purchase Orders → Plants
SELECT DISTINCT po.plant_code
FROM staging.stg_purchase_orders po
LEFT JOIN staging.stg_plants p
    ON po.plant_code = p.plant_code
WHERE p.plant_code IS NULL;

-- Production → Products
SELECT DISTINCT pr.product_code
FROM staging.stg_production_orders pr
LEFT JOIN staging.stg_products p
    ON pr.product_code = p.product_code
WHERE p.product_code IS NULL;

-- Production → Plants
SELECT DISTINCT pr.plant_code
FROM staging.stg_production_orders pr
LEFT JOIN staging.stg_plants p
    ON pr.plant_code = p.plant_code
WHERE p.plant_code IS NULL;

-- Production → Work Centers
SELECT DISTINCT pr.work_center_code
FROM staging.stg_production_orders pr
LEFT JOIN staging.stg_work_centers wc
    ON pr.work_center_code = wc.work_center_code
WHERE wc.work_center_code IS NULL;