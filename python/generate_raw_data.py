"""
Synthetic Data Generator - NovaTech Electronics
Project: Manufacturing Operations & Demand Planning Analytics

This script generates 8 raw CSV files simulating an ERP, MES, and Demand Planning system.
It uses a fixed random seed for reproducibility.
"""

import pandas as pd
import numpy as np
from datetime import datetime, timedelta
import random
import os

# ============================================================
# CONFIGURATION
# ============================================================

RANDOM_SEED = 42
random.seed(RANDOM_SEED)
np.random.seed(RANDOM_SEED)

START_DATE = datetime(2025, 1, 1)
END_DATE = datetime(2026, 12, 31)
MONTHS = pd.date_range(START_DATE, END_DATE, freq='MS')

OUTPUT_DIR = 'raw_data'
os.makedirs(OUTPUT_DIR, exist_ok=True)

# ============================================================
# 1. RAW PRODUCTS
# ============================================================

products = [
    {'product_code': 'P-1001', 'product_name': 'Smart Sensor X1', 'product_category': 'Sensors', 'product_family': 'Industrial Sensors', 'unit_of_measure': 'EA', 'plant_code': 'PL01', 'standard_cost': 42.50, 'product_status': 'Active'},
    {'product_code': 'P-1002', 'product_name': 'Smart Sensor X2', 'product_category': 'Sensors', 'product_family': 'Industrial Sensors', 'unit_of_measure': 'EA', 'plant_code': 'PL01', 'standard_cost': 47.80, 'product_status': 'Active'},
    {'product_code': 'P-1003', 'product_name': 'Power Controller A', 'product_category': 'Controllers', 'product_family': 'Power Controllers', 'unit_of_measure': 'EA', 'plant_code': 'PL02', 'standard_cost': 68.20, 'product_status': 'Active'},
    {'product_code': 'P-1004', 'product_name': 'Power Controller B', 'product_category': 'Controllers', 'product_family': 'Power Controllers', 'unit_of_measure': 'EA', 'plant_code': 'PL02', 'standard_cost': 74.50, 'product_status': 'Active'},
    {'product_code': 'P-1005', 'product_name': 'Connect Module A', 'product_category': 'Connectivity', 'product_family': 'Connectivity Modules', 'unit_of_measure': 'EA', 'plant_code': 'PL01', 'standard_cost': 31.40, 'product_status': 'Active'},
    {'product_code': 'P-1006', 'product_name': 'Connect Module B', 'product_category': 'Connectivity', 'product_family': 'Connectivity Modules', 'unit_of_measure': 'EA', 'plant_code': 'PL03', 'standard_cost': 36.90, 'product_status': 'Active'},
    {'product_code': 'P-1007', 'product_name': 'Embedded Unit A', 'product_category': 'Embedded Components', 'product_family': 'Embedded Units', 'unit_of_measure': 'EA', 'plant_code': 'PL03', 'standard_cost': 82.00, 'product_status': 'Active'},
    {'product_code': 'P-1008', 'product_name': 'Legacy Controller', 'product_category': 'Controllers', 'product_family': 'Legacy Controllers', 'unit_of_measure': 'EA', 'plant_code': 'PL02', 'standard_cost': 55.00, 'product_status': 'Inactive'},
]

# Add 52 more products
for i in range(9, 61):
    plant = random.choice(['PL01', 'PL02', 'PL03'])
    category = random.choice(['Sensors', 'Controllers', 'Connectivity', 'Embedded Components', 'Power Management'])
    family = f'{category} Family {random.randint(1, 5)}'
    products.append({
        'product_code': f'P-{1000+i}',
        'product_name': f'Product {i}',
        'product_category': category,
        'product_family': family,
        'unit_of_measure': 'EA',
        'plant_code': plant,
        'standard_cost': round(random.uniform(15, 120), 2),
        'product_status': random.choice(['Active'] * 9 + ['Inactive'])
    })

df_products = pd.DataFrame(products)
df_products.to_csv(f'{OUTPUT_DIR}/raw_products.csv', index=False)
print(f'raw_products.csv: {len(df_products)} rows')

# ============================================================
# 2. RAW SUPPLIERS
# ============================================================

suppliers = [
    {'supplier_code': 'SUP-001', 'supplier_name': 'Global Components Ltd', 'country': 'USA', 'supplier_category': 'Electronics', 'default_lead_time_days': 14, 'supplier_status': 'Active'},
    {'supplier_code': 'SUP-002', 'supplier_name': 'Pacific Semiconductors', 'country': 'Taiwan', 'supplier_category': 'Semiconductors', 'default_lead_time_days': 21, 'supplier_status': 'Active'},
    {'supplier_code': 'SUP-003', 'supplier_name': 'Monterrey Industrial Supply', 'country': 'Mexico', 'supplier_category': 'Electronics', 'default_lead_time_days': 7, 'supplier_status': 'Active'},
    {'supplier_code': 'SUP-004', 'supplier_name': 'Andes Electronic Parts', 'country': 'Chile', 'supplier_category': 'Electronics', 'default_lead_time_days': 18, 'supplier_status': 'Active'},
    {'supplier_code': 'SUP-005', 'supplier_name': 'Precision Power Systems', 'country': 'USA', 'supplier_category': 'Power Components', 'default_lead_time_days': 12, 'supplier_status': 'Active'},
    {'supplier_code': 'SUP-006', 'supplier_name': 'Asia Embedded Solutions', 'country': 'Vietnam', 'supplier_category': 'Embedded Components', 'default_lead_time_days': 25, 'supplier_status': 'Active'},
    {'supplier_code': 'SUP-007', 'supplier_name': 'Local Tech Supply', 'country': 'Mexico', 'supplier_category': 'Electronics', 'default_lead_time_days': 5, 'supplier_status': 'Active'},
]

df_suppliers = pd.DataFrame(suppliers)
df_suppliers.to_csv(f'{OUTPUT_DIR}/raw_suppliers.csv', index=False)
print(f'raw_suppliers.csv: {len(df_suppliers)} rows')

# ============================================================
# 3. RAW PLANTS
# ============================================================

plants = [
    {'plant_code': 'PL01', 'plant_name': 'Guadalajara Plant', 'city': 'Guadalajara', 'state': 'Jalisco', 'country': 'Mexico', 'plant_type': 'Assembly'},
    {'plant_code': 'PL02', 'plant_name': 'Monterrey Plant', 'city': 'Monterrey', 'state': 'Nuevo Leon', 'country': 'Mexico', 'plant_type': 'Assembly'},
    {'plant_code': 'PL03', 'plant_name': 'Tijuana Plant', 'city': 'Tijuana', 'state': 'Baja California', 'country': 'Mexico', 'plant_type': 'Assembly'},
]

df_plants = pd.DataFrame(plants)
df_plants.to_csv(f'{OUTPUT_DIR}/raw_plants.csv', index=False)
print(f'raw_plants.csv: {len(df_plants)} rows')

# ============================================================
# 4. RAW WORK CENTERS
# ============================================================

work_centers = [
    {'work_center_code': 'WC-01', 'work_center_name': 'SMT Line 01', 'plant_code': 'PL01', 'production_area': 'Electronics Assembly', 'capacity_units_day': 8000, 'status': 'Active'},
    {'work_center_code': 'WC-02', 'work_center_name': 'SMT Line 02', 'plant_code': 'PL01', 'production_area': 'Electronics Assembly', 'capacity_units_day': 7500, 'status': 'Active'},
    {'work_center_code': 'WC-03', 'work_center_name': 'Final Assembly 01', 'plant_code': 'PL01', 'production_area': 'Final Assembly', 'capacity_units_day': 6000, 'status': 'Active'},
    {'work_center_code': 'WC-04', 'work_center_name': 'SMT Line 01', 'plant_code': 'PL02', 'production_area': 'Electronics Assembly', 'capacity_units_day': 7000, 'status': 'Active'},
    {'work_center_code': 'WC-05', 'work_center_name': 'Final Assembly 01', 'plant_code': 'PL02', 'production_area': 'Final Assembly', 'capacity_units_day': 5500, 'status': 'Active'},
    {'work_center_code': 'WC-06', 'work_center_name': 'SMT Line 01', 'plant_code': 'PL03', 'production_area': 'Electronics Assembly', 'capacity_units_day': 6500, 'status': 'Active'},
    {'work_center_code': 'WC-07', 'work_center_name': 'SMT Line 02', 'plant_code': 'PL03', 'production_area': 'Electronics Assembly', 'capacity_units_day': 6000, 'status': 'Active'},
    {'work_center_code': 'WC-08', 'work_center_name': 'Final Assembly 01', 'plant_code': 'PL03', 'production_area': 'Final Assembly', 'capacity_units_day': 5000, 'status': 'Active'},
]

df_work_centers = pd.DataFrame(work_centers)
df_work_centers.to_csv(f'{OUTPUT_DIR}/raw_work_centers.csv', index=False)
print(f'raw_work_centers.csv: {len(df_work_centers)} rows')

# ============================================================
# 5. RAW DEMAND
# ============================================================

demand_records = []
active_products = df_products[df_products['product_status'] == 'Active']

for _, product in active_products.iterrows():
    product_code = product['product_code']
    plant_code = product['plant_code']
    base_demand = random.randint(3000, 8000)
    
    # Assign a pattern to each product
    pattern = random.choice(['growing', 'declining', 'stable', 'volatile'])
    
    for month_idx, month in enumerate(MONTHS):
        if pattern == 'growing':
            factor = 1 + (month_idx * 0.05)
        elif pattern == 'declining':
            factor = 1 - (month_idx * 0.03)
        elif pattern == 'stable':
            factor = 1 + random.uniform(-0.05, 0.05)
        else:
            factor = 1 + random.uniform(-0.20, 0.20)
        
        demand_qty = int(base_demand * factor)
        
        demand_records.append({
            'demand_date': month.strftime('%Y-%m-%d'),
            'product_code': product_code,
            'plant_code': plant_code,
            'demand_qty': demand_qty,
            'demand_type': 'Actual',
            'customer_segment': random.choice(['Industrial', 'Automotive', 'Consumer', 'Medical'])
        })
    
    # Add forecast for the last 3 months
    for month in MONTHS[-3:]:
        forecast_qty = int(base_demand * random.uniform(0.9, 1.1))
        demand_records.append({
            'demand_date': month.strftime('%Y-%m-%d'),
            'product_code': product_code,
            'plant_code': plant_code,
            'demand_qty': forecast_qty,
            'demand_type': 'Forecast',
            'customer_segment': random.choice(['Industrial', 'Automotive', 'Consumer', 'Medical'])
        })

df_demand = pd.DataFrame(demand_records)
df_demand.to_csv(f'{OUTPUT_DIR}/raw_demand.csv', index=False)
print(f'raw_demand.csv: {len(df_demand)} rows')

# ============================================================
# 6. RAW INVENTORY
# ============================================================

inventory_records = []

for _, product in active_products.iterrows():
    product_code = product['product_code']
    plant_code = product['plant_code']
    base_inventory = random.randint(5000, 20000)
    
    # Assign pattern
    pattern = random.choice(['declining', 'growing', 'stable'])
    
    for month_idx, month in enumerate(MONTHS):
        if pattern == 'declining':
            factor = 1 - (month_idx * 0.06)
        elif pattern == 'growing':
            factor = 1 + (month_idx * 0.04)
        else:
            factor = 1 + random.uniform(-0.10, 0.10)
        
        inventory_qty = max(0, int(base_inventory * factor))
        inventory_status = random.choice(['Available'] * 9 + ['Blocked'])
        
        inventory_records.append({
            'snapshot_date': month.strftime('%Y-%m-%d'),
            'product_code': product_code,
            'plant_code': plant_code,
            'inventory_qty': inventory_qty,
            'inventory_status': inventory_status,
            'inventory_value': round(inventory_qty * product['standard_cost'], 2)
        })

df_inventory = pd.DataFrame(inventory_records)
df_inventory.to_csv(f'{OUTPUT_DIR}/raw_inventory.csv', index=False)
print(f'raw_inventory.csv: {len(df_inventory)} rows')

# ============================================================
# 7. RAW PURCHASE ORDERS
# ============================================================

po_records = []
po_counter = 50001

for month_idx, month in enumerate(MONTHS):
    num_pos = random.randint(20, 40)
    
    for _ in range(num_pos):
        supplier = random.choice(suppliers)
        product = random.choice(products)
        plant = random.choice(plants)
        
        order_date = month + timedelta(days=random.randint(0, 25))
        lead_time = supplier['default_lead_time_days'] + random.randint(-3, 10)
        promised_date = order_date + timedelta(days=lead_time)
        
        # 80% received, 20% open/partially received
        if random.random() < 0.80:
            delay = random.randint(-2, 7)
            receipt_date = promised_date + timedelta(days=delay)
            po_status = 'Received'
        else:
            receipt_date = None
            po_status = random.choice(['Open', 'Partially Received'])
        
        po_records.append({
            'po_number': f'PO-{po_counter}',
            'po_line': 1,
            'order_date': order_date.strftime('%Y-%m-%d'),
            'supplier_code': supplier['supplier_code'],
            'product_code': product['product_code'],
            'plant_code': plant['plant_code'],
            'ordered_qty': random.randint(1000, 8000),
            'promised_date': promised_date.strftime('%Y-%m-%d'),
            'receipt_date': receipt_date.strftime('%Y-%m-%d') if receipt_date else '',
            'po_status': po_status
        })
        po_counter += 1

df_purchase_orders = pd.DataFrame(po_records)
df_purchase_orders.to_csv(f'{OUTPUT_DIR}/raw_purchase_orders.csv', index=False)
print(f'raw_purchase_orders.csv: {len(df_purchase_orders)} rows')

# ============================================================
# 8. RAW PRODUCTION ORDERS
# ============================================================

production_records = []
mo_counter = 80001

for month_idx, month in enumerate(MONTHS):
    num_mos = random.randint(30, 50)
    
    for _ in range(num_mos):
        product = random.choice(products)
        plant = random.choice(plants)
        work_center = random.choice([wc for wc in work_centers if wc['plant_code'] == plant['plant_code']])
        
        production_date = month + timedelta(days=random.randint(0, 25))
        planned_qty = random.randint(3000, 7000)
        
        # 85% on plan, 15% below plan
        if random.random() < 0.85:
            actual_qty = int(planned_qty * random.uniform(0.95, 1.02))
        else:
            actual_qty = int(planned_qty * random.uniform(0.75, 0.92))
        
        # Start delay
        if random.random() < 0.15:
            actual_start_date = production_date + timedelta(days=random.randint(1, 3))
        else:
            actual_start_date = production_date
        
        production_records.append({
            'production_order': f'MO-{mo_counter}',
            'production_date': production_date.strftime('%Y-%m-%d'),
            'product_code': product['product_code'],
            'plant_code': plant['plant_code'],
            'work_center_code': work_center['work_center_code'],
            'planned_qty': planned_qty,
            'actual_qty': actual_qty,
            'production_status': 'Completed',
            'planned_start_date': production_date.strftime('%Y-%m-%d'),
            'actual_start_date': actual_start_date.strftime('%Y-%m-%d')
        })
        mo_counter += 1

df_production = pd.DataFrame(production_records)
df_production.to_csv(f'{OUTPUT_DIR}/raw_production_orders.csv', index=False)
print(f'raw_production_orders.csv: {len(df_production)} rows')

# ============================================================
# SUMMARY
# ============================================================

print('\n' + '='*60)
print('DATA GENERATION COMPLETE')
print('='*60)
print(f'Output directory: {OUTPUT_DIR}')
print(f'Files generated: 8')
print(f'Random seed: {RANDOM_SEED}')
print('='*60)