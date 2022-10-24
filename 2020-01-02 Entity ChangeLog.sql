select LE.Created, HU.Code, Ucr.login createdby, LE.ColumnName, LE.OldValue, LE.NewValue from LogEntity LE
inner join [User] Ucr on LE.CreatedById = Ucr.id

inner join HandlingUnit HU on LE.EntityId = HU.Id
where ClientBusinessUnitId = (select id from BusinessUnit where name = 'Krones AG')
--and ColumnName = 'StatusID'
order by LE.Created desc

