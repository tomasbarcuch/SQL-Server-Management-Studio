declare @datum as DATE = '2022-01-27'
select * from (
select LogTime,
SUBSTRING(SUBSTRING([Message],CHARINDEX('Exception: ',[Message])+11,CHARINDEX('Aktion ',[Message])),0,CHARINDEX(':',SUBSTRING([Message],CHARINDEX('Exception: ',[Message])+11,CHARINDEX('Aktion ',[Message])))) as Entity,
SUBSTRING([Message],CHARINDEX('Aktion ',[Message]),100) as Message
from Log4Net 
where 
([Message] like '%freigegeben%' or [Message] like '%take action%') and 
--[Message] like '%bereits freigegeben%' and 
Log4Net.LogTime > @datum
--order by LogTime DESC

union

select 
L.Created, 
REPLACE(LEFT(L.ErrorMessage,CHARINDEX(':',L.ErrorMessage)),':',''),
SUBSTRING(L.ErrorMessage,CHARINDEX(':',L.ErrorMessage)+2,200)
from BCSLog L
where 
(L.[ErrorMessage]like '%freigegeben%' or L.[ErrorMessage]like '%take action%')
--L.[ErrorMessage]like '%bereits freigegeben%' 
and cast (L.CREATED as date) > @datum
--order by L.Created desc
) data order by DATA.LogTime desc


declare @entitycode as NVARCHAR(50) = '0006610220331007'


select 'HU',BU.Name, HU.Code from HandlingUnit HU
inner join BusinessUnitPermission BUP on HU.id = BUP.HandlingUnitId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id and BU.Type = 2

where Code = (
  
    @entitycode
)

UNION

select 'LP' Entity,BU.Name Client, LP.Code from LoosePart LP
inner join BusinessUnitPermission BUP on LP.id = BUP.LoosePartId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id and BU.Type = 2

where Code = (
  
  @entitycode
)

UNION

select 'SH',BU.Name,SH.Code from ShipmentHeader SH
inner join BusinessUnitPermission BUP on SH.id = BUP.ShipmentHeaderId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id and BU.Type = 2
where SH.code = (
    @entitycode
)

UNION

select 'PO',BU.Name,PO.Code from PackingOrderHeader PO
inner join BusinessUnitPermission BUP on po.id = BUP.PackingOrderHeaderId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id and BU.Type = 2
where PO.code = (
    @entitycode
)


--KSB-HU0003920: Aktion Verpackung in ist nicht freigegeben im Status HuTeilEingepackt
--001-HU004600: Aktion Verpackung in ist nicht freigegeben im Status HuTeilEingepackt 

--select id from BusinessUnit where name = 'Dieffenbacher GmbH Maschinen- und Anlagenbau'