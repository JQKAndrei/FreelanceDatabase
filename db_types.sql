create type opportunity_stage as enum (
    'new',
    'qualified',
    'proposal',
    'negotiation',
    'closed_won',
    'closed_lost'
);
create type activity_status as enum (
    'new',
    'pending',
    'scheduled',
    'in_progress',
    'completed',
    'canceled'
);
CREATE TYPE currency AS (
    amount         NUMERIC(10,2) CHECK (amount >= 0),
    currency_code  CHAR(3) DEFAULT 'USD'
);
