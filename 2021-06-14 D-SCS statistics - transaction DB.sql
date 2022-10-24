select sum(count) actions, created from (
select count(ID) count,cast(Created as date) created  from WorkflowEntry with (NOLOCK)  
group by cast(Created as date) 
UNION
select count(ID),cast(Created as date) created from WarehouseEntry  with (NOLOCK)  
group by cast(Created as date)
UNION 
select count(ID),cast(Created as date) created from LoosePart with (NOLOCK)   
group by cast(Created as date) 
UNION 
select count(ID),cast(Created as date) created from HandlingUnit with (NOLOCK) 
group by cast(Created as date)
UNION 
select count(ID),cast(Created as date) created from ShipmentHeader with (NOLOCK) 
group by cast(Created as date)
UNION 
select count(ID),cast(Created as date) created from ShipmentLine with (NOLOCK) 
group by cast(Created as date) 
UNION 
select count(ID),cast(Created as date) created from PackingOrderHeader with (NOLOCK) 
group by cast(Created as date) 
UNION 
select count(ID),cast(Created as date) created from PackingOrderLine with (NOLOCK) 
group by cast(Created as date) 
UNION 
select count(ID),cast(Created as date) created from ServiceLine with (NOLOCK) 
group by cast(Created as date) 
UNION 
select count(ID),cast(Created as date) created from DimensionValue with (NOLOCK) 
group by cast(Created as date) 
UNION 
select count(ID),cast(Created as date) created from Comment with (NOLOCK) 
group by cast(Created as date) 
UNION 
select count(ID),cast(Created as date) created from Component with (NOLOCK) 
group by cast(Created as date)
UNION 
select count(ID),cast(Created as date) created from CustomFieldValueMapping with (NOLOCK) 
group by cast(Created as date)
UNION 
select count(ID),cast(Created as date) created from BCSLog with (NOLOCK) 
group by cast(Created as date)  

) DATA
group by created
order by DATA.Created desc





select sum(count) actions, created from (
select count(ID) count, Cast(YEAR(Created) as varchar)+'-'+cast(format(datepart(wk,Created),'0#')as varchar) created  from WorkflowEntry with (NOLOCK)   
group by Cast(YEAR(Created) as varchar)+'-'+cast(format(datepart(wk,Created),'0#') as varchar) 
UNION
select count(ID),Cast(YEAR(Created) as varchar)+'-'+cast(format(datepart(wk,Created),'0#')as varchar) created from WarehouseEntry with (NOLOCK)   
group by Cast(YEAR(Created) as varchar)+'-'+cast(format(datepart(wk,Created),'0#')as varchar)
UNION 
select count(ID),Cast(YEAR(Created) as varchar)+'-'+cast(format(datepart(wk,Created),'0#')as varchar) created from LoosePart with (NOLOCK)   
group by Cast(YEAR(Created) as varchar)+'-'+cast(format(datepart(wk,Created),'0#')as varchar)
UNION 
select count(ID),Cast(YEAR(Created) as varchar)+'-'+cast(format(datepart(wk,Created),'0#')as varchar) created from HandlingUnit with (NOLOCK) 
group by Cast(YEAR(Created) as varchar)+'-'+cast(format(datepart(wk,Created),'0#')as varchar)
UNION 
select count(ID),Cast(YEAR(Created) as varchar)+'-'+cast(format(datepart(wk,Created),'0#')as varchar) created from ShipmentHeader with (NOLOCK) 
group by Cast(YEAR(Created) as varchar)+'-'+cast(format(datepart(wk,Created),'0#')as varchar)
UNION 
select count(ID),Cast(YEAR(Created) as varchar)+'-'+cast(format(datepart(wk,Created),'0#')as varchar) created from ShipmentLine with (NOLOCK) 
group by Cast(YEAR(Created) as varchar)+'-'+cast(format(datepart(wk,Created),'0#')as varchar)
UNION 
select count(ID),Cast(YEAR(Created) as varchar)+'-'+cast(format(datepart(wk,Created),'0#')as varchar) created from PackingOrderHeader with (NOLOCK) 
group by Cast(YEAR(Created) as varchar)+'-'+cast(format(datepart(wk,Created),'0#')as varchar) 
UNION 
select count(ID),Cast(YEAR(Created) as varchar)+'-'+cast(format(datepart(wk,Created),'0#')as varchar) created from PackingOrderLine with (NOLOCK) 
group by Cast(YEAR(Created) as varchar)+'-'+cast(format(datepart(wk,Created),'0#')as varchar)
UNION 
select count(ID),Cast(YEAR(Created) as varchar)+'-'+cast(format(datepart(wk,Created),'0#')as varchar) created from ServiceLine with (NOLOCK) 
group by Cast(YEAR(Created) as varchar)+'-'+cast(format(datepart(wk,Created),'0#')as varchar) 
UNION 
select count(ID),Cast(YEAR(Created) as varchar)+'-'+cast(format(datepart(wk,Created),'0#')as varchar) created from DimensionValue with (NOLOCK) 
group by Cast(YEAR(Created) as varchar)+'-'+cast(format(datepart(wk,Created),'0#')as varchar) 
UNION 
select count(ID),Cast(YEAR(Created) as varchar)+'-'+cast(format(datepart(wk,Created),'0#')as varchar) created from Comment with (NOLOCK) 
group by Cast(YEAR(Created) as varchar)+'-'+cast(format(datepart(wk,Created),'0#')as varchar)
UNION 
select count(ID),Cast(YEAR(Created) as varchar)+'-'+cast(format(datepart(wk,Created),'0#')as varchar) created from Component with (NOLOCK) 
group by Cast(YEAR(Created) as varchar)+'-'+cast(format(datepart(wk,Created),'0#')as varchar)
UNION 
select count(ID),Cast(YEAR(Created) as varchar)+'-'+cast(format(datepart(wk,Created),'0#')as varchar) created from CustomFieldValueMapping with (NOLOCK) 
group by Cast(YEAR(Created) as varchar)+'-'+cast(format(datepart(wk,Created),'0#')as varchar)
UNION 
select count(ID),Cast(YEAR(Created) as varchar)+'-'+cast(format(datepart(wk,Created),'0#')as varchar) created from BCSLog  with (NOLOCK) 
group by Cast(YEAR(Created) as varchar)+'-'+cast(format(datepart(wk,Created),'0#')as varchar)

) DATA
group by created
having Data.created > '2020-53'
order by DATA.Created desc

