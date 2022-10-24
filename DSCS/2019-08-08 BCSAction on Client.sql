select
A.id, 
A.Code,
A.[Description],
T.Text,
bu.Name,
(select id from [User] U where cast(U.FirstName+' '+U.LastName as [varchar]) = 'Tomáš Barcůch')


from BusinessUnitPermission BUP
inner join BCSAction A on BUP.BCSActionId = A.Id
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id
inner join Translation T on A.Id = T.EntityId and T.[Language] = 'de'

where BU.Id = (select id from BusinessUnit where name = 'KRONES GLOBAL')






