USE SQL_PROJECT1
--PROJECT TITLE: Customer Campaign Response Analysis
--DATABASE: SQL_PROJECT1
-- TABLE: CAMPAIGN

--DATA CLEANING
--Identifying Null Value

SELECT * FROM Campaign
WHERE 
		customer_id is NULL
		OR
		age is NULL
		OR
		gender is NULL
		OR
		annual_income is NULL
		OR
		credit_score is NULL
		OR
		employed is NULL
		OR
		marital_status is NULL
		OR
		no_of_children is NULL
		OR
		responded is NULL;

-- Identify how many rows are recorded
SELECT COUNT (*) FROM Campaign;

--Identify the structure of the table
SELECT TOP 10 * FROM Campaign;

--Create a new column that contains the Age Group (Young, Middle_Aged, and Older_Adult)

ALTER TABLE Campaign
ADD Age_group VARCHAR(50)

UPDATE Campaign
SET Age_group = 
	CASE 
		WHEN age BETWEEN 18 AND 30 THEN 'Young'
		WHEN age BETWEEN 31 AND 45 THEN 'Middle_aged'
		ELSE 'Older_adult'
	END;

--Create a new column that contains the Credit score group (Lower_credit, Middle_credit, and High_credit)

ALTER TABLE Campaign
ADD Credit_score_group VARCHAR (50)

UPDATE Campaign
SET Credit_score_group = 
	CASE 
		WHEN credit_score < 600 THEN 'Low_credit'
		WHEN credit_score BETWEEN 600 AND 699 THEN 'Middle_credit'
		ELSE 'High_credit'
	END;

--Create a new column that contains Income Group (Low Income, Middle Income, and High Income)

ALTER TABLE Campaign
ADD Income_group VARCHAR(50)

UPDATE Campaign
SET Income_group = 
	CASE 
		WHEN annual_income < 50000 THEN 'Low Income'
		WHEN annual_income BETWEEN 50000 AND 90000 THEN 'Middle Income'
		ELSE 'High Income'
	END

--DATA EXPLORATION

--What is the gender distribution of customers?

USE SQL_PROJECT1

SELECT 
    gender,
    COUNT(*) AS total_customers,
    CAST(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Campaign),0) AS FLOAT) AS percentage
FROM Campaign
GROUP BY gender;

--What is the average credit score for those who responded vs those who didn’t?

SELECT 
    responded,
    ROUND(AVG(credit_score), 2) AS avg_credit_score
FROM Campaign
GROUP BY responded;

--What is the average annual income by gender? 

SELECT
	gender,
	ROUND(AVG(annual_income), 2) AS Avg_annual_income
	FROM Campaign
	GROUP BY gender

--Which income group has the highest proportion of “Yes” responses?

SELECT 
    Income_group,
    COUNT(CASE WHEN responded = 'Yes' THEN 1 END) AS yes_count,
    COUNT(*) AS total_customers,
    CAST(ROUND(COUNT(CASE WHEN responded = 'Yes' THEN 1 END) * 100.0 / COUNT(*), 2)AS FLOAT) AS yes_percentage
FROM Campaign
GROUP BY Income_group
ORDER BY yes_percentage DESC;

--Which age group has the highest response rate to the campaign?

SELECT
Age_group,
		COUNT(CASE WHEN responded = 'YES' THEN 1 END) AS yes_count,
		COUNT(*) AS total_customer,
		CAST(ROUND(COUNT( CASE WHEN responded = 'YES' THEN 1 END) * 100.0/ COUNT(*), 2)AS FLOAT)AS yes_percentage
FROM Campaign
	GROUP BY Age_Group
	ORDER BY yes_percentage DESC

--DATA ANALYSIS QUESTIONS
--Q1 How does marital status influence campaign response?
--Q2 Are higher credit scores linked to higher response rates?
--Q3 Do customers with more children tend to respond more or less to campaigns?
--Q4 Which segment (based on gender, age group, income group) has the highest conversion rate?
--Q5 Is there a correlation between employment status and response rate?
--Q6 What factors (income, credit score, marital status, etc.) are most common among customers who responded “Yes”*
--Q7 Are there income groups or age groups where no one responded at all?
--Q8 Based on the patterns, what type of customer is most likely to respond to a future campaign?


--DATA ANALYSIS ANSWERS
--Q1 How does marital status influence campaign response?

SELECT 
    marital_status,
    COUNT(*) AS total_customers,
    COUNT(CASE WHEN responded = 'Yes' THEN 1 END) AS yes_count,
    CAST(ROUND(COUNT(CASE WHEN responded = 'Yes' THEN 1 END) * 100.0 / COUNT(*), 1) AS FLOAT) AS yes_percentage
FROM Campaign
GROUP BY marital_status
ORDER BY yes_percentage DESC;

--Q2 Are higher credit scores linked to higher response rates?

SELECT 
Credit_score_group,
    COUNT(CASE WHEN responded = 'Yes' THEN 1 END) AS yes_count,
	 COUNT(*) AS total_customers,
    CAST(ROUND(COUNT(CASE WHEN responded = 'Yes' THEN 1 END) * 100.0 / COUNT(*), 1) AS FLOAT)AS yes_percentage
FROM Campaign
GROUP BY Credit_score_group
ORDER BY yes_percentage DESC;

--Q3 Do customers with more children tend to respond more or less to campaigns?

SELECT 
    no_of_children,
    COUNT(*) AS total_customers,
    COUNT(CASE WHEN responded = 'Yes' THEN 1 END) AS yes_count,
    CAST(ROUND(COUNT(CASE WHEN responded = 'Yes' THEN 1 END) * 100.0 / COUNT(*), 1) AS FLOAT) AS yes_percentage
FROM Campaign
GROUP BY no_of_children
ORDER BY no_of_children DESC;

--Q4 Which segment (based on gender, age group, income group) has the highest conversion rate?

SELECT 
    gender,
    age_group,
    income_group,
    COUNT(*) AS total_customers,
    COUNT(CASE WHEN responded = 'Yes' THEN 1 END) AS yes_count,
    CAST(ROUND(COUNT(CASE WHEN responded = 'Yes' THEN 1 END) * 100.0 / COUNT(*), 1) AS FLOAT) AS conversion_rate
FROM Campaign
GROUP BY gender, age_group, income_group
ORDER BY conversion_rate DESC;

--Q5 Is there a correlation between employment status and response rate?

SELECT
	employed,
	COUNT(*) AS total_customers,
	COUNT(CASE WHEN Responded = 'Yes' THEN 1 END) AS yes_count,
	CAST(ROUND(COUNT(CASE WHEN Responded = 'Yes' THEN 1 END) * 100.0 / COUNT(*), 1) AS FLOAT) AS yes_percentage
FROM Campaign
GROUP BY employed
ORDER BY yes_percentage DESC;

--Q6 What factors (income, credit score, marital status, etc.) are most common among customers who responded “Yes”*

SELECT 
	income_group,
	credit_score_group,
	marital_status,
	age_group,
	gender,
	COUNT(*) AS yes_count
FROM Campaign
WHERE Responded ='yes'
GROUP BY Income_group, credit_score_group, marital_status, age_group, gender
ORDER BY yes_count DESC;

--Q7 Are there income groups or age groups where no one responded at all?

SELECT 
    income_group,
    age_group,
    COUNT(CASE WHEN responded = 'Yes' THEN 1 END) AS yes_count
FROM Campaign
GROUP BY income_group, age_group
HAVING COUNT(CASE WHEN responded = 'Yes' THEN 1 END) = 0;

--Q8 Based on the patterns, what type of customer is most likely to respond to a future campaign?

SELECT
	TOP 1
    gender,
    age_group,
    income_group,
	credit_score_group
    marital_status,
    employed,
    COUNT(*) AS total_yes
FROM Campaign
WHERE responded = 'Yes'
GROUP BY gender, age_group, income_group, credit_score_group, marital_status, employed
ORDER BY total_yes DESC;


-- KEY INSIGHS / FINDINGS
--1. Marital Status Impact: Marital status significantly influences campaign response rates, with married customers showing higher engagement.
--2. Credit Score Correlation: Higher credit scores are associated with increased response rates.
--3. Effect of Children: Customers with more children are more likely to respond positively to campaigns.
--4. Top-Performing Segments: The highest conversion rates are observed among Male, Middle-Aged, and Middle-Income customers.
--5. Employment Status Influence: Employed customers have a higher likelihood of responding to campaigns.
--6. Common Traits of Respondents: Respondents tend to be Male, Married, Middle-Aged, Middle-Income, and have High Credit Scores.
--7. Non-Responsive Segments: No responses were recorded from the following groups: Low Income & Middle-Aged, Low Income & Young, Middle Income & Young
--8. Ideal Target Profile – The most promising audience for future campaigns is Male, Married, Middle-Aged, Middle-Income, High Credit Score, and Employed.  


--RECOMMENDATIONS
--1. Prioritize High-Value Segments: Focus marketing efforts on Male, Married, Middle-Aged, Middle-Income, High Credit Score, and Employed customers to maximize conversions.
--2. Leverage Credit Score Insights: Create exclusive offers for customers with high credit scores, as they show a greater tendency to respond.
--3. Tailor Campaigns for Parents: Develop family-oriented promotions or loyalty benefits targeting customers with children.
--4. Re-engagement Strategies: Implement special campaigns for Low Income & Young/Middle-Aged and Middle Income & Young groups to improve engagement in underperforming segments.
--5. Employment-Based Targeting: Consider campaigns aligned with the schedules and needs of employed individuals, potentially leveraging workplace partnerships.
--6. Data-Driven Personalization: Use the identified customer traits to personalize messages, offers, and channels for maximum impact.

--END OF PROJECT
