-- Claims table
CREATE TABLE IF NOT EXISTS claims (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name       TEXT NOT NULL,
  tier       INTEGER NOT NULL CHECK (x BETWEEN 0 AND 10),
  x          INTEGER NOT NULL CHECK (x BETWEEN 0 AND 23040),
  y          INTEGER NOT NULL CHECK (y BETWEEN 0 AND 23040),
  props      JSONB NOT NULL DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (name, x, y),
  geom GEOMETRY(POINT, 0) GENERATED ALWAYS AS (ST_SetSRID(ST_MakePoint(x, y), 0)) STORED
);

-- Indexes
CREATE INDEX IF NOT EXISTS claims_xy_idx    ON claims (x, y);
CREATE INDEX IF NOT EXISTS claims_name_idx  ON claims (name);
CREATE INDEX IF NOT EXISTS claims_geom_gix  ON claims USING GIST (geom);

-- Table-level grants (explicit for objects created in this file)
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE claims TO bitcraftmapwriter;
GRANT SELECT ON TABLE claims TO bitcraftmapreader;