#!/usr/bin/env bash

# Export env variables from the .env file
export $(grep -v '^#' .env | xargs)

# Generate the servers.json for pgadmin
envsubst < pgadmin/servers.json.template > pgadmin/servers.json
envsubst < initdb/00_extensions.sql.template > initdb/00_extensions.sql
envsubst < initdb/01_schema.sql.template > initdb/01_schema.sql
envsubst < initdb/02_tables.sql.template > initdb/02_tables.sql

# Start Docker Desktop if its not up
if ! docker info >/dev/null 2>&1; then
    powershell.exe -Command "Start-Process 'C:\Program Files\Docker\Docker\Docker Desktop.exe'"

    while ! docker info >/dev/null 2>&1; do
        sleep 1
    done
    echo "Docker is up."
else
    echo "Docker already running."
fi

docker compose --env-file .env up -d