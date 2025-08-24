CREATE SCHEMA IF NOT EXISTS bitcraftmap AUTHORIZATION bitcraftmapadmin;

-- lock down public
REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE CREATE ON SCHEMA public FROM PUBLIC;

-- role hardening
ALTER ROLE bitcraftmapwriter  NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT LOGIN;
ALTER ROLE bitcraftmapreader  NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT LOGIN;

-- search_path
ALTER ROLE bitcraftmapadmin   SET search_path = bitcraftmap;
ALTER ROLE bitcraftmapwriter  SET search_path = bitcraftmap;
ALTER ROLE bitcraftmapreader  SET search_path = bitcraftmap;

-- writer role
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname='bitcraftmapwriter') THEN
        EXECUTE format('CREATE ROLE %I LOGIN PASSWORD %L','bitcraftmapwriter', 'change_this_pls');
    END IF;
END$$;

-- reader role
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname='bitcraftmapreader') THEN
        EXECUTE format('CREATE ROLE %I LOGIN PASSWORD %L','bitcraftmapreader', 'change_this_pls');
    END IF;
END$$;

-- functions and sequences (existing)
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA bitcraftmap TO bitcraftmapwriter, bitcraftmapreader;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA bitcraftmap TO bitcraftmapwriter;

-- privileges
GRANT CONNECT ON DATABASE bitcraftmapdb TO bitcraftmapwriter;
GRANT CONNECT ON DATABASE bitcraftmapdb TO bitcraftmapreader;

GRANT USAGE ON SCHEMA bitcraftmap TO bitcraftmapwriter;
GRANT USAGE ON SCHEMA bitcraftmap TO bitcraftmapreader;

GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA bitcraftmap TO bitcraftmapwriter;
GRANT SELECT ON ALL TABLES IN SCHEMA bitcraftmap TO bitcraftmapreader;

ALTER DEFAULT PRIVILEGES IN SCHEMA bitcraftmap
    GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO bitcraftmapwriter;
ALTER DEFAULT PRIVILEGES IN SCHEMA bitcraftmap
    GRANT SELECT ON TABLES TO bitcraftmapreader;

-- future objects owned by the admin
ALTER DEFAULT PRIVILEGES FOR ROLE bitcraftmapadmin IN SCHEMA bitcraftmap
    GRANT EXECUTE ON FUNCTIONS TO bitcraftmapwriter, bitcraftmapreader;
ALTER DEFAULT PRIVILEGES FOR ROLE bitcraftmapadmin IN SCHEMA bitcraftmap
    GRANT USAGE, SELECT ON SEQUENCES TO bitcraftmapwriter;