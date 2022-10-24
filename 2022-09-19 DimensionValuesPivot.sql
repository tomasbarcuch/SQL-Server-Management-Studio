declare @ClientBusinessUnitId as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'DEUFOL CUSTOMERS')
declare @PackerBusinessUnitId as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'Deufol Nürnberg')
declare @DimensionValueId as UNIQUEIDENTIFIER = '82f69a8c-4109-4e25-9715-eaa3da622407'
declare @Language as CHAR (2) = 'de'
declare @cols nvarchar(max), @stmt nvarchar(max), @client nvarchar(max)

select @cols = isnull(@cols + ', ', '') + '[' + DimNames.NAME + ']' from (select D.Name from Dimension D
inner join BusinessUnitPermission BUP on D.id = BUP.DimensionId and BUP.BusinessUnitId = @ClientBusinessUnitId and D.[Disabled] = 0
) as DimNames

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



