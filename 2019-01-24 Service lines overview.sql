select
DB_NAME() AS 'Current Database',
Client.Name ClientBusinessName,
DimValues.[Project Nr.] as 'Projekt Nr.',
DimValues.Kennwort,
DimValues.Produktlinie as 'Produklinie',
Position.Content as 'Position',
ent.[Description] as 'Bemerkung',
isnull(Kistenart.Content,'Kollo') as 'Kistenart',
DimValues.Verpackungsart,
isnull(ent.ColliNumber,colli.Content) as 'Colli Nr.',
ent.code as 'Code',
S.Name as 'Status',
[WEFix].Content as 'Datum WE (fix)',
Packed.Packed 'Datum Verpackung (fix)', 
ent.LotNo as 'Charge',
ent.Length/10 as 'Länge',
ent.Width/10 as 'Breite',
ent.Height/10 as 'Höhe',
ent.Weight as 'Netto kg',
isnull(ent.Brutto,
cast(case when (charindex(',',Brutto.Content)) > 0 then
left(Brutto.Content,(charindex(',',Brutto.Content))-1)+'.'+right(Brutto.Content,len(Brutto.Content)-(charindex(',',Brutto.Content)))
 else Brutto.Content end as float)) as 'Brutto kg',
CV_ANZ.Content as 'Anzahl Markierungen',
Markierung.Content as 'Markierung',
Symbole.content as 'Art der Spezialsymbole',
case st.code when 'Nachträgliche Markierung' then isnull(SL.[Description],Markierung.Content) end as 'Nachträgliche Markierung',
case st.code when 'Nachträgliche Markierung LP' then isnull(SL.[Description],Markierung.Content) end as 'Nachträgliche Markierung LP',
case st.code when 'Sondermarkierung LP' then isnull(SL.[Description],Markierung.Content) end as 'Sondermarkierung LP',
case st.code when 'Sondermarkierung' then isnull(SL.[Description],Markierung.Content) end as 'Sondermarkierung',
case st.code when 'Lackierung' then isnull(SL.[Description],Markierung.Content) end as 'Lackierung',
DimValues.Sonstiges,
DimValues.Markierung,
Dimvalues.Markierungvorschrift as 'Markierungsvorschrift / Sondermarkierung'

from
(SELECT [Id],[Code],[Length],[Width],[Height],[Weight],[LotNo],[SerialNo],[Description],[CreatedById],[UpdatedById],[Created],[Updated],[StatusId],[ActualLocationId],[ActualZoneId],[ActualBinId],[ShipmentHeaderId],[Volume],[NumberSeriesId],[TopHandlingUnitId],[Surface],[BaseArea],[TypeId],[ParentHandlingUnitId],[ColliNumber] ,[PackingRuleType],[PackingRuleDimensionId],[LoadCapacity],[Netto],[Brutto],[Empty],[PackingOrderHeaderId],[NettoCalc],[BruttoCalc],[CapacityCheckDisabled]  FROM HandlingUnit
UNION
SELECT [Id],[Code],[Length],[Width],[Height],[Weight],[LotNo],[SerialNo],[Description],[CreatedById],[UpdatedById],[Created],[Updated],[StatusId],[ActualLocationId],[ActualZoneId],[ActualBinId],[ShipmentHeaderId],[Volume],[NumberSeriesId],[TopHandlingUnitId],[Surface],[BaseArea],null,ActualHandlingUnitId,null,null,null,null,null,null,null,null,null,null,null  FROM LoosePart
)
 ENT

inner join (select EntityId, max(wfe.created) as Packed from WorkflowEntry WFE
inner join [Status] S on WFE.StatusId = S.Id
inner join BusinessUnitPermission BUP on S.id = BUP.StatusId and bup.BusinessUnitId = (select id from BusinessUnit where name = 'Siemens Berlin')
where s.Name in ('lpPacked', 'HuPacked') 
group by EntityId) Packed on ENT.Id = Packed.EntityId

inner join status S on ENT.StatusId = S.Id
inner join (
select BusinessUnitID, isnull(BUP.LoosePartId,BUP.HandlingUnitId) EntityID from BusinessUnitPermission BUP
where isnull(BUP.LoosePartId,BUP.HandlingUnitId) is not null
and BusinessUnitId = ( (select id from BusinessUnit where name = 'Siemens Berlin'))) BU on ent.id = BU.EntityID
inner join BusinessUnit CLIENT on BU.BusinessUnitId = CLIENT.Id and CLIENT.[Type] = 2
--inner join WorkflowEntry WFE on ent.Id = WFE.EntityId and ent.StatusId = WFE.StatusId
left join HandlingUnitType HUT on ent.TypeId = HUT.Id
left join ServiceLine SL on ent.id = SL.EntityId
left join ServiceType ST on SL.ServiceTypeId = ST.Id

left JOIN customfield CF_ANZ on BU.BusinessUnitId  = CF_ANZ.clientbusinessunitid and CF_ANZ.name = 'Anzahl markierung'
LEFT JOIN customvalue CV_ANZ on CV_ANZ.customfieldid = CF_ANZ.Id and CV_ANZ.EntityId = sl.Id
left join CustomValue Markierung on Markierung.EntityId = SL.Id and Markierung.CustomFieldId in (select id from CustomField where name = 'Markierung')
left join CustomValue Symbole on Symbole.EntityId = SL.Id and Symbole.CustomFieldId in (select id from CustomField where name = 'Art der Spezialsymbole')
left join CustomValue Brutto on Brutto.EntityId = ENT.Id and Brutto.CustomFieldId in (select id from CustomField where name = 'Brutto kg')
left join CustomValue Kistenart on Kistenart.EntityId = ENT.Id and Kistenart.CustomFieldId in (select id from CustomField where name = 'Macros')
--left join CustomValue Verpackungsart on Verpackungsart.EntityId = ENT.Id and Verpackungsart.CustomFieldId in (select id from CustomField where name = 'Verpackungsart')
left join CustomValue Position on Position.EntityId = ENT.Id and Position.CustomFieldId in (select id from CustomField where name = 'Position')
left join CustomValue WEFix on WEFix.EntityId = ENT.Id and WEFix.CustomFieldId in (select id from CustomField where name = 'Datum WE (fix)')
left join CustomValue Colli on Colli.EntityId = ENT.Id and Colli.CustomFieldId in (select id from CustomField where name in ('Colli'))
left join CustomValue FeldNr on FeldNr.EntityId = ENT.Id and FeldNr.CustomFieldId in (select id from CustomField where name in ('Feld Nr.'))

left join (select 
edvr.entityid as entityID,
dfv.content as Kennwort,
DFVm.Content as machinentyp,
DFVs.Content as sonstiges,
dfvma.Content as Markierung,
dfvmv.Content as Markierungvorschrift,
dfvpl.Content as Produktlinie,
dfvva.Content as Verpackungsart,
dv.content as 'Project Nr.',
dv.description VDescritpion

from  dbo.EntityDimensionValueRelation EDVR 
inner join dbo.DimensionValue DV on EDVR.DimensionValueId =  DV.Id 
inner join dbo.DimensionField DF on DV.DimensionId = DF.DimensionId and DF.name in  ('Kennwort')
inner join dbo.DimensionFieldValue DFV on DF.Id = DFV.DimensionFieldId and DFV.DimensionValueId = DV.Id 
inner join dbo.DimensionValue DVm on EDVR.DimensionValueId =  DVm.Id 
inner join dbo.DimensionField DFm on DVm.DimensionId = DFm.DimensionId and DFm.name in  ('Maschinen Typ')
inner join dbo.DimensionFieldValue DFVm on DFm.Id = DFVm.DimensionFieldId and DFVm.DimensionValueId = DVm.Id 
inner join dbo.DimensionValue DVs on EDVR.DimensionValueId =  DVs.Id 
inner join dbo.DimensionField DFs on DVs.DimensionId = DFs.DimensionId and DFs.name in  ('Sonstiges')
inner join dbo.DimensionFieldValue DFVs on DFs.Id = DFVs.DimensionFieldId and DFVs.DimensionValueId = DVs.Id
inner join dbo.DimensionValue DVma on EDVR.DimensionValueId =  DVma.Id 
inner join dbo.DimensionField DFma on DVma.DimensionId = DFma.DimensionId and DFma.name in  ('Markierung')
inner join dbo.DimensionFieldValue DFVma on DFma.Id = DFVma.DimensionFieldId and DFVma.DimensionValueId = DVma.Id 
inner join dbo.DimensionValue DVmv on EDVR.DimensionValueId =  DVmv.Id 
inner join dbo.DimensionField DFmv on DVmv.DimensionId = DFmv.DimensionId and DFmv.name in  ('Markierungsvorschrift / Sondermarkierung')
inner join dbo.DimensionFieldValue DFVmv on DFmv.Id = DFVmv.DimensionFieldId and DFVmv.DimensionValueId = DVmv.Id
inner join dbo.DimensionValue DVpl on EDVR.DimensionValueId =  DVpl.Id 
inner join dbo.DimensionField DFpl on DVpl.DimensionId = DFpl.DimensionId and DFpl.name in  ('Produktlinie')
inner join dbo.DimensionFieldValue DFVpl on DFpl.Id = DFVpl.DimensionFieldId and DFVpl.DimensionValueId = DVpl.Id
inner join dbo.DimensionValue DVva on EDVR.DimensionValueId =  DVva.Id 
inner join dbo.DimensionField DFva on DVva.DimensionId = DFva.DimensionId and DFva.name in  ('Verpackungsart')
inner join dbo.DimensionFieldValue DFVva on DFva.Id = DFVva.DimensionFieldId and DFVva.DimensionValueId = DVva.Id           
inner join dbo.Dimension D on DV.DimensionId = D.Id
) DimValues on ent.Id = DimValues.entityID

where 
--((s.name in ('HuPacked')) or (s.name in ('lpPacked') and
((ent.TopHandlingUnitId is null))

and packed.Packed between '2019-01-01' and '2019-01-31'
and ent.code = '35356/88048'
