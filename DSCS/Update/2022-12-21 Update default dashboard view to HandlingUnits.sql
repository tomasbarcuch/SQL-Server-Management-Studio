begin TRANSACTION

update [User] set SelectedView = REPLACE(SelectedView,'"Value":"100"','"Value":"1"') where [SelectedView] like '%"Value":"100"%'

COMMIT
