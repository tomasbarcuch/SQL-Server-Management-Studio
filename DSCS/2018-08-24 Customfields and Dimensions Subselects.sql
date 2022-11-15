   

left join  (
select
[DV].[Content] [CommissionNr],
[DV].[Description] [Commission], 
[D].[Description] [Dimension],
[EDVR].[EntityId],
[DF].[Name], 
[DFV].[Content]
from [DimensionField] [DF] WITH (NOLOCK)
inner join [DimensionFieldValue] [DFV] WITH (NOLOCK) on [DF].[Id] = [DFV].[DimensionFieldId]
inner join [EntityDimensionValueRelation] EDVR on [DFV].[DimensionValueId] = [EDVR].[DimensionValueId]
inner join [DimensionValue] [DV] on [EDVR].[DimensionValueId] = [DV].[Id]
inner join [Dimension] [D] on [DF].DimensionId = [D].[Id] and [D].[Name] = 'Customer'
where 
[DF].[Name] in ('Name 2','Address','City','VAT Registration No_','Post Code','E-Mail','SAP Customer No_','VV Customer No_')) [SRC]
pivot (max([SRC].[Content]) for [SRC].[Name]   in ([Name 2],[Address],[City],[VAT Registration No_],[Post Code],[E-Mail],[SAP Customer No_],[VV Customer No_])) as [CustomerFields] on [HU].[Id] = [CustomerFields].[EntityId]


LEFT JOIN (
SELECT [D].[name], [T].[text]+': '+[DV].[Description]+' ['+DV.Content+']' as [Content], [EDVR].[EntityId] from [DimensionValue] [DV]
INNER JOIN [Dimension] [D] on [DV].[DimensionId] = [D].[id]
INNER JOIN [EntityDimensionValueRelation] [EDVR] on [DV].[Id] = [EDVR].[DimensionValueId]
LEFT JOIN [Translation] [T] on [D].[Id] = [T].[EntityId] and [T].[Language] = 'de' /*$P{Language}*/   and [T].[Column] = 'name'

WHERE [D].[name] in (select [name] from [Dimension] group by [name])
) SRC
PIVOT (max([SRC].[Content]) for [SRC].[Name]  in ([Customer],[Project],[Order],[Commission])
        )  as [D] on [HU].[Id] = [D].[EntityId]



left join  (
select
[DV].[Content] [CommissionNr],
[DV].[Description] [Commission], 
[D].[Description] [Dimension],
[EDVR].[EntityId],
[DF].[Name], 
[DFV].[Content]
from [DimensionField] [DF] WITH (NOLOCK)
inner join [DimensionFieldValue] [DFV] WITH (NOLOCK) on [DF].[Id] = [DFV].[DimensionFieldId]
inner join [EntityDimensionValueRelation] EDVR on [DFV].[DimensionValueId] = [EDVR].[DimensionValueId]
inner join [DimensionValue] [DV] on [EDVR].[DimensionValueId] = [DV].[Id]
inner join [Dimension] [D] on [DF].DimensionId = [D].[Id] and [D].[Name] = 'Commission'
where 
[DF].[Name] in ('FIRST_DELIVERY_DATE','LAST_DELIVERY_DATE')) [SRC]
pivot (max([SRC].[Content]) for [SRC].[Name]   in ([FIRST_DELIVERY_DATE],[LAST_DELIVERY_DATE])) as [CommissionFields] on [HU].[Id] = [CommissionFields].[EntityId]

left join   (
select
[DV].[Content] [OrderNr],
[DV].[Description] [Order], 
[D].[Description] [Dimension],
[EDVR].[EntityId],
[DF].[Name], 
[DFV].[Content]
from [DimensionField] [DF] WITH (NOLOCK)
inner join [DimensionFieldValue]  [DFV] WITH (NOLOCK) on [DF].[Id] = [DFV].[DimensionFieldId]
inner join [EntityDimensionValueRelation] [EDVR] on [DFV].[DimensionValueId] = [EDVR].[DimensionValueId]
inner join [DimensionValue] [DV] on [EDVR].[DimensionValueId] = [DV].[Id]
inner join [Dimension] [D] on [DF].DimensionId = [D].[Id] and [D].[Name] = 'Order'
where 
[DF].[Name] in ('SHIPPING_DATE','CONTACT_PERSON','RESPONSIBLE','VESSEL_NUMBER','NOTE','DUTIABLE_GOODS','PORT_OF_DESTINATION')) [SRC]
pivot (max([SRC].[Content]) for [SRC].[Name]   in ([SHIPPING_DATE],[CONTACT_PERSON],[RESPONSIBLE],[VESSEL_NUMBER],[NOTE],[DUTIABLE_GOODS],[PORT_OF_DESTINATION])) as [OrderFields] on [HU].[Id] = [OrderFields].[EntityId]

left join  (
select
[DV].[Content] [ProjectNr],
[DV].[Description] [Project], 
[D].[Description] [Dimemsion],
[EDVR].[EntityId],
[DF].[Name], 
[DFV].[Content]
from [DimensionField] [DF] WITH (NOLOCK)
inner join [DimensionFieldValue] [DFV] WITH (NOLOCK) on [DF].[Id] = [DFV].[DimensionFieldId]
inner join [EntityDimensionValueRelation] [EDVR] on [DFV].[DimensionValueId] = [EDVR].[DimensionValueId]
inner join [DimensionValue] [DV] on [EDVR].[DimensionValueId] = [DV].[Id]
inner join [Dimension] [D] on [DF].DimensionId = [D].[Id] and [D].[Name] = 'Project'
where 
[DF].[Name] in ('DELIVERY_DATE','NOTE','RESPONSIBLE','MARKING','PACKINGTYPE','COUNTRY')) [SRC]
pivot (max([SRC].[Content]) for [SRC].[Name]   in ([DELIVERY_DATE],[NOTE],[RESPONSIBLE],[MARKING],[PACKINGTYPE],[COUNTRY])) as [ProjectFields] on [HU].[Id] = [ProjectFields].[EntityId]




Select * from (select 
CV.EntityId,
CV.Content,
CF.Name
from CustomValue CV
inner join CustomField CF on CV.CustomFieldId = CF.Id
where CF.name in ('Macros','Protection')) SRC
PIVOT (max(SRC.Content) for SRC.name in ([Macros],[Protection])) as CUS



select Commission.* from (
select
DV.Content CommissionNr,
DV.[Description] Commission, 
D.[Description] Dimension,
EDVR.EntityId,
DF.Name, 
DFV.Content
from DimensionField DF
inner join DimensionFieldValue DFV on Df.id = DFV.DimensionFieldId
inner join EntityDimensionValueRelation EDVR on DFV.DimensionValueId = EDVR.DimensionValueId
inner join DimensionValue DV on EDVR.DimensionValueId = DV.Id
inner join Dimension D on DF.DimensionId = D.id and D.name = 'Commission'
where 
DF.name in ('Plant','Comments','OrderPosition','Network','FIRST_DELIVERY_DATE','LAST_DELIVERY_DATE'))SRC
pivot (max(SRC.Content) for SRC.Name   in ([Plant],[Comments],[OrderPosition],[Network],[FIRST_DELIVERY_DATE],[LAST_DELIVERY_DATE])) as Commission

select ReceiptGoods.* from (
select
DV.Content CommissionNr,
DV.[Description] ReceiptGoods, 
D.[Description] Dimension,
EDVR.EntityId,
DF.Name, 
DFV.Content
from DimensionField DF
inner join DimensionFieldValue DFV on Df.id = DFV.DimensionFieldId
inner join EntityDimensionValueRelation EDVR on DFV.DimensionValueId = EDVR.DimensionValueId
inner join DimensionValue DV on EDVR.DimensionValueId = DV.Id
inner join Dimension D on DF.DimensionId = D.id and D.name = 'ReceiptGoods'
where 
DF.name in ('DELIVERYNOTE','DELIVERY_DATE','DELIVERER','PACKINGTYPE','LENGHT','WEIGHT','WIDTH','DANGEROUS_GOODS_CLASS','HEIGHT','NUMBER_OF_PACKAGES_OK','GOODS_LABELED_AND_SCANNED','NUMBER_OF_PACKAGES_OK_TEXT','DAMAGE','INVOICED','DAMAGE_WHAT','INVOICING_ DATE','DAMAGE_WHY','NOTE'))SRC
pivot (max(SRC.Content) for SRC.Name   in ([DELIVERYNOTE],[DELIVERY_DATE],[DELIVERER],[PACKINGTYPE],[LENGHT],[WEIGHT],[WIDTH],[DANGEROUS_GOODS_CLASS],[HEIGHT],[NUMBER_OF_PACKAGES_OK],[GOODS_LABELED_AND_SCANNED],[NUMBER_OF_PACKAGES_OK_TEXT],[DAMAGE],[INVOICED],[DAMAGE_WHAT],[INVOICING_ DATE],[DAMAGE_WHY],[NOTE])) as ReceiptGoods

select Ord.* from (
select
DV.Content 'OrderNr',
DV.[Description] 'Order', 
D.[Description] Dimension,
EDVR.EntityId,
DF.Name, 
DFV.Content
from DimensionField DF
inner join DimensionFieldValue DFV on Df.id = DFV.DimensionFieldId
inner join EntityDimensionValueRelation EDVR on DFV.DimensionValueId = EDVR.DimensionValueId
inner join DimensionValue DV on EDVR.DimensionValueId = DV.Id
inner join Dimension D on DF.DimensionId = D.id and D.name = 'Order'
where 
DF.name in ('Loading date',
'Termin fix',
'Exeption',
'Arrival_date',
'Ship',
'Order Notes',
'Contact Person',
'Terminal',
'Departure_date',
'Responsible Person',
'Port of Destination',
'Voc-Closing',
'VGM-Closing',
'Shipping_company'
))SRC
pivot (max(SRC.Content) for SRC.Name   in ([Loading date],
[Termin fix],
[Exeption],
[Arrival_date],
[Ship],
[Order Notes],
[Contact Person],
[Terminal],
[Departure_date],
[Responsible Person],
[Port of Destination],
[Voc-Closing],
[VGM-Closing],
[Shipping_company]
)) as Ord

select Project.* from (
select
DV.Content ProjectNr,
DV.[Description] Project, 
D.[Description] Dimemsion,
EDVR.EntityId,
DF.Name, 
DFV.Content
from DimensionField DF
inner join DimensionFieldValue DFV on Df.id = DFV.DimensionFieldId
inner join EntityDimensionValueRelation EDVR on DFV.DimensionValueId = EDVR.DimensionValueId
inner join DimensionValue DV on EDVR.DimensionValueId = DV.Id
inner join Dimension D on DF.DimensionId = D.id and D.name = 'Project'
where 
DF.name in ('GRAddressPostCode','GRAddressContactPerson','GRLanguage','GRAddressName','GRAddressPhoneNo','GRAddressStreet','GRAddressCity','GRAddressCountry','Comments'))SRC
pivot (max(SRC.Content) for SRC.Name   in ([GRAddressPostCode],[GRAddressContactPerson],[GRLanguage],[GRAddressName],[GRAddressPhoneNo],[GRAddressStreet],[GRAddressCity],[GRAddressCountry],[Comments])) as Project

--======================================================================

left join (
SELECT
CustomField.Name as CF_Name, 

CV.Content as CV_Content,
CV.EntityId as EntityID
FROM CustomField 
INNER JOIN CustomValue CV ON (CustomField.Id = CV.CustomFieldId)
where name in (select name from CustomField where ClientBusinessUnitId = (select id from BusinessUnit where name = 'Krones AG') group by name) and CV.Entity = 31
) SRC
PIVOT (max(src.CV_Content) for src.CF_Name  in ([VVID],[Gross],[Spedition],[Comments],[TruckNumber])
        ) as CF on SH.id = CF.EntityID
--======================================================================


--Dimension translated names, descriptions and codes on entity
select * from (
select D.name, T.text+': '+DV.[Description]+' ['+DV.Content+']' as Content, edvr.EntityId from DimensionValue DV 
inner join Dimension D on DV.DimensionId = D.id 
inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
inner join DimensionField DF on D.id = DF.DimensionId
left join Translation T on D.Id = T.EntityId and T.[Language] = 'cs'

where D.name in ('Project','Order','Commission','Order_lines')
) SRC
PIVOT (max(src.Content) for src.Name  in ([Project],[Order],[Commission],[Order_lines])
        ) as Dimensions

Where [EntityId] ='1b5d8eff-76a7-42e2-b7f8-ec7065f7a0fd'

--Dimension names, descriptions and codes on entity 
select * from (select * from (
select D.name, DV.[Description],'['+DV.Content+']' as Content, edvr.EntityId from DimensionValue DV 
left join Dimension D on DV.DimensionId = D.id 
left join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
left join DimensionField DF on D.id = DF.DimensionId


where D.name in ('Project','Order','Commission')
) SRC
PIVOT (max(src.Content) for src.Name  in ([Project],[Order],[Commission])
        ) as Dimensions

Where [EntityId] ='9760e7b0-5b90-4ccd-a96d-02304e30dcd4'


--Easy Dimension codes on entity 
select * from (
select 
D.name, 
Case D.name when 'Project' then DV.Content+' '+isnull(DV.[Description],'.') else DV.Content end as Content, 
--DV.Content+' '+isnull(DV.[Description],'') as content,
--DV.Content, 
edvr.EntityId from DimensionValue DV 
inner join Dimension D on DV.DimensionId = D.id 
inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
where D.name in ('Project','Order','Commission') 
) SRC
PIVOT (max(src.Content) for src.Name  in ([Project],[Order],[Commission])
        ) as Dimensions

        where EntityId = '44f233f6-4820-4156-ad79-0001e2fde5c4'

/*

select * from (select 
CF.ClientBusinessUnitId,
CV.EntityId,
CV.Content 'Kennwort'
from customvalue CV
inner join CustomField CF on CV.CustomFieldId = cf.Id
where CF.name = 'Kennwort'and CF.Entity = 15) KennwortLP


select * from (select 
CF.ClientBusinessUnitId,
CV.EntityId,
CV.Content 'Verpackungsart'
from customvalue CV
inner join CustomField CF on CV.CustomFieldId = cf.Id
where CF.name = 'Verpackungsart'and CF.Entity = 11) VerpackungartHU

select * from (select 
CF.ClientBusinessUnitId,
CV.EntityId,
CV.Content 'Inhalt Deutsch'
from customvalue CV
inner join CustomField CF on CV.CustomFieldId = cf.Id
where CF.name = 'Inhalt Deutsch'and CF.Entity = 11) InhaltDeutschHU


select * from (select 
CF.ClientBusinessUnitId,
CV.EntityId,
CV.Content 'Verpackungsart'
from customvalue CV
inner join CustomField CF on CV.CustomFieldId = cf.Id
where CF.name = 'Verpackungsart'and CF.Entity = 15) VerpackungartLP




select * from (Select
BUP.BusinessUnitId, 
EDVR.entityid,
DFV.Content as 'Kennwort'
from DimensionFieldValue DFV
inner join DimensionField DF on DFV.DimensionFieldId = DF.Id and DF.Name = 'Kennwort'
inner join EntityDimensionValueRelation EDVR on DFV.DimensionValueId = EDVR.DimensionValueId
inner join Dimension D on DF.DimensionId  = D.Id
inner join BusinessUnitPermission BUP on d.id = BUP.DimensionId) KennwortD

select * from (
Select
EDVR.entityid,
DV.Content as 'Code'
from DimensionValue DV
inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
inner join Dimension D on DV.DimensionId  = D.Id
) CodeD


select * from (Select
EDVR.entityid,
DFV.Content as 'GRAddressCountry'
from DimensionFieldValue DFV
inner join DimensionField DF on DFV.DimensionFieldId = DF.Id and DF.Name = 'GRAddressCountry'
inner join EntityDimensionValueRelation EDVR on DFV.DimensionValueId = EDVR.DimensionValueId
inner join Dimension D on DF.DimensionId  = D.Id) GRAddressCountry

select * from customvalue where entityid = '48f6fe1e-306d-435e-8ab8-526d97161eb4'


*/


select * from  (
SELECT
CustomField.Name as CF_Name, 

CV.Content as CV_Content,
CV.EntityId as EntityID
FROM CustomField 
INNER JOIN CustomValue CV ON (CustomField.Id = CV.CustomFieldId)
where name in ('Kennwort','Position','Feld Nr.','Colli','Brutto kg','Lot Nr. (Teillieferung)') and CV.Entity = 15
) SRC
PIVOT (max(src.CV_Content) for src.CF_Name  in ([Kennwort],[Position],[Feld Nr.],[Colli],[Brutto kg],[Lot Nr. (Teillieferung)])
        ) as LPCF-- on LP.id = LPCF.EntityID


select * FROM (
SELECT
[CF].[Name] as [CF_Name], 
ISNULL([T].[text],'')+': '+[CV].[Content] as [CV_Content],
[CV].[EntityId] as [EntityID]
FROM [CustomField] [CF]
INNER JOIN [CustomValue] [CV] ON [CF].[Id] = [CV].[CustomFieldId]
LEFT JOIN [Translation] [T] on [CF].[Id] = [T].[EntityId] and [T].[Language] = 'de'
WHERE [name] in (select [name] from [CustomField] group by [name]) and [CV].[Entity] = 11
) [SRC]
PIVOT (max([SRC].[CV_Content]) for [SRC].[CF_Name]  in ([Description_EN],[OriginCountry],[CustomerNo]) -- add customfield names here
        ) as [CF]-- on HU.id = [CF].[EntityID]

