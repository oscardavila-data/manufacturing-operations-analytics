# Data Dictionary — Manufacturing Operations & Demand Planning Analytics

**Proyecto:** NovaTech Electronics (empresa ficticia)  
**Período:** Enero 2025 – Diciembre 2026  
**Fuente:** Datos sintéticos generados con Python (semilla 42)

---

## 📌 Descripción general

Este documento describe las tablas, columnas y relaciones del modelo de datos usado en el proyecto.

El modelo sigue un enfoque **dimensional (esquema en estrella)** con:

- **5 dimensiones:** `dim_product`, `dim_supplier`, `dim_plant`, `dim_work_center`, `dim_date`
- **4 tablas de hechos:** `fact_demand`, `fact_inventory`, `fact_purchase_orders`, `fact_production`

Las métricas derivadas (días de retraso, brecha de producción, cumplimiento) **no se almacenan** en las tablas de hechos. Se calculan en SQL y DAX.

---

## 🗂️ Capas del modelo

El proyecto usa tres capas en PostgreSQL:

| Capa | Propósito |
| :--- | :--- |
| `raw` | Datos crudos, tal como llegan del sistema fuente |
| `staging` | Limpieza, normalización y validación |
| `analytics` | Modelo dimensional final (dimensiones + hechos) |

---

## 📊 Dimensiones

### `dim_product`

| Columna | Tipo | Descripción |
| :--- | :--- | :--- |
| `product_key` | INT (PK) | Surrogate key |
| `product_code` | VARCHAR | Código del producto (ej. P-1001) |
| `product_name` | VARCHAR | Nombre del producto |
| `product_category` | VARCHAR | Categoría (Sensors, Controllers, etc.) |
| `product_family` | VARCHAR | Familia del producto |
| `unit_of_measure` | VARCHAR | Unidad de medida (EA) |
| `standard_cost` | DECIMAL | Costo estándar unitario |
| `product_status` | VARCHAR | Estatus (Active, Inactive) |

### `dim_supplier`

| Columna | Tipo | Descripción |
| :--- | :--- | :--- |
| `supplier_key` | INT (PK) | Surrogate key |
| `supplier_code` | VARCHAR | Código del proveedor (ej. SUP-001) |
| `supplier_name` | VARCHAR | Nombre del proveedor |
| `country` | VARCHAR | País de origen |
| `supplier_category` | VARCHAR | Categoría del proveedor |
| `default_lead_time_days` | INT | Lead time promedio en días |
| `supplier_status` | VARCHAR | Estatus (Active) |

### `dim_plant`

| Columna | Tipo | Descripción |
| :--- | :--- | :--- |
| `plant_key` | INT (PK) | Surrogate key |
| `plant_code` | VARCHAR | Código de la planta (ej. PL01) |
| `plant_name` | VARCHAR | Nombre de la planta |
| `city` | VARCHAR | Ciudad |
| `state` | VARCHAR | Estado |
| `country` | VARCHAR | País |
| `plant_type` | VARCHAR | Tipo de planta (Assembly) |

### `dim_work_center`

| Columna | Tipo | Descripción |
| :--- | :--- | :--- |
| `work_center_key` | INT (PK) | Surrogate key |
| `work_center_code` | VARCHAR | Código del work center (ej. WC-01) |
| `work_center_name` | VARCHAR | Nombre del work center |
| `plant_code` | VARCHAR | Planta asociada |
| `production_area` | VARCHAR | Área de producción |
| `capacity_units_day` | INT | Capacidad diaria en unidades |
| `status` | VARCHAR | Estatus (Active) |

### `dim_date`

| Columna | Tipo | Descripción |
| :--- | :--- | :--- |
| `date_key` | INT (PK) | Surrogate key (formato YYYYMMDD) |
| `full_date` | DATE | Fecha completa |
| `year` | INT | Año |
| `month_number` | INT | Número de mes (1–12) |
| `month_name` | VARCHAR | Nombre del mes |
| `quarter` | INT | Trimestre |

---

## 📈 Tablas de hechos

### `fact_demand`

**Granularidad:** producto + planta + fecha + tipo

| Columna | Tipo | Descripción |
| :--- | :--- | :--- |
| `product_key` | INT (FK) | Producto |
| `plant_key` | INT (FK) | Planta |
| `date_key` | INT (FK) | Fecha |
| `demand_type` | VARCHAR | Actual o Forecast |
| `demand_qty` | INT | Cantidad demandada |

### `fact_inventory`

**Granularidad:** producto + planta + snapshot date

| Columna | Tipo | Descripción |
| :--- | :--- | :--- |
| `product_key` | INT (FK) | Producto |
| `plant_key` | INT (FK) | Planta |
| `date_key` | INT (FK) | Fecha del snapshot |
| `inventory_qty` | INT | Cantidad en inventario |

### `fact_purchase_orders`

**Granularidad:** línea de PO

| Columna | Tipo | Descripción |
| :--- | :--- | :--- |
| `po_number` | VARCHAR | Número de orden de compra |
| `po_line` | INT | Línea de la PO |
| `product_key` | INT (FK) | Producto |
| `supplier_key` | INT (FK) | Proveedor |
| `plant_key` | INT (FK) | Planta |
| `order_date_key` | INT (FK) | Fecha de orden |
| `promised_date_key` | INT (FK) | Fecha prometida |
| `receipt_date_key` | INT (FK) | Fecha de recepción |
| `ordered_qty` | INT | Cantidad ordenada |
| `po_status` | VARCHAR | Estatus de la PO |

### `fact_production`

**Granularidad:** orden de producción

| Columna | Tipo | Descripción |
| :--- | :--- | :--- |
| `production_order` | VARCHAR | Número de orden de producción |
| `product_key` | INT (FK) | Producto |
| `plant_key` | INT (FK) | Planta |
| `work_center_key` | INT (FK) | Work center |
| `production_date_key` | INT (FK) | Fecha de producción |
| `planned_start_date_key` | INT (FK) | Fecha planeada de inicio |
| `actual_start_date_key` | INT (FK) | Fecha real de inicio |
| `planned_qty` | INT | Cantidad planeada |
| `actual_qty` | INT | Cantidad real producida |
| `production_status` | VARCHAR | Estatus (Completed) |

---

## 🔗 Relaciones

Las dimensiones se relacionan con las tablas de hechos mediante surrogate keys:

- `dim_product.product_key` → `fact_demand`, `fact_inventory`, `fact_purchase_orders`, `fact_production`
- `dim_supplier.supplier_key` → `fact_purchase_orders`
- `dim_plant.plant_key` → `fact_demand`, `fact_inventory`, `fact_purchase_orders`, `fact_production`
- `dim_work_center.work_center_key` → `fact_production`
- `dim_date.date_key` → `fact_demand`, `fact_inventory`, `fact_purchase_orders`, `fact_production`

**No hay joins directos entre tablas de hechos.**

---

## 🧮 Métricas calculadas (no almacenadas)

| Métrica | Fórmula | Dónde se calcula |
| :--- | :--- | :--- |
| `production_gap` | `actual_qty - planned_qty` | DAX |
| `production_attainment` | `actual_qty / planned_qty` | DAX |
| `days_late` | `receipt_date - promised_date` | DAX |
| `inventory_coverage_months` | `avg_inventory / avg_monthly_demand` | SQL + DAX |
| `fulfillment_risk_score` | Suma de 3 señales (demanda, inventario, producción) | DAX |

---

## ⚠️ Notas sobre calidad de datos

Los datos RAW incluyen problemas controlados para simular un entorno real:

- Espacios al final en códigos (`"P-1001 "`).
- Diferencias de capitalización en estatus (`"Received"`, `"RECEIVED"`).
- Algunos duplicados controlados.
- Valores nulos razonables (`receipt_date` vacío para PO abiertas).
- Errores de referencia controlados (`product_code` que no existe en el maestro).

Estos problemas se documentan y se tratan en la capa de staging.

---

> **Nota:** NovaTech Electronics es una empresa ficticia. Los datos son sintéticos y fueron diseñados para representar problemas operativos reales. No representan a ninguna empresa real.