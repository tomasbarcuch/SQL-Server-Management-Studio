
declare @datum as date = '2021-12-13'

--inner join line 398 in report SQL query
select 
EntityID,
CF.Name,
cast(CV.Content as datetime) as Datum,
case when CF.Name = 'DatumStart' then case when (
left(right((convert(datetime, CFVM.created) at TIME zone 'Central European Standard Time'),6),1) = '+' )
then
CFVM.created + right((convert(datetime,CFVM.created) at TIME zone 'Central European Standard Time'),5)
else 
CFVM.created - right((convert(datetime, CFVM.created) at TIME zone 'Central European Standard Time'),5)
end else CV.content end as Created


from customfieldvalue CV with (NOLOCK)
INNER join CustomField CF on CV.CustomFieldId = CF.Id
inner join CustomFieldValueMapping CFVM on CV.CustomFieldId = CF.Id and CustomFieldValueId = CV.Id
where CV.CustomFieldId in 
(select id from CustomField with (NOLOCK) where name in ('DatumStart','DatumEnd'))

and cast(CV.Content as date) = @datum


select 
EntityID,
CF.Name,
cast(CV.Content as datetime) as Datum,
case when CF.Name = 'DatumStart' then case when (
left(right((convert(datetime, CV.created) at TIME zone 'Central European Standard Time'),6),1) = '+' )
then
CV.created + right((convert(datetime,CV.created) at TIME zone 'Central European Standard Time'),5)
else 
CV.created - right((convert(datetime, CV.created) at TIME zone 'Central European Standard Time'),5)
end else CV.content end as Created


from DCNLPWSQL08.[DFCZ_OSLET].[dbo].customvalue CV with (NOLOCK)
inner join DCNLPWSQL08.[DFCZ_OSLET].[dbo].CustomField CF on CV.CustomFieldId = CF.Id
where CV.CustomFieldId in 
(select id from DCNLPWSQL08.[DFCZ_OSLET].[dbo].CustomField with (NOLOCK) where name in ('DatumStart','DatumEnd'))


and cast(CV.Content as date) = @datum



inner join (--SQL query on line 321
select 
EntityID,
CF.Name,
cast(CV.Content as datetime) as Datum,
case when CF.Name = 'DatumStart' then case when (
left(right((convert(datetime, CFVM.created) at TIME zone 'Central European Standard Time'),6),1) = '+' )
then
CFVM.created + right((convert(datetime,CFVM.created) at TIME zone 'Central European Standard Time'),5)
else 
CFVM.created - right((convert(datetime, CFVM.created) at TIME zone 'Central European Standard Time'),5)
end else CV.content end as Created


from customfieldvalue CV with (NOLOCK)
inner join CustomField CF on CV.CustomFieldId = CF.Id
inner join CustomFieldValueMapping CFVM on CV.CustomFieldId = CF.Id and CustomFieldValueId = CV.Id
where CV.CustomFieldId in 
(select id from CustomField with (NOLOCK) where name in ('DatumStart','DatumEnd')) and Content <> '') dates on lockheader.EntityID = dates.EntityId