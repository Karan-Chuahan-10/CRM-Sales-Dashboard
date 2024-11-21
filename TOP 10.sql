select * from [dbo].[Accounts]
select * from [Sales Pipeline] 
select * from [dbo].[Sales Teams]

select * from [dbo].[Products]

select Top (10) *
from ( select Distinct ST.Sales_Agent,sum(Close_Value) as Total_Close_Value,Deal_Stage,Regional_Office
		from [Sales Teams] ST
		inner join [Sales Pipeline] SP on ST.Sales_Agent = SP.Sales_Agent
		where Deal_Stage = 'Won'
		group by ST.Sales_Agent,Deal_Stage,Regional_Office
) as Top_10
order by Total_Close_Value desc;

select Sum(revenue) as Total_Revenue, Year_Established 
from  Accounts
group by Year_Established;

select Distinct Sector, sum(Revenue) as Total_Revenue
from Accounts
group by Sector
order by Total_Revenue desc;

select Sector, sum(Employees) as Total_employees
from (select Distinct Office_Location, Sector, Employees 
		from Accounts) as distinct_LOC
group by Sector
order by Total_employees Desc;

select Sum(Revenue) as Total_Revenue, Product
from [Sales Pipeline] SP
inner join Accounts A on SP.Account = A.Account
group by Product
order by Total_Revenue desc;

select ST.Regional_Office, sum(Revenue)as Total_revenue
from [Sales Teams] ST
inner join [Sales Pipeline] SP on SP.Sales_Agent = ST.Sales_Agent
inner join Accounts A on A.Account = SP.Account
group by ST.Regional_Office
order by Total_revenue desc;

SELECT Count(Product) AS Total_Products, Sales_Agent, Regional_Office 
FROM (
    SELECT DISTINCT Product, SP.Sales_Agent, Regional_Office
    FROM [Sales Pipeline] SP
    INNER JOIN Accounts A ON SP.Account = A.Account
	inner join [Sales Teams] ST on ST.Sales_Agent = SP.Sales_Agent
    WHERE SP.Deal_Stage = 'Won'
) AS Subquery
GROUP BY Sales_Agent, Regional_OFfice 
order by Total_Products desc;

select top (5)Sales_Agent, sum(Revenue) as Total_Revenue
from [Sales Pipeline] SP
inner join Accounts A on SP.Account = A.Account
where Deal_Stage ='Won'
group by Sales_Agent
order by Total_Revenue desc;

select Distinct Sector, avg(Revenue) as Mean_revenue 
from Accounts
group by Sector
order by Mean_revenue desc;

select count(Opportunity_Id)
from [Sales Pipeline];

select Sector, Employees
from Accounts 
where Year_Established = 2017 and Sector = 'Technology';

select Revenue
from Accounts
where Year_Established between 2000 and 2017;

select Top(10) Sp.Sales_Agent, DATEDIFF(day, Sp.Engage_Date,Sp.Close_Date) as Date_Difference
from [Sales Pipeline] Sp
inner join Accounts A on Sp.Account = A.Account
where Sp.Deal_Stage = 'Won' and A.Year_Established between 2000 and 2017
order by Date_Difference desc;

select avg(DATEDIFF(day, Sp.Engage_Date,Sp.Close_Date)) as Date_Difference
from [Sales Pipeline] Sp
inner join Accounts A on Sp.Account = A.Account
where Sp.Deal_Stage = 'Won' and A.Year_Established between 2000 and 2017
order by Date_Difference;

select Sales_Agent, Product, Count(Deal_Stage) as C_Deal
from [Sales Pipeline]
where Account = 'Dambase'
group By Sales_Agent, Product
order by C_Deal Desc;

select distinct Product, 
SUM(Case when Deal_Stage = 'Lost' then  1 else 0 end) as Lost_Count,
SUM(Case when Deal_Stage = 'Won' then  1 else 0 end) as Won_Count
from [Sales Pipeline]
where Deal_Stage in ('Lost','Won')
group by Product;

select Top(1) SP.Sales_Agent, Sum(Revenue) as Total_revenue 
from [Sales Pipeline] SP
inner join Accounts A on SP.Account = A.Account
inner join [Sales Teams] ST on ST.Sales_Agent = SP.Sales_Agent
where Regional_Office in ('West','East','Central')
group by SP.Sales_Agent
order by Total_revenue desc;

WITH RankedSalesAgents AS (
    SELECT 
        SP.Sales_Agent,
        SUM(Revenue) AS Total_revenue,
        ST.Regional_Office,
        ROW_NUMBER() OVER (PARTITION BY ST.Regional_Office ORDER BY SUM(Revenue) DESC) AS AgentRank
    FROM 
        [Sales Pipeline] SP
    INNER JOIN 
        Accounts A ON SP.Account = A.Account
    INNER JOIN 
        [Sales Teams] ST ON ST.Sales_Agent = SP.Sales_Agent
    WHERE 
        ST.Regional_Office IN ('West', 'East', 'Central')
    GROUP BY 
        SP.Sales_Agent, ST.Regional_Office
)
SELECT 
    Sales_Agent,
    Total_revenue,
	Regional_Office
FROM 
    RankedSalesAgents
WHERE 
    AgentRank = 1;
