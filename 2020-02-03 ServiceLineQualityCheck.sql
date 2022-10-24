declare @Client as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'Siemens Berlin')
declare @status as VARCHAR(MAX) = 'SlApproved'
declare @Reason as VARCHAR(MAX) = '06 Lackierbedarf (Fehlende Beauftragung)'
declare @FromDate as DATE = '2020-01-01'
declare @ToDate as DATE = '2020-01-31'

select
LASTCHANGE.Created as LastChange,
LP.Code,
SL.[Description]
,isnull(TSL.text, SSL.name) as Status
,U.FirstName+' '+U.LastName as UpdatedBy
,WF.Created as SlApproved
,CF.LockReason
,CF.DatumStart
,CF.DatumEnd
  from (
select WFE.Entity, WFE.EntityId, WFE.Created, WFE.CreatedById  from WorkflowEntry WFE where WFE.StatusId in (
select S.id from Status S
INNER JOIN BusinessUnitPermission BUP ON S.Id = BUP.StatusId
INNER JOIN BusinessUnit BU ON BUP.BusinessUnitId = BU.Id and BU.Id = @Client
where S.name = @status)
and WFE.Created between @FromDate and @ToDate
) WF
inner join ServiceLine SL on WF.EntityId = SL.Id
INNER JOIN (select 
WFE.EntityId,
Max(WFE.Created) as Created
 from WorkflowEntry WFE
WHERE WFE.Entity = 48 
group by Wfe.EntityId

) LASTCHANGE on SL.id = LASTCHANGE.EntityId
inner join LoosePart LP on SL.EntityId = LP.Id
left join Comment C on LP.id = C.EntityId
inner join [User] U on SL.UpdatedById = U.Id
inner join status SSL on SL.StatusId = SSL.Id
left join Translation TSL on SSL.id = TSL.EntityId and language = 'de'
left join (
SELECT 
CustomField.Name as CF_Name, 
C.entityID as id,
CV.Content as CV_Content,
CV.EntityId as EntityID
FROM CustomField with (NOLOCK)
INNER JOIN CustomValue CV ON (CustomField.Id = CV.CustomFieldId)
inner join Comment C on CV.EntityId = C.Id
where name in ('LockReason','DatumStart','DatumEnd')
) SRC
PIVOT (max(src.CV_Content) for src.CF_Name  in ([LockReason],[DatumStart],[DatumEnd])
        )  as CF on C.id = CF.EntityId
where CF.LockReason = @Reason

order by LP.Code, LASTCHANGE