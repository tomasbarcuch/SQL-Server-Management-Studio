select BU.name BusinessUnit,BU.BXNLClientCode, M.Descript as BXNLClientName, BU.BXNLProjectDimension, ISNULL(BXNLCustomerDimension,'') BXNLCustomerDimension
from BusinessUnit BU
inner join DCNLPWSQL05.[BoxCAD].[dbo].[Mandants] M on BU.BXNLClientCode =   M.Name collate Latin1_General_100_CI_AS_SC
where type in (2,0) and [Disabled] = 0

