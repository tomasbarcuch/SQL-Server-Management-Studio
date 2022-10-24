BEGIN TRANSACTION
--update CustomValue set Content = '[0M] abdecken'  from CustomValue where CustomFieldId = '7e4ddb50-abb8-4e21-8bd0-3d4ac07edef1a' and content = 'abdecken'
--update CustomValue set Content = '[0M] schrumpfen,abdecken'  from CustomValue where CustomFieldId = '7e4ddb50-abb8-4e21-8bd0-3d4ac07edef1a' and content = 'schrumpfen,abdecken'
update CustomValue set Content = '[12M] Alu,schrumpfen,schweissen,abdecken' from CustomValue where CustomFieldId = '7e4ddb50-abb8-4e21-8bd0-3d4ac07edef1a' and content = 'Alu,schrumpfen,schweissen,abdecken'
rollback
