declare
    @cols nvarchar(max),
    @stmt nvarchar(max),
    @client nvarchar(max)

select @cols = isnull(@cols + ', ', '') + '[' + CF.NAME + ']' from (select distinct name from customfield group by name) as CF

select @stmt = '
select P.* from
(
SELECT 
Customfield.clientbusinessunitid,
CustomField.ID as CV_Id, 
CustomField.Name as CF_Name, 
CustomValue.Entity as CV_Entity, 
CustomValue.EntityId as CV_EntityID,
CustomValue.Content as CV_Content
FROM CustomField 
INNER JOIN CustomValue ON (CustomField.Entity = CustomValue.Entity) AND (CustomField.Id = CustomValue.CustomFieldId)

) SRC
PIVOT (max(src.CV_Content) for src.CF_Name  in (' + @cols + ')
        ) as P'

exec sp_executesql  @stmt = @stmt