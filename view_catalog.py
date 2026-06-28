import json

with open('target/catalog.json', 'r') as f:
    catalog = json.load(f)

print("\n" + "="*80)
print("DBT CATALOG - All Tables")
print("="*80 + "\n")

# Display sources (raw tables)
if 'sources' in catalog:
    print("📦 RAW SOURCES:")
    for source_key, source_data in catalog['sources'].items():
        print(f"  {source_key}")
        if 'columns' in source_data:
            for col_name, col_info in source_data['columns'].items():
                col_type = col_info.get('type', 'unknown')
                print(f"    └─ {col_name}: {col_type}")
    print()

# Display models (transformed tables)
if 'nodes' in catalog:
    print("🔄 MODELS (Transformed):")
    for node_key, node_data in catalog['nodes'].items():
        if 'columns' in node_data:
            print(f"  {node_key}")
            for col_name, col_info in node_data['columns'].items():
                col_type = col_info.get('type', 'unknown')
                print(f"    └─ {col_name}: {col_type}")
    print()

print("="*80 + "\n")