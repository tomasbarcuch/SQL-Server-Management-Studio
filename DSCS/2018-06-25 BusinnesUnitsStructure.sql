SELECT
BU.name as BUname,
BU.ReportSubfolder,
case bu.type
when 0 then 'Packer'
when 1 then 'Customer'
when 2 then 'Client'
when 3 then 'Vendor'
else '' end as BUType,
BR.Name as BRname,
CASE br.type 
when 0 then 'Packer'
when 1 then 'Customer'
when 2 then 'Client'
when 3 then 'Vendor'
else '' end as BrType,
 * 
  FROM [dbo].[BusinessUnitRelation] BUR

  left outer join BusinessUnit BU on BUR.BusinessUnitId = BU.Id
  left outer join BusinessUnit BR on BUR.RelatedBusinessUnitId = BR.id

  where 
  BU.[Disabled] = 0 
  --and   bu.type = 2 
  --and bu.name = 'JOKER LOGISTICS' 
  and Br.name in ('Deufol Hamburg Rosshafen')
order by Bu.name