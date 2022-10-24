
Select 
BU.Name,BU.BXNLClientCode, 
CV.Content as REASON,
SUM(HU.Brutto) as Brutto,
SUM(HU.Netto) as Netto,
SUM(HU.Weight) as Tara,
SUM(HU.Surface) as Surface,
CAST(Year(DATA.Created) as VARCHAR(4))+'-'+CAST(Month(DATA.Created) as VARCHAR(2)) as Interval from (
select WFE.ID, WFE.EntityId, MIN(UPDATED) over (PARTITION by EntityId) as Created from WorkflowEntry WFE
where WFE.Entity = 11
) DATA 
inner join WorkflowEntry WFE on DATA.id = WFE.Id
inner join BusinessUnit  BU on WFE.BusinessUnitId = BU.Id and BU.[Disabled] = 0
inner join CustomValue CV on BU.id = CV.EntityId
inner join CustomField CF on CV.CustomFieldId = CF.Id and CF.Name = 'REASON' 
inner join HandlingUnit HU on DATA.EntityId = HU.id
where CV.Content = 'PRODUCTION'
group by BU.Name,BU.BXNLClientCode, CAST(Year(DATA.Created) as VARCHAR(4))+'-'+CAST(Month(DATA.Created) as VARCHAR(2)),CV.Content

Order by BU.Name,CAST(Year(DATA.Created) as VARCHAR(4))+'-'+CAST(Month(DATA.Created) as VARCHAR(2))