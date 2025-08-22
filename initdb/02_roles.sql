-- create writer
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'bitcraftmapwriter') THEN
        CREATE ROLE bitcraftmapwriter LOGIN PASSWORD 'change-me-writer';
    END IF;
END$$;

-- create reader
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'bitcraftmapreader') THEN
        CREATE ROLE bitcraftmapreader LOGIN PASSWORD 'change-me-reader';
    END IF;
END$$;

-- grant privileges
GRANT CONNECT ON DATABASE bitcraftmapdb TO bitcraftmapwriter, bitcraftmapreader;
GRANT USAGE ON SCHEMA bitcraft TO bitcraftmapwriter, bitcraftmapreader;

-- writer: full DML
GRANT INSERT, UPDATE, DELETE, SELECT ON ALL TABLES IN SCHEMA bitcraft TO bitcraftmapwriter;
ALTER DEFAULT PRIVILEGES IN SCHEMA bitcraft GRANT INSERT, UPDATE, DELETE, SELECT ON TABLES TO bitcraftmapwriter;

-- reader: read-only
GRANT SELECT ON ALL TABLES IN SCHEMA bitcraft TO bitcraftmapreader;
ALTER DEFAULT PRIVILEGES IN SCHEMA bitcraft GRANT SELECT ON TABLES TO bitcraftmapreader;