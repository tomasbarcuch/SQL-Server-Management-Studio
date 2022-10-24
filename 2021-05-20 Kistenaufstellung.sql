SELECT 
[HU].[Id] AS [Id]
,Project.ProjectNr 'Projekt'
,Project.Project as 'Projekt Kennwort'
,[Verpackungsart].[Content] AS [Verpackungsart]
,[Position].[Content] AS [Position]
,[HU].[Description] AS [Beschreibung]
,[Macros].[Content] AS [Vorschrift]
,[HU].[Code] AS [Code]
,[HU].[Length]/10 AS [Läange]
,[HU].[Width]/10 AS [Breite]
,[HU].[Height]/10 AS [Höhe]
,[HU].[Weight] AS 'Tara [kg]'
,[HU].[Netto] AS 'Netto [kg]'
,[HU].[Brutto] AS 'Brutto [kg]'
,[HU].[Surface] AS '[m²]'
,[HU].[Volume] AS '[m³]'
,Abrechnungshinweis.Content Abrechnungshinweis
,1 as [Quantity]

 FROM [HandlingUnit] [HU]
 LEFT OUTER JOIN [Status] AS [S] ON [HU].[StatusId] = [S].[Id] 
 LEFT OUTER JOIN [CustomValue] AS [Verpackungsart] ON [Verpackungsart].[EntityId] = [HU].[Id] AND [Verpackungsart].[CustomFieldId] in (Select id from CustomField where name = ('Verpackungsart'))  
 LEFT OUTER JOIN [CustomValue] AS [Macros] ON [Macros].[EntityId] = [HU].[Id] AND [Macros].[CustomFieldId] in (Select id from CustomField where name = ('Macros'))  
 LEFT OUTER JOIN [CustomValue] AS [Position] ON [Position].[EntityId] = [HU].[Id] AND [Position].[CustomFieldId] in (Select id from CustomField where name = ('Position'))
 LEFT OUTER JOIN [CustomValue] AS [Abrechnungshinweis] ON [Abrechnungshinweis].[EntityId] = [HU].[Id] AND [Abrechnungshinweis].[CustomFieldId] in (Select id from CustomField where name = ('Abrechnungshinweis'))  
LEFT OUTER JOIN (
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
DF.name in ('Kennwort'))SRC
pivot (max(SRC.Content) for SRC.Name   in ([Kennwort])) as Project on HU.id = Project.EntityId
 
  
 WHERE 
 HU.id in (
'33eac311-3a65-4c8c-bee1-000d80190a0b',
'0cbc2c8e-07cd-43df-8901-000eb597a49a',
'721eab6e-d072-4687-b94e-00147d47bdf2',
'21f14932-a9ba-4fb5-ba41-0016a8af29b4',
'290cb4f4-20d7-4215-808a-00184e48b535',
'd3fd1c9a-3bc9-485d-8f97-002520df57c7',
'd46a778b-7f99-47d7-b5e6-0027485c3684',
'59444e16-af5b-4fd2-808c-002c62fb50c5',
'9e1f38de-2ed0-4fb6-90fa-00395fec9785',
'f5455ed4-de86-4eea-b395-003d246eddb8'
 ) AND 
 EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[HandlingUnitId] = [HU].[Id]) AND ([BUP].[BusinessUnitId] = (select id from BusinessUnit where name = 'Siemens Berlin'))) 
 AND EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[HandlingUnitId] = [HU].[Id]) AND ([BUP].[BusinessUnitId] = (select id from BusinessUnit where name = 'Deufol Berlin')))
