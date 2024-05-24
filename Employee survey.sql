CREATE DATABASE capstone1;
CREATE TABLE HR_Response_Services(
Response_ID INT PRIMARY KEY,
Status VARCHAR(255) NOT NULL,
Department VARCHAR(255) NOT NULL,
Director INT NOT NULL,
Manager INT NOT NULL,
Supervisor INT NOT NULL,
Staff INT NOT NULL,
Question VARCHAR(255) NOT NULL,
Response INT NOT NULL,
Response_Text VARCHAR(255) NOT NULL
);

-- OVERALL RESPONSE RATE
SELECT
COUNT(Status) /(SELECT COUNT(*) FROM HR_Response_Services) * 100 AS Completion_rate,
COUNT(Status),
Status
FROM HR_Response_Services
GROUP BY Status;

-- RESPONSE COMPLETION RATE BY ROLE
SELECT Status,
SUM(CASE WHEN Director = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100 AS Director,
SUM(CASE WHEN Manager = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100 AS Manager,
SUM(CASE WHEN Supervisor = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100 AS Supervisor,
SUM(CASE WHEN Staff = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100 AS Staff,
SUM(CASE WHEN Director = 0 AND Manager = 0 AND Supervisor = 0 AND Staff = 0 THEN 1 ELSE 0 END) / COUNT(*) * 100 AS Others
FROM HR_Response_Services
GROUP BY Status;

-- OVERALL RESPONSE COUNT
SELECT Question,
SUM(CASE WHEN Response = 0 THEN 1 ELSE 0 END) / COUNT(*) *100 AS NotApp_Percentage,
SUM(CASE WHEN Response = 1 THEN 1 ELSE 0 END) / COUNT(*) *100 AS StronglyDisagree_Percentage,
SUM(CASE WHEN Response = 2 THEN 1 ELSE 0 END) / COUNT(*) *100 AS Disagree_Percentage,
SUM(CASE WHEN Response = 3 THEN 1 ELSE 0 END) / COUNT(*) *100 AS Agree_Percentage,
SUM(CASE WHEN Response = 4 THEN 1 ELSE 0 END) / COUNT(*) *100 AS StronglyAgree_Percentage
FROM HR_Response_Services
WHERE Status = 'Complete'
GROUP BY Question;

-- SURVEY QUESTIONS WHERE RESPONDENTS AGREED OR DISAGREED WITH MOST
WITH Total_response AS (
SELECT Question,
SUM(CASE WHEN Response in (3, 4) THEN 1 ELSE 0 END)/ COUNT(*) * 100 AS Total_Agreed_Percentage,
SUM(CASE WHEN Response in (1, 2) THEN 1 ELSE 0 END)/ COUNT(*) * 100 AS Total_Disagreed_Percentage
FROM HR_Response_Services
WHERE Status = 'Complete'
GROUP BY Question
)
SELECT
(SELECT Question
FROM Total_response
ORDER BY Total_Agreed_Percentage desc LIMIT 1) AS Most_Agreed_Question,
(SELECT Question
FROM Total_response
ORDER BY Total_Disagreed_Percentage desc LIMIT 1) AS Most_Disagreed_Question;

-- TRENDS BY DEPARTMENT OR ROLES
-- BY DEPARTMENT
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

-- BY ROLES
-- Director
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

-- Manager
WITH Manager_survey_results AS (
SELECT Question,
Department,
Manager,
SUM(CASE WHEN Response in (3, 4) THEN 1 ELSE 0 END)/ COUNT(*) * 100 AS Total_Agreed_Percentage,
SUM(CASE WHEN Response in (1, 2) THEN 1 ELSE 0 END)/ COUNT(*) * 100 AS Total_Disagreed_Percentage
FROM HR_Response_Services
WHERE Status = 'Complete'
GROUP BY Question, Manager, Department
)
SELECT
Manager,
(SELECT Question
FROM Manager_survey_results AS agreed
ORDER BY Total_Agreed_Percentage desc LIMIT 1) AS Most_Agreed_Question,
(SELECT Question
FROM Manager_survey_results AS disagreed
ORDER BY Total_Disagreed_Percentage desc LIMIT 1) AS Most_Disagreed_Question
FROM Manager_survey_results AS results
GROUP BY Manager;

-- Supervisor
WITH Supervisor_survey_results AS (
SELECT Question,
Department,
Supervisor,
SUM(CASE WHEN Response in (3, 4) THEN 1 ELSE 0 END)/ COUNT(*) * 100 AS Total_Agreed_Percentage,
SUM(CASE WHEN Response in (1, 2) THEN 1 ELSE 0 END)/ COUNT(*) * 100 AS Total_Disagreed_Percentage
FROM HR_Response_Services
WHERE Status = 'Complete'
GROUP BY Question, Supervisor, Department
)
SELECT
Supervisor,
(SELECT Question
FROM Supervisor_survey_results AS agreed
ORDER BY Total_Agreed_Percentage desc LIMIT 1) AS Most_Agreed_Question,
(SELECT Question
FROM Supervisor_survey_results AS disagreed
ORDER BY Total_Disagreed_Percentage desc LIMIT 1) AS Most_Disagreed_Question
FROM Supervisor_survey_results AS results
GROUP BY Supervisor;

-- staff
WITH Staff_survey_results AS (
SELECT Question,
Department,
Staff,
SUM(CASE WHEN Response in (3, 4) THEN 1 ELSE 0 END)/ COUNT(*) * 100 AS Total_Agreed_Percentage,
SUM(CASE WHEN Response in (1, 2) THEN 1 ELSE 0 END)/ COUNT(*) * 100 AS Total_Disagreed_Percentage
FROM HR_Response_Services
WHERE Status = 'Complete'
GROUP BY Question, Staff, Department
)
SELECT
Staff,
(SELECT Question
FROM Staff_survey_results AS agreed
ORDER BY Total_Agreed_Percentage desc LIMIT 1) AS Most_Agreed_Question,
(SELECT Question
FROM Staff_survey_results AS disagreed
ORDER BY Total_Disagreed_Percentage desc LIMIT 1) AS Most_Disagreed_Question
FROM Staff_survey_results AS results
GROUP BY Staff;


-- OTHERS
WITH Others_survey_results AS (
SELECT Question,
Department,
'Others',
SUM(CASE WHEN Response in (3, 4) THEN 1 ELSE 0 END)/ COUNT(*) * 100 AS Total_Agreed_Percentage,
SUM(CASE WHEN Response in (1, 2) THEN 1 ELSE 0 END)/ COUNT(*) * 100 AS Total_Disagreed_Percentage
FROM HR_Response_Services
WHERE Status = 'Complete'
GROUP BY Question, 'Others', Department
)
SELECT
'Others',
(SELECT Question
FROM Others_survey_results AS agreed
ORDER BY Total_Agreed_Percentage desc LIMIT 1) AS Most_Agreed_Question,
(SELECT Question
FROM Others_survey_results AS disagreed
ORDER BY Total_Disagreed_Percentage desc LIMIT 1) AS Most_Disagreed_Question
FROM Others_survey_results AS results
GROUP BY 'Others';