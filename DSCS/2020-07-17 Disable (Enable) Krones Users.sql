begin TRANSACTION
update [User] set 
disabled = 1,--0,
UpdatedById = (select id from [User] where login = 'tomas.barcuch'),
Updated = getdate()
 from [User] U where
(u.Email like '%krones%'
or u.Email like '%karlgross.de%'
or u.Email in ('v.uraikin@ls-cargo.com','ronaldo.yonamine@brasil-projects.com.br'))
and [Disabled] = 0

ROLLBACK