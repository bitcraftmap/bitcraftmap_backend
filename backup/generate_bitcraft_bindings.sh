# Made by viseyth @https://github.com/vis-eyth/bitcraft-bindings
#!/usr/bin/env bash

test -d src/module_bindings/global && rm -r src/module_bindings/global
test -d src/module_bindings/region && rm -r src/module_bindings/region

# global bindings
curl https://bitcraft-early-access.spacetimedb.com/v1/database/bitcraft-global/schema?version=9 | jq '{"V9": .}' > data/schema_global.json
spacetime generate --module-def data/schema_global.json --lang rust --out-dir src/module_bindings/global

# region bindings
curl https://bitcraft-early-access.spacetimedb.com/v1/database/bitcraft-1/schema?version=9 | jq '{"V9": .}' > data/schema_region.json
spacetime generate --module-def data/schema_region.json --lang rust --out-dir src/module_bindings/region

sed -i "s/^version = .*$/version = \"$(date -u +%Y.%-m.%-d)\"/" Cargo.toml
