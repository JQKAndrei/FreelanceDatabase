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

CREATE TYPE currency_code AS ENUM ('USD', 'EUR', 'GBP');

create type currency as (
    amount         NUMERIC(10,2),
    currency_code  currency_code
);
