-- Basic table
CREATE TABLE person (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name  VARCHAR(255) NOT NULL,
    email      VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Add a column
ALTER TABLE person ADD COLUMN phone VARCHAR(50);

-- Drop a column
ALTER TABLE person DROP COLUMN phone CASCADE;

-- Define a type
CREATE TYPE currency AS (
    amount NUMERIC(10,2),
    code   CHAR(3)
);

-- Table using type
CREATE TABLE invoice (
    total currency,
    CHECK ((total).amount >= 0)
);

-- Access composite fields
SELECT (total).amount, (total).code FROM invoice;

-- Enum
CREATE TYPE opportunity_stage AS ENUM ('new','qualification','proposal','won','lost');

-- Domain for reusable constraints
CREATE DOMAIN positive_amount AS NUMERIC(10,2) CHECK (VALUE >= 0);

-- Table using domain
CREATE TABLE payment (
    amount positive_amount DEFAULT 0.00,
    currency CHAR(3) DEFAULT 'USD'
);

-- One-to-many
CREATE TABLE lead (
    id SERIAL PRIMARY KEY,
    contact_id INT NOT NULL REFERENCES contact(id)
);

CREATE TABLE contact (
    id SERIAL PRIMARY KEY,
    lead_id INT REFERENCES lead(id)  -- optional
);

-- Many-to-many
CREATE TABLE person_skill (
    person_id INT REFERENCES person(id),
    skill_id  INT REFERENCES skill(id),
    proficiency INT CHECK (proficiency BETWEEN 1 AND 5),
    PRIMARY KEY (person_id, skill_id)
);

-- Trigger function for updated_at
CREATE OR REPLACE FUNCTION set_updated_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at := CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Attach to parent table (inherited by all children)
CREATE TRIGGER update_timestamp
BEFORE UPDATE ON default_fields
FOR EACH ROW
EXECUTE PROCEDURE set_updated_timestamp();

-- View
CREATE VIEW contact_skills AS
SELECT c.id AS contact_id, c.first_name, c.last_name, s.name AS skill_name
FROM contact c
JOIN person_skill ps ON ps.person_id = c.id
JOIN skill s ON ps.skill_id = s.id;

-- Query view like a table
SELECT * FROM contact_skills WHERE skill_name = 'Python';

-- Materialized view
CREATE MATERIALIZED VIEW top_skilled_contacts AS
SELECT person_id, COUNT(*) AS skill_count
FROM person_skill
GROUP BY person_id;

-- Refresh materialized view
REFRESH MATERIALIZED VIEW top_skilled_contacts;

-- pg_cron extension
SELECT cron.schedule(
    '0 2 * * *',
    $$UPDATE orders SET status='archived' WHERE order_date < NOW() - INTERVAL '1 year';$$
);

-- Simple select
SELECT * FROM person;

-- Filter
SELECT * FROM opportunity WHERE stage='proposal';

-- Join
SELECT o.name, c.first_name, c.last_name
FROM opportunity o
JOIN contact c ON o.lead_id = c.id;

-- Aggregate
SELECT skill_id, AVG(proficiency) AS avg_level
FROM person_skill
GROUP BY skill_id;

-- Drop all tables in 'public' schema (dev only)
DO $$
DECLARE r RECORD;
BEGIN
    FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname='public') LOOP
        EXECUTE 'DROP TABLE IF EXISTS ' || quote_ident(r.tablename) || ' CASCADE';
    END LOOP;
END
$$;

-- Key-value configuration table
CREATE TABLE app_config (
    key   TEXT PRIMARY KEY,
    value TEXT NOT NULL
);

INSERT INTO app_config (key, value) VALUES
('MAX_DISCOUNT', '20'),
('DEFAULT_CURRENCY', 'USD');

-- Access via query
SELECT value FROM app_config WHERE key='MAX_DISCOUNT';

-- Optional: function returning constant
CREATE FUNCTION max_discount() RETURNS INT AS $$
BEGIN
    RETURN 20;
END;
$$ LANGUAGE plpgsql IMMUTABLE;