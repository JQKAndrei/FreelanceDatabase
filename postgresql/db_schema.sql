create table default_fields (
    id            SERIAL primary key,
    updated_date  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_date  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

create table company (
    name     varchar(255) not null,
    email    varchar(255),
    website  varchar(255),
    industry varchar(255),
    country  varchar(255),
    size     int
) inherits (default_fields);
alter table company add primary key (id);

create table person (
    company_id int references company(id),
    first_name varchar(255) not null,
    last_name  varchar(255) not null,
    email      varchar(255),
    phone      varchar(50),
    country    varchar(255)
) inherits (default_fields);
alter table person add primary key (id);

create table contact (
--    lead_id    int references lead(id)
) inherits (person);
alter table contact add primary key (id);

create table lead (
    contact_id int references contact(id) not null,
    source     varchar(255),
    role       varchar(255)
) inherits (person);
alter table lead add primary key (id);
alter table contact add column lead_id int references lead(id);

create table opportunity (
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
alter table opportunity add primary key (id);

create table contract (
    opportunity_id int references opportunity(id) not null,
    amount         currency check ((amount).amount >= 0)
) inherits (default_fields);
alter table contract add primary key (id);

create table skill (
    name        varchar(255) unique not null,
    category    varchar(255),
    description text
) inherits (default_fields);
alter table skill add primary key (id);

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
    value       currency check ((value).amount >= 0),
    contract_id int references contract(id) not null
) inherits (default_fields);
alter table invoice add primary key (id);

create table activity (
    name           varchar(255) not null,
    person_id      int references person(id) not null,
    opportunity_id int references opportunity(id),
    type           varchar(255) not null,
    start_date     TIMESTAMP,
    end_date       TIMESTAMP,
    description    varchar(1000),
    status         activity_status DEFAULT 'new'
) inherits (default_fields);
alter table activity add primary key (id);

create table event () inherits (activity);
alter table event add primary key (id);
create table task () inherits (activity);
alter table task add primary key (id);

create table expense (
    value currency check ((value).amount >= 0)
) inherits (default_fields);
alter table expense add primary key (id);
