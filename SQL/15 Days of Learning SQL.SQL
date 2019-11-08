/*
    Author: L. Ruijter
    Date: 08-11-2019
    
    Link:
    https://www.hackerrank.com/challenges/15-days-of-learning-sql/problem
    
    PROBLEM:
    Julia conducted a  days of learning SQL contest. 
    The start date of the contest was March 01, 2016 and the end date was March 15, 2016.
    Write a query to print total number of unique hackers who made at least 
    submission each day (starting on the first day of the contest), and find the hacker_id and 
    name of the hacker who made maximum number of submissions each day. If more than one such hacker has a 
    maximum number of submissions, print the lowest hacker_id. The query should print this information 
    for each day of the contest, sorted by the date.
*/
with cte as (
			select hacker_id
				  ,submission_date
				  ,count(1) Submissions
			from submissions s
			where exists(
						 select top 1 1 
						 from submissions s2 
						 where s2.hacker_id = s.hacker_id 
						   and s2.submission_date = '2016-03-01' 
						)
			group by hacker_id
					,submission_date 
			) -- Find all Hackers that started atleats at the first day with their total submissions per day.
,cte2 as (
			select  *
				   ,case when 
				  ( select count(1) as aantal 
					from cte x
					where x.hacker_id = cte.hacker_id
					  and x.submission_date <= cte.submission_date -- Count the previous days they have made submissions. 
				   ) 
					= datediff(day,'2016-03-01',submission_date) + 1   -- If previous days equal the submission date - the first date 
					then 1											   -- You are sure they made a entries on all passing days.
					else 0
					end Consecutive
			from cte 
			)
,cte3 as (
		select submission_date 
			   ,sum(Consecutive) as UniqueHackers
		from cte2 
		group by submission_date
		)
select  cte3.*
       ,h.hacker_id
       ,h.name
from cte3
outer apply (
			 select top 1 
                    hacker_id
                    ,count(1) Submissions
             from submissions s 
             where s.submission_date = cte3.submission_date 
             group by hacker_id
             order by 2 desc, 1 asc
			) ab --Fetch the top submisions for x date ordered by lowest hacker Id
left join hackers h on h.hacker_id = ab.hacker_id
order by 1 asc 
