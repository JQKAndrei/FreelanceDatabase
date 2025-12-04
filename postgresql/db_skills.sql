insert into person (first_name, last_name, email, country)
values ('Andrei', 'Stanciu', 'jqkandrei@gmail.com', 'romania');

insert into skill
(name,category)
values 
('Python'            , 'back-end'),
('Java'              , 'back-end'),
('Apex'              , 'back-end'),
('SQL'               , 'database'),
('PostgreSQL'        , 'database'),
('MongoDB'           , 'database'),
('Redis'             , 'database'),
('MuleSoft'          , 'database'),
('JavaScript'        , 'front-end'),
('ReactJS'           , 'front-end'),
('LWC'               , 'front-end'),
('HTML'              , 'front-end'),
('CSS'               , 'front-end'),
('Figma'             , 'design'),
('Salesforce'        , 'ecosystem'),
('Sales Cloud'       , 'salesforce'),
('Service Cloud'     , 'salesforce'),
('Commerce Cloud'    , 'salesforce'),
('Loyalty Management', 'salesforce'),
('Marketing Cloud'   , 'salesforce'),
('Experience Cloud'  , 'salesforce'),
('Tableau CRM'       , 'salesforce'),
('Einstein AI'       , 'salesforce')
;

INSERT INTO person_skill (person_id, skill_id, proficiency_level)
SELECT 1, s.id, v.proficiency_level
FROM skill s
JOIN ( values
        ('Apex'      , 5),
        ('LWC'       , 5),
        ('Python'    , 4),
        ('Java'      , 4),
        ('JavaScript', 4),
        ('HTML'      , 4),
        ('CSS'       , 4),
        ('Salesforce', 4),
        ('SQL'       , 3),
        ('ReactJS'   , 3)
) AS v(name, proficiency_level)
ON s.name = v.name;