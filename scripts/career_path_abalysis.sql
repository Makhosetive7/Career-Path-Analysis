USE career_path_analysis;

DROP TABLE IF EXISTS jobs_data;

CREATE TABLE jobs_data (
    work_year INT,
    job_title VARCHAR(100),
    job_category VARCHAR(100),
    salary_currency VARCHAR(10),
    salary FLOAT,
    salary_in_usd FLOAT,
    employee_residence VARCHAR(50),
    experience_level VARCHAR(20),
    employment_type VARCHAR(20),
    work_setting VARCHAR(20),
    company_location VARCHAR(50),
    company_size VARCHAR(10)
);

-- load CSV data into the table
LOAD DATA LOCAL INFILE '/home/makhoe_7/projects/DataAnalysis/Career-Path-Analysis/dataset/Career_Path_Analysis_2023.csv'
INTO TABLE jobs_data
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(work_year, job_title, job_category, salary_currency, salary, salary_in_usd, 
 employee_residence, experience_level, employment_type, work_setting, 
 company_location, company_size);

 -- test query to check data load
SELECT * FROM jobs_data LIMIT 2;

-- Which data roles offer the highest salaries for entry-level positions?
SELECT job_title, AVG(salary_in_usd) AS avg_salary
FROM jobs_data
WHERE experience_level = 'Entry-level'
GROUP BY job_title
ORDER BY avg_salary DESC
LIMIT 5;

-- How do salaries differ between mid-level and senior positions across data roles?
SELECT job_category, experience_level, AVG(salary_in_usd) AS avg_salary
FROM jobs_data
WHERE experience_level IN ('Mid-level', 'Senior')
GROUP BY job_category, experience_level
ORDER BY job_category, experience_level
LIMIT 5;

-- Does working remotely, hybrid, or in-person affect salary?
SELECT work_setting, AVG(salary_in_usd) AS avg_salary, MIN(salary_in_usd) AS min_salary, MAX(salary_in_usd) AS max_salary
FROM jobs_data
GROUP BY work_setting
ORDER BY avg_salary DESC;

-- Which data job categories pay best on average?
SELECT job_category, AVG(salary_in_usd) AS avg_salary
FROM jobs_data
GROUP BY job_category
ORDER BY avg_salary DESC
LIMIT 5;

-- Do larger companies pay more than smaller companies?
SELECT company_size, AVG(salary_in_usd) AS avg_salary
FROM jobs_data
GROUP BY company_size
ORDER BY avg_salary DESC;   

-- Which countries/cities offer highest salaries?
SELECT employee_residence, AVG(salary_in_usd) AS avg_salary
FROM jobs_data
GROUP BY employee_residence
ORDER BY avg_salary DESC
LIMIT 5;

-- How does experience level influence salary growth?
SELECT experience_level, AVG(salary_in_usd) AS avg_salary
FROM jobs_data
GROUP BY experience_level
ORDER BY avg_salary DESC;  

-- Which combination of role, location, and work setting maximizes salary?
SELECT job_category, work_setting, AVG(salary_in_usd) AS avg_salary
FROM jobs_data
GROUP BY job_category, work_setting
ORDER BY job_category, work_setting
LIMIT 5;

-- Roles with fastest salary growth
SELECT job_category, experience_level, AVG(salary_in_usd) AS avg_salary
FROM jobs_data
GROUP BY job_category, experience_level
ORDER BY job_category, 
         CASE experience_level
             WHEN 'Entry-level' THEN 1
             WHEN 'Mid-level' THEN 2
             WHEN 'Senior' THEN 3
             WHEN 'Executive' THEN 4
         END
LIMIT 5;

