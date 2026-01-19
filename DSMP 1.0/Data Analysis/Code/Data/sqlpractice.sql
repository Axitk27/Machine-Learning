use world;
select Name
from city
where Population > 1000000;

select Name
from country
where IndepYear > 1945;

`PRIMARY`select Code, count(*)
from city C, country CC
where CountryCode = code
group by code;

select Code, count(*)
from city C, country CC
where CountryCode = code
    and C.Population > 1000000
group by code;

select CC.Name
from city C, country CC
where CountryCode = code
group by CC.Name
having max(C.Population) < 1000000;

#this should be equivalent to previous but it's not because:
#there are 7 countries (Antartica, some colonies) that have no cities.
#which answer is correct?
select distinct Name
from country
where code NOT IN (Select CountryCode
                   from city
				    where Population >= 1000000);
                    
select Name
from country where SurfaceArea = (select max(SurfaceArea) from country);
                    
select GovernmentForm, count(*)
from country
group by GovernmentForm;

select GovernmentForm
from country
order by GNP desc
limit 5; 

select GovernmentForm
from country
order by GNP asc
limit 5; 

select avgbefore,avgafter
from (select avg(LifeExpectancy) as avgbefore 
      from country
      where IndepYear < 1945) as T1,
      (select avg(LifeExpectancy) as avgafter
      from country
      where IndepYear >= 1945) as T2;
#another answer for previous question. Note that using avg with CASE won't work!
select sum(CASE WHEN IndepYear < 1945 THEN LifeExpectancy ELSE 0 END) / 
		sum(CASE WHEN IndepYear < 1945 THEN 1 ELSE 0 END) as avgbefore,
       sum(CASE WHEN IndepYear >= 1945 THEN LifeExpectancy ELSE 0 END) /
       sum(CASE WHEN IndepYear >= 1945 THEN 1 ELSE 0 END) as avgafter
from country;
#this hack will avoid the problem:
select avg(CASE WHEN IndepYear < 1945 THEN LifeExpectancy ELSE NULL END) as avgbefore,
       avg(CASE WHEN IndepYear >= 1945 THEN LifeExpectancy ELSE NULL END) as avgafter
from country;

