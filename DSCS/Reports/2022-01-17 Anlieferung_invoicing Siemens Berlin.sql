select 
DATA.Updated,
DATA.Sorting,
DATA.Class,
DATA.[LP Code],
CAST(DATA.Datum as date) as Datum,
DATA.BU,
DATA.Project,
DATA.Kennwort,
DATA.Position,
DATA.Abrechnungskategorie,
DATA.Weight,
DATA.Baugruppe,
DATA.[Brutto kg],
MONTH(DATA.Updated)  'Monat',
CONVERT(DECIMAL(10,2),DATA.[Brutto kg]) as 'Bruttokg'
 from (
select
WFE.Updated,
CASE when CF.Abrechnungskategorie ='Stückgut (Hand) kleiner 5 kg/Stk' then '5.2.1' else
CASE when CF.Abrechnungskategorie ='Palettengut (Stapler),kleiner 1 Tonne/Stk' then '5.2.2' else
CASE when CF.Abrechnungskategorie ='Stapler gross bei Kiste bzw. bei nicht Palettengut bzw. wenn Ware grosser 1 Tonne, Abrechnung mindestens 1 Tonne, >1 to =KG genau' then '5.2.3' else
CASE when CF.Abrechnungskategorie ='Krangut (Kran), kleiner 20 Tonnen, Abrechnung mindestens 1 Tonne,> 1 to = KG genau' and LP.Description not like '%8VM1%' then '5.2.4' else
CASE when CF.Abrechnungskategorie = 'Krangut (Kran), kleiner 20 Tonnen, Abrechnung mindestens 1 Tonne,> 1 to = KG genau' and LP.Description like '%8VM1%' then '5.2.5' end end end end end
as Sorting,
CASE when CF.Abrechnungskategorie ='Stückgut (Hand) kleiner 5 kg/Stk' then 'Stückgut' else
CASE when CF.Abrechnungskategorie ='Palettengut (Stapler),kleiner 1 Tonne/Stk' then 'Palette' else
CASE when CF.Abrechnungskategorie ='Stapler gross bei Kiste bzw. bei nicht Palettengut bzw. wenn Ware grosser 1 Tonne, Abrechnung mindestens 1 Tonne, >1 to =KG genau' then 'Kiste' else
CASE when CF.Abrechnungskategorie ='Krangut (Kran), kleiner 20 Tonnen, Abrechnung mindestens 1 Tonne,> 1 to = KG genau' and LP.Description not like '%8VM1%' then 'Kran' else
CASE when CF.Abrechnungskategorie = 'Krangut (Kran), kleiner 20 Tonnen, Abrechnung mindestens 1 Tonne,> 1 to = KG genau' and LP.Description like '%8VM1%' then 'Kran 8VM1' end end end end end
as Class,
LP.Code as 'LP Code',
convert(varchar,CF.[Datum WE (fix)],104)  AS 'Datum',
BU.Name as 'BU',
Dimensions.Project,
Dimensions.[Description] 'Kennwort',
CF.Position,
CF.Abrechnungskategorie,
LP.Weight,
LP.[Description] as 'Baugruppe',
cast(case when (charindex(',',CF.[Brutto kg])) > 0 then
left(CF.[Brutto kg],(charindex(',',CF.[Brutto kg]))-1)+'.'+right(CF.[Brutto kg],len(CF.[Brutto kg])-(charindex(',',CF.[Brutto kg])))
 else CF.[Brutto kg] end as float) as [Brutto kg]


from (SELECT 

		wfe.[EntityId]
      ,max(wfe.[Updated]) as Updated
  FROM dbo.WorkflowEntry WFE WITH (NOLOCK)
  inner join dbo.status s on wfe.statusid = s.id
  where entity = 15 and wfe.statusid in (select S.id from [Status] S
inner join BusinessUnitPermission BUP on S.id = BUP.StatusId and BUP.BusinessUnitID = (Select id from BusinessUnit where name = 'Siemens Berlin')
where S.name in ('LpInbound','LpPainted','LpToBePainted','LpToBePaintedSiemensPrinted','LpPaintedSiemensPrinted'))
  group by 

      wfe.[EntityId]) WFE  

INNER JOIN LoosePart LP ON WFE.EntityId = LP.Id and LP.Weight > 0
INNER JOIN BusinessUnitPermission BUP ON LP.Id = BUP.LoosePartId
INNER JOIN BusinessUnit BU ON BUP.BusinessUnitId = BU.Id and BU.ID = (Select id from BusinessUnit where name = 'Siemens Berlin')

INNER JOIN (
select
D.Name, 
DV.[Description], 
DV.Content, 
edvr.EntityId from DimensionValue DV 
inner join Dimension D on DV.DimensionId = D.id 
inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
where D.name in ('Project') 
) SRC
PIVOT (max(src.Content) for src.Name  in ([Project])
        ) as Dimensions on LP.id = Dimensions.EntityId


left join (
SELECT
CustomField.Name as CF_Name, 
CV.Content as CV_Content,
CV.EntityId as EntityID
FROM CustomField 
INNER JOIN CustomValue CV ON (CustomField.Id = CV.CustomFieldId)
where name in ('Position','Abrechnungskategorie','Brutto kg','Datum WE (fix)') and CV.Entity = 15
) SRC
PIVOT (max(src.CV_Content) for src.CF_Name  in ([Position],[Abrechnungskategorie],[Brutto kg],[Datum WE (fix)])
        ) as CF on LP.id = CF.EntityID

where LEN(CF.Abrechnungskategorie)>0 

 ) DATA

where (
(CASE WHEN DATA.Sorting = '5.2.1'  then 1 else 0 end ) = 1
OR 
(CASE WHEN DATA.Sorting = '5.2.2'  then 1 else 0 end ) = 1
OR
(CASE WHEN DATA.Sorting = '5.2.3'  then 1 else 0 end ) = 1
OR
(CASE WHEN DATA.Sorting = '5.2.4'   then 1 else 0 end ) = 1
OR
(CASE WHEN DATA.Sorting = '5.2.5'  then 1 else 0 end ) = 1
)
and 
--(DATA.Datum >=  $P{Von} and DATA.Datum <=$P{Bis}
(DATA.Datum between '2021-12-01' and '2021-12-31'
)
and DATA.[Brutto kg] > 0.00