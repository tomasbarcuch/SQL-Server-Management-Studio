select L.code, bu.Name, CF.* from CustomValue  CV
left join [Location] L on CV.EntityId = L.Id
inner join CustomField CF on CV.CustomFieldId = CF.id
inner join BusinessUnit BU on CF.ClientBusinessUnitId = BU.Id
where cv.entity in(24)
order by CV.Entity




begin transaction
delete from customfield where id in (



'b7ff5df0-312e-4216-899d-59f8f0402563'
,'b7ff5df0-312e-4216-899d-59f8f0402563'
,'cb5a8c4f-57a5-445b-99eb-1930d3be5dbc'
,'cb5a8c4f-57a5-445b-99eb-1930d3be5dbc'
,'b7ff5df0-312e-4216-899d-59f8f0402563'
,'cb5a8c4f-57a5-445b-99eb-1930d3be5dbc'
,'b7ff5df0-312e-4216-899d-59f8f0402563'
,'cb5a8c4f-57a5-445b-99eb-1930d3be5dbc'
,'cb5a8c4f-57a5-445b-99eb-1930d3be5dbc'
,'b7ff5df0-312e-4216-899d-59f8f0402563'
,'cb5a8c4f-57a5-445b-99eb-1930d3be5dbc'
,'b7ff5df0-312e-4216-899d-59f8f0402563'
,'cb5a8c4f-57a5-445b-99eb-1930d3be5dbc'
,'cb5a8c4f-57a5-445b-99eb-1930d3be5dbc'
,'b7ff5df0-312e-4216-899d-59f8f0402563'
,'b7ff5df0-312e-4216-899d-59f8f0402563'
,'b7ff5df0-312e-4216-899d-59f8f0402563'
,'cb5a8c4f-57a5-445b-99eb-1930d3be5dbc'
,'b7ff5df0-312e-4216-899d-59f8f0402563'
,'cb5a8c4f-57a5-445b-99eb-1930d3be5dbc'
,'cb5a8c4f-57a5-445b-99eb-1930d3be5dbc'
,'b7ff5df0-312e-4216-899d-59f8f0402563'
,'cb5a8c4f-57a5-445b-99eb-1930d3be5dbc'
,'cb5a8c4f-57a5-445b-99eb-1930d3be5dbc'
,'cb5a8c4f-57a5-445b-99eb-1930d3be5dbc'
,'b7ff5df0-312e-4216-899d-59f8f0402563'
,'b7ff5df0-312e-4216-899d-59f8f0402563'
,'cb5a8c4f-57a5-445b-99eb-1930d3be5dbc'
,'cb5a8c4f-57a5-445b-99eb-1930d3be5dbc'
,'b7ff5df0-312e-4216-899d-59f8f0402563'
,'cb5a8c4f-57a5-445b-99eb-1930d3be5dbc'
,'b7ff5df0-312e-4216-899d-59f8f0402563'
,'b7ff5df0-312e-4216-899d-59f8f0402563'
,'cb5a8c4f-57a5-445b-99eb-1930d3be5dbc'
,'cb5a8c4f-57a5-445b-99eb-1930d3be5dbc'
,'cb5a8c4f-57a5-445b-99eb-1930d3be5dbc'
,'b7ff5df0-312e-4216-899d-59f8f0402563'
,'cb5a8c4f-57a5-445b-99eb-1930d3be5dbc'
,'b7ff5df0-312e-4216-899d-59f8f0402563'
,'b7ff5df0-312e-4216-899d-59f8f0402563'
,'b7ff5df0-312e-4216-899d-59f8f0402563'
,'b7ff5df0-312e-4216-899d-59f8f0402563'
,'cb5a8c4f-57a5-445b-99eb-1930d3be5dbc'
,'b7ff5df0-312e-4216-899d-59f8f0402563'
)

commit