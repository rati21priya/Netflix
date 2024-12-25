drop table if exists Netflix;
create table Netflix(
show_id varchar(10),
type varchar(20),
title varchar(150),
director varchar(208),
casts varchar(1000),
country  varchar(150),
date_added  varchar(50),
release_year int,
rating varchar(10) ,
duration varchar(15),
listed_in varchar(90),
description varchar(250)
)

select * from Netflix
select  distinct rating from Netflix

select count(*) as total_content from Netflix

/* 1) Count the no of movies vs tv shows */
select type, count(type) from Netflix  
group by type;

/* 2) Most common rating for TV Shows and Movies            -- use subqueries */              
select distinct type, rating , count(*) from Netflix
group by type, rating
order by type,count(*) desc

/* 3) List all the movies released in a particular year */
select * from Netflix 
where release_year = 2020 and type='Movie'

/* 4)Find the top 5 countries with most content on Netflix     --wrong */
select trim(unnest(string_to_array(country,',' ))) as new_country,
count(*) from Netflix
group by new_country
order by count(*) desc
limit  5


/* 5) which is the longest movie*/
select * from Netflix 
where type = 'Movie' 
and duration is not null
order by split_part(duration,' ',1)::int desc
limit 1

/* 6)Find Content Added in the Last 5 Years */
-- select title,date_added from Netflix 
-- where split_part(date_added,',',2)::int >= 5 
select title , date_added from Netflix
where to_date(date_added,'month dd, yyyy') >=current_date - interval '5 years'


/* 7)Find all teh movies or tv shows by director Rajiv Chilaka */
select * from Netflix 
where director Like '%Rajiv Chilaka%'

/* 8)List All TV Shows with More Than 5 Seasons */
select * from Netflix 
where type='TV Show' and split_part(duration,' ',1)::int >5

/* 9)Count the Number of Content Items in Each Genre */
select  trim(unnest(string_to_array(listed_in,','))) as genre, 
count(*) as genre_count from Netflix
group by genre

/* 10)Find each year and the average numbers of content release in India on netflix. */
select country ,release_year,Round(count(show_id):: Numeric /
(select count(distinct release_year) from netflix where country='India'),2) as avg_release
from Netflix 
where country='India'
group by country, release_year
order by avg_release desc
limit 5

/* 11)List All Movies that are Documentaries */
select * from Netflix 
where listed_in like '%Documentaries%'

/* 12)Find All Content Without a Director */
select * from Netflix
where director is null

/* 13)Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years */
select * from Netflix 
where casts like '%Salman Khan%'
and release_year > extract(year from current_date) - 10

/* 14)Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India */
select Trim(unnest(string_to_array(casts,','))) as actors ,count(*)
from Netflix
where country ='India'
group by actors 
order by count(*) desc
limit 10

/* 15)Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords */
 
SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'  
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY category;



/*-----End of Report-----*/