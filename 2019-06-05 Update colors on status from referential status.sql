

(select color from STATUS 
inner join translation on status.id = translation.entityid and language = 'de'
inner join BusinessUnitPermission BUP on Status.id = bup.StatusId and bup.BusinessUnitId = (select id from BusinessUnit where name = 'Siemens Berlin')
where translation.text = 'LpGedruckt')

begin transaction
update status set color = (select color from STATUS 
inner join translation on status.id = translation.entityid and language = 'de'
inner join BusinessUnitPermission BUP on Status.id = bup.StatusId and bup.BusinessUnitId = (select id from BusinessUnit where name = 'Siemens Berlin')
where translation.text = 'LpGedruckt') where id in (select status.id from status
inner join translation on status.id = translation.entityid and language = 'de'
inner join BusinessUnitPermission BUP on Status.id = bup.StatusId and bup.BusinessUnitId = (select id from BusinessUnit where name = 'Siemens Berlin')
where translation.text in ('LpLackiertFrei','LpVerpackt','LpWeSiemensG','LpSollLackiertSiemensG'))
commit
