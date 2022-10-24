BEGIN TRANSACTION

DECLARE @CUSTOMFIELDID as VARCHAR(250)
DECLARE @CUSTOMFIELDNAME as VARCHAR(250)
DECLARE @STANDARDFIELDNAME as VARCHAR(250)
DECLARE @CLIENT as VARCHAR (250)
DECLARE @ENTITY as TINYINT = 11
DECLARE @TABLE as VARCHAR(250)
DECLARE @DATATYPE as UNIQUEIDENTIFIER
DECLARE @LEN as INT
DECLARE @stmt nvarchar(max)

SELECT DATA.ID,DATA.CF, DATA.Client, DATA.SF,DATA.[Table], 
CAST(CASE DATA.SF 
when 'Carrier' then 100
when 'Macros' then 100
when 'ReleaseProduction' then 100
when 'Article' then 100
when 'BXNLErrorMsg' then 250
when 'Note' then 250
when 'VesselNumber' then 10
ELSE 50
end as INT) as 'LEN'

 from (
select CF.Id,CF.ClientBusinessUnitId,CF.name CF,DT.Name Datatype, BU.Name Client,CF.Entity, 
case CF.Entity 
when 11 then 'HandlingUnit'  
when 15 then 'LoosePart'
when 31 then 'ShipmentHeader'
when 35 then 'PackingOrderHeader'
end as 'Table',
CASE CF.Name+CAST(Entity as VARCHAR)+DT.Name
when 'Container No.11Text' then 'ContainerNumber'
when 'ContainerN11Text' then 'ContainerNumber'
when 'Dangerous goods11Boolean' then 'DangerousGoods'
when 'Dangerousgoods11Boolean' then 'DangerousGoods'
when 'HuInbound Date11Date' then 'InboundDate'
when 'HuInbound No11Text' then 'InboundCode'
when 'Macros11Text' then 'Macros'
when 'Protection11Text' then 'Protection'
when 'ReleaseProduction11Text' then 'ReleaseProduction'
when 'Seal No.11Text' then 'SealNumber'
when 'Siegel Nr.11Text' then 'SealNumber'
when 'USSealNo11Text' then 'SealNumber'
when 'Article15Text' then 'Article'
when 'Artikel Nummer15Text' then 'Article'
when 'Brutto kg15Number' then 'Weight'
when 'Damage15Boolean' then 'Damaged'
when 'DAMAGED15Boolean' then 'Damaged'
when 'Dangerousgoods15Boolean' then 'DangerousGoods'
when 'Dangerous goods15Boolean' then 'DangerousGoods'
when 'Datum WE (fix)15Date' then 'InboundDate'
when 'Delivery15Text' then 'InboundCode'
when 'Delivery15Number' then 'InboundCode'
when 'DeliveryN15Text' then 'InboundCode'
when 'Entry Date15Date' then 'InboundDate'
when 'Ext.Mat.Nr.15Text' then 'Article'
when 'Gefahrgut15Boolean' then 'DangerousGoods'
when 'ITEM15Text' then 'Article'
when 'LpInbound Date15Date' then 'InboundDate'
when 'LpInbound No15Text' then 'InboundCode'
when 'Manufactory Code15Text' then 'Article'
when 'Material description15Text' then 'Article'
when 'Material n.15Text' then 'Article'
when 'MaterialNo15Text' then 'Article'
when 'MATERIAL_TYPE' then 'Article'
when 'Netto15Number' then 'Netto'
when 'NetWeight15Number' then 'Netto'
when 'Carrier31Text' then 'Carrier'
when 'Container number31Text' then 'ContainerNumber'
when 'Deliverer31Text' then 'TruckNumber'
when 'Seal number31Text' then 'SealNumber'
when 'Ship31Text' then 'VesselNumber'
when 'Spedition31Text' then 'Carrier'
when 'USSealNo31Text' then 'SealNumber'
when 'Vessel31Text' then 'VesselNumber'
when 'Bemerkung35Text' then 'Note'
when 'Bemerkung 35Text' then 'Note'
when 'BXNLErrorMsg35Text' then 'BXNLErrorMsg'
 end as SF
from customfield CF
inner join BusinessUnit Bu on CF.ClientBusinessUnitId = BU.Id and BU.[Disabled] = 0
inner join DataType DT on CF.DataTypeId = DT.Id
where CF.Entity in (11,15,31,35) and CF.Visible = 1
group by CF.Id,CF.name,DT.Name, BU.Name,CF.Entity, CF.ClientBusinessUnitId


) DATA WHERE DATA.SF IS NOT null 

--AND  DATA.Client not in ('SMS Group','KRONES GLOBAL','Siemens Berlin', 'Siemens Nürnberg','Siempelkamp Maschinen- und Anlagenbau GmbH') 

order by DATA.Client, DATA.Entity, DATA.CF

ROLLBACK