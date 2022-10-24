  select distinct
   No_ [Content], 
   '' ParentDimensionValue,
'Customer' Dimension,
   Name Description , 
   [Name 2] [DF_Name 2] , 
   Address [DF_Address], 
   City [DF_City], 
   c.[VAT Registration No_] [DF_VAT Registration No_], 
   [Post Code] [DF_Post Code], 
   [E-Mail] [DF_E-Mail], 
   [SAP Customer No_] [DF_SAP Customer No_], 
   [VV Customer No_] [DF_VV Customer No_], 
   case Blocked_Editing when 0 then 'FALSE' else 'TRUE' end as [DF_Blocked]
,c.[Last Modified Date Time]
,c.[Last Date Modified]
,c.TIMESTAMP as Created
,c.[Responsible Person Code]

 from [DCNLPWSQL04].[DFDSE_NAV110DE_PRD].[dbo].Deufol_Central_Company$Customer as c
 left join (
    select Customer.* from ( select
        DV.Content Customer_no
        ,DV.[Description] Customer
        ,DF.Name
        ,DFV.Content
    from [DCNLPWSQL08].[DFCZ_OSLET].[dbo].DimensionField DF

        inner join [DCNLPWSQL08].[DFCZ_OSLET].[dbo].DimensionFieldValue DFV on Df.id = DFV.DimensionFieldId
        inner join [DCNLPWSQL08].[DFCZ_OSLET].[dbo].DimensionValue DV on DFV.DimensionValueId = DV.Id
        inner join BusinessUnitPermission BUP on DV.id = BUP.DimensionValueId and BUP.BusinessUnitId = (select id from BusinessUnit where name = 'DEUFOL CUSTOMERS')
        inner join [DCNLPWSQL08].[DFCZ_OSLET].[dbo].Dimension D on DF.DimensionId = D.id and D.name = 'Customer'
    where 
        DF.name in ((select name 
                    from [DCNLPWSQL08].[DFCZ_OSLET].[dbo].DimensionField 
                    where ClientBusinessUnitId = (select id from BusinessUnit  where name = 'DEUFOL CUSTOMERS') 
                    group by name)))SRC
    pivot (max(SRC.Content) for SRC.Name in ([VAT Registration No_])) as Customer) as dc on dc.[VAT Registration No_] collate database_default = c.[VAT Registration No_] collate database_default
where c.[VAT Registration No_] <> ''   and dc.Customer_no is NULL
--and Blocked_Editing <> 0

order by c.[Last Modified Date Time] desc