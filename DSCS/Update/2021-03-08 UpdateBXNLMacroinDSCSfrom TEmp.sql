
begin TRANSACTION
--update POH set POH.BXNLMacroId = M.ID 
SELECT POH.ID,M.ID,POTEMP.Macro,M.Macro,M.[Disabled]

  FROM PackingOrderHeaderTemp POTEMP
inner join PackingOrderHeader POH on POTEMP.ID = POH.Id
inner join BXNLmacro M on replace(replace(POTEMP.Macro,';',''),'-',' ') = replace(M.Macro,';','')
inner join status S on POH.StatusId = S.id
where  s.name in ('BXNLCrateProduced','BXNLSuccess','BXNLProduced','ASSIGNED')

and POH.BXNLMacroId is null

COMMIT