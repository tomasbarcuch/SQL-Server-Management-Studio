begin TRANSACTION
--insert INTO BXNLMacro
SELECT 
newid(),
 replace(DATA.[Description],';',' ') Description,
DATA.Macro,
'0' [Disabled],
	[CreatedById] = 'eba86d7e-e20e-40f0-8e6e-1831fe48e45a',
	[UpdatedById] = 'eba86d7e-e20e-40f0-8e6e-1831fe48e45a',
	GETUTCDATE() [Created],
	GETUTCDATE() [Updated]

from (select 

count([BuildingMode]+';'+[BuildingCode]) as count,
upper([BuildingMode]+';'+[BuildingCode]) as Description,
[BuildingMode]+';'+[BuildingCode] as Macro
  FROM [BoxCAD].[dbo].[BoxOrder] BO
  inner join [BoxCAD].[dbo].[Macro] M on BO.BuildingCode = M.MName
  where MType in ('B','S','V') and ShareType = 'P' and VRPApproved = 1
  group by [BuildingMode]+';'+[BuildingCode] 
having count([BuildingMode]+';'+[BuildingCode]) >1
--order by  [BuildingMode]+';'+[BuildingCode] 
) data
where replace(DATA.[Description],';','') not in (select description COLLATE Latin1_General_CI_AS from BXNLMacro)
and replace(DATA.[Description],';',' ') not in (select description COLLATE Latin1_General_CI_AS from BXNLMacro)


ROLLBACK