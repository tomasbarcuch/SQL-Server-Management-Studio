select LP.Created, LP.Id LPID, LP.Code, LPI.Created, LPI.Id LPIID, LPI.Identifier from LoosePart LP
inner join BusinessUnitPermission BUp on LP.id = BUP.LoosePartId and BUP.BusinessUnitId = (Select id from BusinessUnit where name = 'Siemens Duisburg')
left join LoosePartIdentifier LPI on LP.Id = LPI.LoosePartId
Where LP.Code like 'B%'and LPI.Identifier like 'B%' and LPI.Identifier <> LP.Code

--and CAST(LPI.Created as DATE) <> CAST(LP.Created as DATE)