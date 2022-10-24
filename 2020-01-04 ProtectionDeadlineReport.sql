select 
		HU.Code,
        HU.[Description],
        L.Name as Location,
        B.Code as Bin,
        s.name as Status,
      cast (min(HU.Created) as date) as Created,
      cast(max(wfe.[Updated]) as date) as ItemInserted,
       HU.Protection,
      cast(DATEADD(month, HU.Protection, min(HU.Created)) as date) as ProtectionDeadline,
      cast(DATEADD(month, HU.Protection, min(HU.Created))-10 as date) as ReportDate
  FROM dbo.WorkflowEntry WFE
  inner join dbo.HandlingUnit HU on wfe.entityid = HU.id
  left join Location L on HU.ActualLocationId = L.id
left join Bin B on HU.ActualBinId = B.id
  inner join dbo.status s on wfe.statusid = s.id
    where WFE.entity = 11 and wfe.statusid = (select S.id from [Status] S
inner join BusinessUnitPermission BUP on S.id = BUP.StatusId and BUP.BusinessUnitID = (Select id from BusinessUnit where name = 'Reifenhäuser')

where S.name = 'HuItemInserted')
and HU.StatusId in (select id from [Status] where name = 'HuItemInserted')



  group by 
s.name,
    HU.code,
    HU.[Description],
    L.Name,
    B.code,
       wfe.[Entity]
      ,wfe.[EntityId]
      ,wfe.[StatusId]
      ,HU.Protection


having cast(DATEADD(month, HU.Protection, min(HU.Created))-10 as date) < cast(getdate() as date)

      order by 
DATEADD(month, HU.Protection, min(HU.Created))-10 