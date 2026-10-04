-- ============================================================
-- 01_create_raw_tables.sql
--
-- Propósito:
-- Crear las 8 tablas RAW que simulan las fuentes de datos
-- de un ERP, un MES y un sistema de planeación de demanda.
--
-- Estas tablas almacenan los datos tal como llegan del sistema
-- fuente, sin transformaciones.
--
-- Tablas:
--   raw.raw_products
--   raw.raw_suppliers
--   raw.raw_plants
--   raw.raw_work_centers
--   raw.raw_demand
--   raw.raw_inventory
--   raw.raw_purchase_orders
--   raw.raw_production_orders
-- ============================================================

-- ============================================================
-- RAW PRODUCTS
-- ============================================================
CREATE TABLE raw.raw_products (
    product_code VARCHAR(20),
    product_name VARCHAR(100),
    product_category VARCHAR(50),
    product_family VARCHAR(50),
    unit_of_measure VARCHAR(10),
    plant_code VARCHAR(10),
    standard_cost DECIMAL(12,2),
    product_status VARCHAR(20)
);

-- ============================================================
-- RAW SUPPLIERS
-- ============================================================
CREATE TABLE raw.raw_suppliers (
    supplier_code VARCHAR(20),
    supplier_name VARCHAR(100),
    country VARCHAR(50),
    supplier_category VARCHAR(50),
    default_lead_time_days INTEGER,
    supplier_status VARCHAR(20)
);

-- ============================================================
-- RAW PLANTS
-- ============================================================
CREATE TABLE raw.raw_plants (
    plant_code VARCHAR(10),
    plant_name VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50),
    plant_type VARCHAR(50)
);

-- ============================================================
-- RAW WORK CENTERS
-- ============================================================
CREATE TABLE raw.raw_work_centers (
    work_center_code VARCHAR(20),
    work_center_name VARCHAR(100),
    plant_code VARCHAR(10),
    production_area VARCHAR(50),
    capacity_units_day INTEGER,
    status VARCHAR(20)
);

-- ============================================================
-- RAW DEMAND
-- ============================================================
CREATE TABLE raw.raw_demand (
    demand_date DATE,
    product_code VARCHAR(20),
    plant_code VARCHAR(10),
    demand_qty INTEGER,
    demand_type VARCHAR(20),
    customer_segment VARCHAR(50)
);

-- ============================================================
-- RAW INVENTORY
-- ============================================================
CREATE TABLE raw.raw_inventory (
    snapshot_date DATE,
    product_code VARCHAR(20),
    plant_code VARCHAR(10),
    inventory_qty INTEGER,
    inventory_status VARCHAR(20),
    inventory_value DECIMAL(14,2)
);

-- ============================================================
-- RAW PURCHASE ORDERS
-- ============================================================
CREATE TABLE raw.raw_purchase_orders (
    po_number VARCHAR(20),
    po_line INTEGER,
    order_date DATE,
    supplier_code VARCHAR(20),
    product_code VARCHAR(20),
    plant_code VARCHAR(10),
    ordered_qty INTEGER,
    promised_date DATE,
    receipt_date DATE,
    po_status VARCHAR(30)
);

-- ============================================================
-- RAW PRODUCTION ORDERS
-- ============================================================
CREATE TABLE raw.raw_production_orders (
    production_order VARCHAR(20),
    production_date DATE,
    product_code VARCHAR(20),
    plant_code VARCHAR(10),
    work_center_code VARCHAR(20),
    planned_qty INTEGER,
    actual_qty INTEGER,
    production_status VARCHAR(20),
    planned_start_date DATE,
    actual_start_date DATE
);