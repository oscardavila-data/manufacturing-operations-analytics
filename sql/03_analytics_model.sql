-- ============================================================
-- 03_analytics_model.sql
--
-- Propósito:
-- Construir el modelo dimensional (esquema en estrella)
-- que se usará en Power BI.
--
-- Dimensiones:
--   dim_product, dim_supplier, dim_plant, dim_work_center, dim_date
--
-- Tablas de hechos:
--   fact_demand, fact_inventory, fact_purchase_orders, fact_production
--
-- Nota:
-- Las métricas derivadas (días de retraso, brecha de producción,
-- cumplimiento) NO se almacenan. Se calculan en DAX.
-- ============================================================

-- ============================================================
-- PRIMARY KEYS DE DIMENSIONES
-- ============================================================
ALTER TABLE analytics.dim_product
ADD PRIMARY KEY (product_key);

ALTER TABLE analytics.dim_supplier
ADD PRIMARY KEY (supplier_key);

ALTER TABLE analytics.dim_plant
ADD PRIMARY KEY (plant_key);

ALTER TABLE analytics.dim_work_center
ADD PRIMARY KEY (work_center_key);

ALTER TABLE analytics.dim_date
ADD PRIMARY KEY (date_key);

-- Verificación
SELECT
    COUNT(*) AS total_products,
    COUNT(DISTINCT product_key) AS unique_product_keys
FROM analytics.dim_product;

-- ============================================================
-- FACT DEMAND
-- Granularidad: producto + planta + fecha + tipo
-- ============================================================
DROP TABLE IF EXISTS analytics.fact_demand;

CREATE TABLE analytics.fact_demand AS
SELECT
    p.product_key,
    pl.plant_key,
    d.date_key,
    sd.demand_type,
    sd.demand_qty
FROM staging.stg_demand sd
INNER JOIN analytics.dim_product p
    ON sd.product_code = p.product_code
INNER JOIN analytics.dim_plant pl
    ON sd.plant_code = pl.plant_code
INNER JOIN analytics.dim_date d
    ON sd.demand_date = d.full_date;

-- ============================================================
-- FACT INVENTORY
-- Granularidad: producto + planta + snapshot date
-- ============================================================
DROP TABLE IF EXISTS analytics.fact_inventory;

CREATE TABLE analytics.fact_inventory AS
SELECT
    p.product_key,
    pl.plant_key,
    d.date_key,
    si.inventory_qty
FROM staging.stg_inventory si
INNER JOIN analytics.dim_product p
    ON si.product_code = p.product_code
INNER JOIN analytics.dim_plant pl
    ON si.plant_code = pl.plant_code
INNER JOIN analytics.dim_date d
    ON si.snapshot_date = d.full_date;

-- ============================================================
-- FACT PURCHASE ORDERS
-- Granularidad: línea de PO
-- ============================================================
DROP TABLE IF EXISTS analytics.fact_purchase_orders;

CREATE TABLE analytics.fact_purchase_orders AS
SELECT
    po.po_number,
    po.po_line,
    p.product_key,
    s.supplier_key,
    pl.plant_key,
    od.date_key AS order_date_key,
    pd.date_key AS promised_date_key,
    rd.date_key AS receipt_date_key,
    po.ordered_qty,
    po.po_status,
    po.order_date,
    po.promised_date,
    po.receipt_date
FROM staging.stg_purchase_orders po
INNER JOIN analytics.dim_product p
    ON po.product_code = p.product_code
INNER JOIN analytics.dim_supplier s
    ON po.supplier_code = s.supplier_code
INNER JOIN analytics.dim_plant pl
    ON po.plant_code = pl.plant_code
INNER JOIN analytics.dim_date od
    ON po.order_date = od.full_date
INNER JOIN analytics.dim_date pd
    ON po.promised_date = pd.full_date
LEFT JOIN analytics.dim_date rd
    ON po.receipt_date = rd.full_date;

-- ============================================================
-- FACT PRODUCTION
-- Granularidad: orden de producción
-- ============================================================
DROP TABLE IF EXISTS analytics.fact_production;

CREATE TABLE analytics.fact_production AS
SELECT
    pr.production_order,
    p.product_key,
    pl.plant_key,
    wc.work_center_key,
    pd.date_key AS production_date_key,
    psd.date_key AS planned_start_date_key,
    asd.date_key AS actual_start_date_key,
    pr.planned_qty,
    pr.actual_qty,
    pr.production_status,
    pr.production_date,
    pr.planned_start_date,
    pr.actual_start_date
FROM staging.stg_production_orders pr
INNER JOIN analytics.dim_product p
    ON pr.product_code = p.product_code
INNER JOIN analytics.dim_plant pl
    ON pr.plant_code = pl.plant_code
INNER JOIN analytics.dim_work_center wc
    ON pr.work_center_code = wc.work_center_code
INNER JOIN analytics.dim_date pd
    ON pr.production_date = pd.full_date
INNER JOIN analytics.dim_date psd
    ON pr.planned_start_date = psd.full_date
LEFT JOIN analytics.dim_date asd
    ON pr.actual_start_date = asd.full_date;

-- Verificación
SELECT COUNT(*) AS total_rows
FROM analytics.fact_production;