INSERT INTO person_skill (person_id, skill_id, proficiency_level)
SELECT 1, id, 3
FROM skill
WHERE name IN ('Python', 'SQL', 'Java', 'Apex', 'JavaScript', 'LWC', 'HTML', 'CSS', 'Salesforce', 'ReactJS');