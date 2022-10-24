begin TRANSACTION
--insert into BXNLMacro
SELECT 
NEWID()[Id],
DATA.[Description],
DATA.Macro,
DATA.[Disabled],
	[CreatedById] = (select id from [User] where login = 'tomas.barcuch'),
	[UpdatedById] = (select id from [User] where login = 'tomas.barcuch'),
	GETUTCDATE() [Created],
	GETUTCDATE() [Updated]


 from (
select

ISNULL(BXNL.DESCRIPTION,replace(DSCS.Macro,';','')) as Description,
ISNULL(BXNL.macro, DSCS.Macro) AS Macro,
case when BXNL.macro is null then 'TRUE' else 'FALSE' end as Disabled


from (
SELECT MName as Description,';'+MName+';' as 'Macro','FALSE' as 'Disabled'

  FROM [BoxCAD_test].[dbo].[Macro]

  where MType = 'B' and ShareType = 'P' and VRPApproved = 1
  
UNION

      SELECT MName as Description,MName as 'Macro','FALSE' as 'Disabled'

  FROM [BoxCAD_test].[dbo].[Macro]
  where MType = 'S' and ShareType = 'P' and VRPApproved = 1
UNION
        SELECT MName+' NONWOOD'  as Description,';'+MName+';NONWOOD' as 'Macro','FALSE' as 'Disabled'

  FROM [BoxCAD_test].[dbo].[Macro]
  where MType = 'B' and ShareType = 'P' and VRPApproved = 1 and NWCompatible = 1
  UNION
        SELECT MName+' NONWOOD'  as Description,';'+MName+';NONWOOD' as 'Macro','FALSE' as 'Disabled'
        
  FROM [BoxCAD_test].[dbo].[Macro]
  where MType = 'V' and ShareType = 'P' and VRPApproved = 1
) BXNL
FULL join (select 
POHTemp.macro,
S.Name
from PackingOrderHeaderTemp POHTemp
inner join PackingOrderHeader POH on POHTemp.Id = POH.Id
inner join status S on POH.StatusId = S.id

where POH.HandlingUnitId is not NULL and len(Macro)>1
and s.name in ('BXNLCrateProduced','BXNLSuccess','BXNLProduced','ASSIGNED')
group by macro, S.name) DSCS on BXNL.Macro COLLATE Latin1_General_CI_AS = DSCS.Macro COLLATE Latin1_General_CI_AS 
) DATA 


where DATA.Macro COLLATE Latin1_General_CI_AS  not in (select macro from BXNLMacro)
group by DATA.[Description],DATA.[Disabled], DATA.Macro

ROLLBACK



begin TRANSACTION
--update POH set POH.BXNLMacroId = M.ID 
SELECT POH.ID,M.ID,POTEMP.Macro,M.Macro,M.[Disabled]

  FROM PackingOrderHeaderTemp POTEMP
inner join PackingOrderHeader POH on POTEMP.ID = POH.Id
inner join BXNLmacro M on replace(replace(POTEMP.Macro,';',''),'-',' ') = replace(M.Macro,';','')
inner join status S on POH.StatusId = S.id
where  s.name in ('BXNLCrateProduced','BXNLSuccess','BXNLProduced','ASSIGNED')

and POH.BXNLMacroId is null

ROLLBACK