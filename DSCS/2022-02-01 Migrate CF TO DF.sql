/*
begin TRANSACTION
UPDATE LoosePart set Netto = Weight
 
from LoosePart LP
inner join BusinessUnitPermission BUP on LP.id = BUP.LoosePartId and BUP.BusinessUnitId = (select id from BusinessUnit where name = 'Siemens Berlin')
inner join CustomValue CV on LP.Id = CV.EntityId and CV.CustomFieldId = (Select id from CustomField where name = 'Brutto kg')

ROLLBACK

begin TRANSACTION

UPDATE LoosePart set Weight = 
cast(case when (charindex(',',CV.Content)) > 0 then left(CV.Content,(charindex(',',CV.Content))-1)+'.'+right(CV.Content,len(CV.Content)-(charindex(',',CV.Content))) else CV.Content end as decimal(18,5))
from LoosePart LP
inner join BusinessUnitPermission BUP on LP.id = BUP.LoosePartId and BUP.BusinessUnitId = (select id from BusinessUnit where name = 'Siemens Berlin')
inner join CustomValue CV on LP.Id = CV.EntityId and CV.CustomFieldId = (Select id from CustomField where name = 'Brutto kg') and CV.content <> '0'
ROLLBACK
*/


BEGIN TRANSACTION

DECLARE @CUSTOMFIELDID as VARCHAR(250)
DECLARE @CUSTOMFIELDNAME as VARCHAR(250)
DECLARE @STANDARDFIELDNAME as VARCHAR(250)
DECLARE @CLIENT as VARCHAR (250)
DECLARE @CLIENTNAME as VARCHAR (250)
DECLARE @ENTITY as TINYINT = 35 --[11,15,31,35] 
DECLARE @TABLE as VARCHAR(250)
DECLARE @DATATYPE as UNIQUEIDENTIFIER
DECLARE @LEN as VARCHAR(3)
DECLARE @stmt nvarchar(max)

DECLARE CUSTOM_FIELD CURSOR FOR 

SELECT DATA.ID,DATA.CF, DATA.ClientBusinessUnitId, DATA.SF,DATA.[Table], 
CASE DATA.SF 
when 'Carrier' then 100
when 'Macros' then 100
when 'ReleaseProduction' then 100
when 'Article' then 100
when 'BXNLErrorMsg' then 250
when 'Note' then 250
when 'VesselNumber' then 10
ELSE 50
end as 'LEN'
,DATA.Client
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
--when 'Brutto kg15Number' then 'Weight'
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
--order by  CF.Entity, CF.Name

) DATA WHERE DATA.SF IS NOT null 
--and  DATA.Client not in ('SMS Group','KRONES GLOBAL','Siemens Berlin', 'Siemens Nürnberg','Siempelkamp Maschinen- und Anlagenbau GmbH') 
--and  DATA.Client in ('Acargo GmbH') 
and DATA.Entity = @ENTITY

OPEN CUSTOM_FIELD;
FETCH NEXT FROM CUSTOM_FIELD INTO @CUSTOMFIELDID,@CUSTOMFIELDNAME,@CLIENT,@STANDARDFIELDNAME,@TABLE,@LEN,@CLIENTNAME;
WHILE @@FETCH_STATUS = 0  
BEGIN

select @stmt = 
'
PRINT ''=== UPDATE STANDARD FIELD: ['+@STANDARDFIELDNAME+'] FROM ['+@CUSTOMFIELDNAME+'] IN CLIENT: ['+@CLIENTNAME+'] ==='';
update '+@TABLE+' set '+@STANDARDFIELDNAME+' = LEFT(CV.Content,'+@LEN+')
from CustomField CF 
inner join CustomValue CV on CF.id = CV.CustomFieldId and lEN(CV.Content)>0
inner join '+@TABLE+' ENT on CV.EntityId = ENT.id
where CF.ID = ('''+@CUSTOMFIELDID+''') and CF.Visible = 1
PRINT ''=== SET CUSTOM FIELD: ['+@CUSTOMFIELDNAME+'] AS INVISIBLE IN CLIENT: ['+@CLIENTNAME+'] ==='';
update CustomField set Visible = 0 from CustomField where id = ('''+@CUSTOMFIELDID+''') and Visible = 1

'
exec sp_executesql  @stmt = @stmt




FETCH NEXT FROM CUSTOM_FIELD INTO @CUSTOMFIELDID,@CUSTOMFIELDNAME,@CLIENT,@STANDARDFIELDNAME,@TABLE,@LEN,@CLIENTNAME;
END;
CLOSE CUSTOM_FIELD;
DEALLOCATE CUSTOM_FIELD;



ROLLBACK


/*
DECLARE @CUSTOMFIELDID as VARCHAR(250)
DECLARE @CUSTOMFIELDNAME as VARCHAR(250)
DECLARE @CLIENT as VARCHAR (250)

BEGIN TRANSACTION

DECLARE CUSTOM_FIELD CURSOR FOR 
select 

CF.id, CF.Name, BU.Name from DFCZ_OSLET_2.dbo.customfield CF with (NOLOCK) 
inner join BusinessUnit BU with (NOLOCK) on CF.ClientBusinessUnitId = BU.id and BU.[Type] = 2 

where CF.visible = 0
group by CF.id,CF.Name, BU.Name order by BU.NAME, CF.Name

OPEN CUSTOM_FIELD;
FETCH NEXT FROM CUSTOM_FIELD INTO @CUSTOMFIELDID,@CUSTOMFIELDNAME,@CLIENT;
WHILE @@FETCH_STATUS = 0  
    BEGIN 

PRINT '=== DELETE CUSTOM FIELD VALUE MAPPING: ['+@CUSTOMFIELDNAME+'] IN CLIENT: ['+@CLIENT+'] ===';
delete from CustomFieldValueMapping where CustomFieldId = @CUSTOMFIELDID 
PRINT '=== DELETE CUSTOM VALUES FROM FIELD: ['+@CUSTOMFIELDNAME+'] IN CLIENT: ['+@CLIENT+'] ===';
delete from CustomFieldValue where CustomFieldId = @CUSTOMFIELDID
PRINT '=== DELETE CUSTOM FIELD: ['+@CUSTOMFIELDNAME+'] IN CLIENT: ['+@CLIENT+'] ===';
delete from CustomField where Id = @CUSTOMFIELDID

FETCH NEXT FROM CUSTOM_FIELD INTO @CUSTOMFIELDID,@CUSTOMFIELDNAME,@CLIENT;
END;
CLOSE CUSTOM_FIELD;
DEALLOCATE CUSTOM_FIELD;

ROLLBACK

*/