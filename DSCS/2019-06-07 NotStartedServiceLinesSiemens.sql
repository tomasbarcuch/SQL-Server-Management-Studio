select
LP.Code,
LP.[Description],
TSLP.text as Status, 
wfe.Created

 from workflowentry WFE

inner join LoosePart LP on WFE.EntityId = LP.id
inner join BusinessUnitPermission BUP on LP.id = BUP.LoosePartId and BUP.BusinessUnitId = (Select id from BusinessUnit where name = 'Siemens Berlin')
inner join Status SLP on WFE.StatusId = SLP.Id
left join Translation TSLP on SLP.Id = TSLP.EntityId and language = 'de'
inner join ServiceLine SL on LP.id = sl.EntityId
inner join status CURRS on LP.StatusId = CURRS.id 
 and currs.id not in ('4e390c9b-0365-4634-8356-a492097b7d32','a40d84d9-24f9-408b-b7bc-2dcfd8ace31b')

 
 left join 
( select
LP.code,
SSL.Name
 from workflowentry WFE
 inner join ServiceLine SL on WFE.EntityId = SL.Id
 inner join BusinessUnitPermission BUP on SL.id = BUP.ServiceLineId and BUP.BusinessUnitId = (Select id from BusinessUnit where name = 'Siemens Berlin')
inner join LoosePart LP on SL.EntityId = LP.id
inner join Status SSL on WFE.StatusId = SSL.Id
inner join status CURRS on SL.StatusId = CURRS.id 
  where WFE.entity = 48 and currs.id  not in ('4e390c9b-0365-4634-8356-a492097b7d32','a40d84d9-24f9-408b-b7bc-2dcfd8ace31b') and SSL.name = 'SlStart'
 
  )

 SLSTART on LP.code = SLSTART.Code 

   where WFE.entity = 15 and SLP.name = 'LpPainted'  and currs.id not in ('4e390c9b-0365-4634-8356-a492097b7d32','a40d84d9-24f9-408b-b7bc-2dcfd8ace31b')
   and SLSTART.code is null
and wfe.created > '2019-05-31'