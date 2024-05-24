# Employee Survey Analysis

# Table of Contents
- [Project Overview](#project-overview)
- [Data Source](#data-source)
- [Tools](#tools)
- [Data Cleaning](#data-cleaning)
- [Data Analysis](#data-analysis)
- [Findings](#findings)
- [Recommendations](#recommendations)

## Project Overview
This analysis was carried out using the data collected from surveys to gain insights into employee satisifaction, workplace relationship and other aspects of the workplace. By analyzing various aspect of the data using MySQL and PowerBI, we tend to draw conclusions for improving employee experience and organizational performance.

## Data Source
The database was provided by Digitaley drive as a part of my capstone project. It consists of one table with 14,788 rows and 10 columns.

## Tools
- SQL Server - This was used to transform and analyze survey data thereby providing insights on employee feedbacks on various aspects, overall engagement level and so on to make informed decisions for enhancing the employee experience and performance.
- PowerBI - This was utilized to visualize survey data effectively through an interactive dashboard and visualization, to provide a comprehensive view of the data.

## Data Cleaning
The data cleaning process invloved removing duplicate entries, handling missing values nd correcting inconsistencies in the data to ensure its accuracy.
- Data loading and inspection.
- Removed duplicate rows.
- Respondents with missing roles were replaced with 'Others' as their role.

## Data Analysis
During this process, SQL was used to evaluate insights from the employee survey dataset.
One of the technique used was the Common Table Expression (CTE) which is a temporary result set that helps in simplifying complex queries. It was used to find out trends by department
```sql
WITH Dept_responses AS (
SELECT Question,
Department,
SUM(CASE WHEN Response in (3, 4) THEN 1 ELSE 0 END)/ COUNT(*) * 100 AS Total_Agreed_Percentage,
SUM(CASE WHEN Response in (1, 2) THEN 1 ELSE 0 END)/ COUNT(*) * 100 AS Total_Disagreed_Percentage
FROM HR_Response_Services
WHERE Status = 'Complete'
GROUP BY Question, Department
)
SELECT
Department,
(SELECT Question
FROM Dept_responses AS dr
WHERE dr.Department = drr.Department
ORDER BY Total_Agreed_Percentage desc LIMIT 1) AS Most_Agreed_Question,
(SELECT Question
FROM Dept_responses AS dr
WHERE dr.Department = drr.Department
ORDER BY Total_Disagreed_Percentage desc LIMIT 1) AS Most_Disagreed_Question
FROM Dept_responses AS drr
GROUP BY Department;
```

  CTE was also employed to find out trend by roles. For instance, for the role of Director, the query was written as stated below
```sql
WITH Director_survey_results AS (
SELECT Question,
Director,
Department,
SUM(CASE WHEN Response in (3, 4) THEN 1 ELSE 0 END)/ COUNT(*) * 100 AS Total_Agreed_Percentage,
SUM(CASE WHEN Response in (1, 2) THEN 1 ELSE 0 END)/ COUNT(*) * 100 AS Total_Disagreed_Percentage
FROM HR_Response_Services
WHERE Status = 'Complete' AND Director = 1
GROUP BY Question, Director, Department
)
SELECT
Director,
(SELECT Question
FROM Director_survey_results AS agreed
ORDER BY Total_Agreed_Percentage desc LIMIT 1) AS Most_Agreed_Question,
(SELECT Question
FROM Director_survey_results AS disagreed
ORDER BY Total_Disagreed_Percentage desc LIMIT 1) AS Most_Disagreed_Question
FROM Director_survey_results AS results
GROUP BY Director;
```

## Findings
- The most agreed question and answer by the employees during the survey are I know what is expected of me at work and i have a best friend at work respectively.
- The employees without roles ie 'Others' had the highest percentage of response.
- 100% of 14,575 reapondents completed the survey.
- The survey was carried out in 21 departments.

## Recommendations
  - 'I know what is expected of me at work' which was the most agreed answer shows the employees have a clear understanding of their job responsibilites and performance expectations. It should be highly encouraged so as to ensure a continuous increased productivity and a positive work environment.
  - On the other hand, since 'i have a best friend at work' is the most disagreed question, we should enlighten the employees on the merits of team building activities and creating opportunities for employees to connect on a personal level to improve collaboration and overall job satisifaction.
  - Continuous assessment and enhancement.




















