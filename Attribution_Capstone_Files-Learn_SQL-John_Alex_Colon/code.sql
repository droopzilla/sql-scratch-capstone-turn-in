/*
Attribution Queries Capstone Project | Learn SQL from Scratch

John Alex Colón | March 23, 2019

Here is my copy all of my SQL code from the Attribution Queries project
*/

/* 
GET FAMILIAR SECTION
*/

/*
Count of distinct campaigns
*/

SELECT COUNT (DISTINCT utm_campaign)
FROM page_visits; 

/*
COUNT of distinct sources
*/
SELECT COUNT (DISTINCT utm_source)
FROM page_visits; 

/*
How campaign and source are related
*/

SELECT DISTINCT utm_campaign, utm_source
FROM page_visits
ORDER BY 2; 

/*
What pages are on the CTS website
*/

SELECT DISTINCT page_name
FROM page_visits; 

/*
USER JOURNEY SECTION
*/

/*
How many first touches per campaign and source
Modify the first touch query
*/

WITH first_touch AS (
	SELECT user_id,
		   MIN(timestamp) as first_touch_at
	FROM page_visits
	GROUP BY user_id), 
ft_info AS (
	SELECT ft.user_id,
		   ft.first_touch_at,
           pv.utm_source,
	       pv.utm_campaign
	FROM first_touch AS 'ft'
	JOIN page_visits AS 'pv'
		ON ft.user_id = pv.user_id
		AND ft.first_touch_at = pv.timestamp
)
SELECT ft_info.utm_source, 
	   ft_info.utm_campaign, 
	   COUNT(*)
FROM ft_info
GROUP BY 1, 2
ORDER BY 3 DESC;

/*
How many last touches per campaign and source
*/

WITH last_touch AS (
	SELECT user_id,
		   MAX(timestamp) as 'last_touch_at'
	FROM page_visits
	GROUP BY user_id), 
lt_info AS (
	SELECT lt.user_id,
		   lt.last_touch_at,
    	   pv.utm_source,
  	       pv.utm_campaign
	FROM last_touch AS 'lt'
	JOIN page_visits AS 'pv'
		ON lt.user_id = pv.user_id
		AND lt.last_touch_at = pv.timestamp
)
SELECT lt_info.utm_source, 
	   lt_info.utm_campaign, 
       COUNT(*)
FROM lt_info
GROUP BY 1, 2
ORDER BY 3 DESC; 


/*
Count of distinct visitors making a purchase
*/

SELECT COUNT (DISTINCT user_id)
FROM page_visits
	WHERE page_name = '4 - purchase';


/*
Count of last touches on purchase page per campaign
*/

WITH last_touch AS (
	SELECT user_id,
		   MAX(timestamp) as 'last_touch_at'
	FROM page_visits
		WHERE page_name = '4 - purchase'
	GROUP BY user_id), 
lt_info AS (
	SELECT lt.user_id,
		   lt.last_touch_at,
		   pv.utm_source,
		   pv.utm_campaign, 
		   pv.page_name
	FROM last_touch AS 'lt'
	JOIN page_visits AS 'pv'
		ON lt.user_id = pv.user_id
		AND lt.last_touch_at = pv.timestamp
)
SELECT lt_info.utm_source,
	   lt_info.utm_campaign, 
	   COUNT(*)
FROM lt_info
GROUP BY 1, 2
ORDER BY 3 DESC; 