
Author: L. Ruijter
Date: 10-11-2019

LINK:
https://www.hackerrank.com/challenges/print-prime-numbers/problem

PROBLEM:
Write a query to print all prime numbers less than or equal to .
Print your result on a single line, and use the ampersand () character as your separator (instead of a space).
For example, the output for all prime numbers  would be:


/*
Enter your query here.
Please append a semicolon ";" at the end of the query and enter your query in a single line to avoid error.
*/ 
declare @string varchar(4000)

;with cte as ( 
              select 1 as number
              
              union all
              
              select number + 1 
              from cte
              where number <= 1000
            )
,cte2 as (
        select a.number
              ,case when a.number % b.number = 0 then 1 else 0 end as Prime --Check if its possible to divide fully
        from cte a 
        cross join cte b
        where a.number > 1 -- Remove the 1 from the list since its falls positive
         and b.number > 1  -- Dont uses as divider.
         and b.number <= a.number --Performance filter no need to check anything higher.
      )
select @string = coalesce(@string + '&','') + cast(number as varchar(5)) --SINCE WE DONT USE FOR XML
from cte2 
group by number
having sum(Prime) = 1 --If we only managed to divide it fully once we know its a prime number.
option (maxrecursion  0)

select @string
            
