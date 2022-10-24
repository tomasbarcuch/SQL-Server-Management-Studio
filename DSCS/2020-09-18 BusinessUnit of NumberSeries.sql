select BU.name, NS.Prefix from NumberSeries NS
inner join BusinessUnitPermission BUP on ns.id = BUP.NumberSeriesId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id
where Prefix = 'HU049-'