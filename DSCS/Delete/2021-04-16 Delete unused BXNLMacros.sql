begin TRANSACTION
--delete from BXNLMacro
select BXNL.*  
from BXNLMacro BXNL
left join PackingOrderHeader POH on POH.BXNLMacroID = BXNL.id
where POH.BXNLMacroId is null
order by Macro

ROLLBACK