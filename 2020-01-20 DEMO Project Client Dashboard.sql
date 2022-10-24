/*
select
DV.Content,
D.id as did,
DF.id dfid,
S.Name sname, 
S.id statusid, 
DF.name 
from status S
inner join BusinessUnitPermission BUP on S.id = BUP. StatusId and bup.BusinessUnitId = (select id from BusinessUnit where name = 'DEMO Project Client')
inner join DimensionField DF on cast (S.id as varchar(max)) = DF.[Description]
inner join Dimension D on DF.DimensionId = D.Id and d.name = 'Order_lines'
inner join DimensionValue DV on D.id = DV.DimensionId

*/


select 

Ampel.OrderLineCode,
Ampel.OrderDescription,
Ampel.Pending_start_date,
Ampel.Pending_end_date, 
case 
when isnull(ampel.Pending_end_date, getdate()) <= ampel.Pending_start_date then 'green'
when ampel.Pending_end_date > ampel.Pending_start_date then 'yellow'
when isnull(ampel.Pending_end_date, getdate()) > ampel.Pending_start_date then  'red'
else '' end as 'Ampel',
WFE.Created StatusChanged 
from (
select
DV.id,
D.Name level,
DV.Content OrderLineCode,
DV.[Description] OrderDescription,
GEtdate() as currentdt,
DF.name DFname,
S.id as statusid,
DFV.Content 'datetime'
 
from 
Dimension D 
inner join BusinessUnitPermission BUP on D.id = BUP.DimensionId and bup.BusinessUnitId = (select id from BusinessUnit where name = 'DEMO Project Client')
inner join DimensionValue DV on D.Id = DV.DimensionId and d.name = 'Order_lines'
inner join DimensionFieldValue DFV on DV.id = DFV.DimensionValueId
inner join DimensionField DF on DFV.DimensionFieldId = DF.Id
inner join Status S on DF.[Description] = cast (S.id as varchar(max))
where 
DF.name in ('Pending_start_date','Pending_end_date')
--,'ShipmentReady_start_date','ShipmentReady_end_date','InTransit_start_date','InTransit_end_date','PortOfDestination_start_date','PortOfDestination_end_date','StorageArea_start_date','StorageArea_end_date','OnCarriage_start_date','OnCarriage_end_date','Delivered_start_date','Delivered_end_date')
) SRC
pivot (min(SRC.datetime) for SRC.DFname in ( [Pending_end_date],[Pending_start_date])) as Ampel

left join WorkflowEntry WFE on Ampel.statusid = WFE.StatusId and WFE.EntityId = Ampel.Id




select 

Ampel.OrderLineCode,
Ampel.OrderDescription,
Ampel.ShipmentReady_start_date,
Ampel.ShipmentReady_start_date,
case 
when isnull(ampel.ShipmentReady_end_date, getdate()) <= ampel.ShipmentReady_start_date then 'green'
when ampel.ShipmentReady_end_date > ampel.ShipmentReady_start_date then 'yellow'
when isnull(ampel.ShipmentReady_end_date, getdate()) > ampel.ShipmentReady_start_date then  'red'
else '' end as 'Ampel',
WFE.Created StatusChanged 
from (
select
DV.id,
D.Name level,
DV.Content OrderLineCode,
DV.[Description] OrderDescription,
GEtdate() as currentdt,
DF.name DFname,
S.id as statusid,
DFV.Content 'datetime'
 
from 
Dimension D 
inner join BusinessUnitPermission BUP on D.id = BUP.DimensionId and bup.BusinessUnitId = (select id from BusinessUnit where name = 'DEMO Project Client')
inner join DimensionValue DV on D.Id = DV.DimensionId and d.name = 'Order_lines'
inner join DimensionFieldValue DFV on DV.id = DFV.DimensionValueId
inner join DimensionField DF on DFV.DimensionFieldId = DF.Id
inner join Status S on DF.[Description] = cast (S.id as varchar(max))
where 
DF.name in ('ShipmentReady_start_date','ShipmentReady_end_date')
--,'ShipmentReady_start_date','ShipmentReady_end_date','InTransit_start_date','InTransit_end_date','PortOfDestination_start_date','PortOfDestination_end_date','StorageArea_start_date','StorageArea_end_date','OnCarriage_start_date','OnCarriage_end_date','Delivered_start_date','Delivered_end_date')
) SRC
pivot (min(SRC.datetime) for SRC.DFname in ( [ShipmentReady_start_date],[ShipmentReady_end_date])) as Ampel

left join WorkflowEntry WFE on Ampel.statusid = WFE.StatusId and WFE.EntityId = Ampel.Id



select 

Ampel.OrderLineCode,
Ampel.OrderDescription,
Ampel.OnCarriage_start_date,
Ampel.OnCarriage_start_date,
case 
when isnull(ampel.OnCarriage_end_date, getdate()) <= ampel.OnCarriage_start_date then 'green'
when ampel.OnCarriage_end_date > ampel.OnCarriage_start_date then 'yellow'
when isnull(ampel.OnCarriage_end_date, getdate()) > ampel.OnCarriage_start_date then  'red'
else '' end as 'Ampel',
WFE.Created StatusChanged 
from (
select
DV.id,
D.Name level,
DV.Content OrderLineCode,
DV.[Description] OrderDescription,
GEtdate() as currentdt,
DF.name DFname,
S.id as statusid,
DFV.Content 'datetime'
 
from 
Dimension D 
inner join BusinessUnitPermission BUP on D.id = BUP.DimensionId and bup.BusinessUnitId = (select id from BusinessUnit where name = 'DEMO Project Client')
inner join DimensionValue DV on D.Id = DV.DimensionId and d.name = 'Order_lines'
inner join DimensionFieldValue DFV on DV.id = DFV.DimensionValueId
inner join DimensionField DF on DFV.DimensionFieldId = DF.Id
inner join Status S on DF.[Description] = cast (S.id as varchar(max))
where 
DF.name in ('OnCarriage_start_date','OnCarriage_end_date')
--,'ShipmentReady_start_date','ShipmentReady_end_date','InTransit_start_date','InTransit_end_date','PortOfDestination_start_date','PortOfDestination_end_date','StorageArea_start_date','StorageArea_end_date','OnCarriage_start_date','OnCarriage_end_date','Delivered_start_date','Delivered_end_date')
) SRC
pivot (min(SRC.datetime) for SRC.DFname in ( [OnCarriage_start_date],[OnCarriage_end_date])) as Ampel

left join WorkflowEntry WFE on Ampel.statusid = WFE.StatusId and WFE.EntityId = Ampel.Id


