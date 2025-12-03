create table default_fields (
    id            SERIAL primary key,
    updated_date  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_date  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

create table company (
    id       SERIAL primary key,
    name     varchar(255) not null,
    email    varchar(255),
    website  varchar(255),
    industry varchar(255),
    country  varchar(255),
    size     int
) inherits (default_fields);

create table person (
    id         SERIAL primary key,
    company_id int references company(id),
    first_name varchar(255) not null,
    last_name  varchar(255) not null,
    email      varchar(255),
    phone      varchar(50),
    country    varchar(255)
) inherits (default_fields);

create table contact (
    id         SERIAL primary key
--    lead_id    int references lead(id)
) inherits (person);

create table lead (
    id         SERIAL primary key,
    contact_id int references contact(id) not null,
    source     varchar(255),
    role       varchar(255)
) inherits (person);
alter table contact add column lead_id int references lead(id);

create table opportunity (
	id			  SERIAL primary key,
    name          varchar(255) not null,
    subject       varchar(255),
    lead_id       int references lead(id),
    authority_id  int references lead(id),
    value         currency  check ((value).amount >= 0),
    stage         opportunity_stage DEFAULT 'new',
    start_date    DATE,
    end_date      DATE,
    budget_min    currency CHECK ((budget_min).amount >= 0),
    budget_max    currency CHECK ((budget_max).amount >= (budget_min).amount)
) inherits (default_fields);

create table contract (
    id             SERIAL primary key,
    opportunity_id int references opportunity(id) not null,
    amount         currency check ((amount).amount >= 0)
) inherits (default_fields);

create table skill (
    id          SERIAL primary key,
    name        varchar(255) unique not null,
    category    varchar(255),
    description text
) inherits (default_fields);

create table person_skill (
    person_id         int references person(id) not null,
    skill_id          int references skill(id)  not null,
    proficiency_level int CHECK (proficiency_level >= 1 AND proficiency_level <= 5),
    UNIQUE (person_id, skill_id)
) inherits (default_fields);

create table opportunity_skill (
    opportunity_id int references opportunity(id) not null,
    skill_id       int references skill(id) not null,
    importance     int CHECK (importance >= 1 AND importance <= 5),
    UNIQUE (opportunity_id, skill_id)
) inherits (default_fields);

CREATE TABLE invoice (
    id          SERIAL primary key,
    value	    currency check ((value).amount >= 0),
    contract_id int references contract(id) not null
) inherits (default_fields);

create table activity (
    id             SERIAL primary key,
    name           varchar(255) not null,
    person_id      int references person(id) not null,
    opportunity_id int references opportunity(id),
    type           varchar(255) not null,
    start_date     TIMESTAMP,
    end_date       TIMESTAMP,
    description    varchar(1000),
    status         activity_status DEFAULT 'new'
) inherits (default_fields);
create table event (
    id          SERIAL primary key
) inherits (activity);
create table task (
    id          SERIAL primary key
) inherits (activity);

create table expense (
    id          SERIAL primary key,
    value currency check ((value).amount >= 0)
) inherits (default_fields);
