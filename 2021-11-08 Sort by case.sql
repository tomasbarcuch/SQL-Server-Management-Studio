declare @sort as BIT = 1
declare @sort1 as BIT = 1

select TOP(100)* from LoosePart 
where Length > 0 
order by 
case when @sort1 = 1 then Length END,
case when @sort = 1 then code END
