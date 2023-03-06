SELECT
HU.Code,
POH.Code,
--BO.*, 
--S.Code State,
'' Code
,ISNULL(LEFT(CASE when LEN(B.DescriptionText) = 0 then BO.BoxContent else B.DescriptionText+' '+BO.BoxContent end, LEN(CASE when LEN(B.DescriptionText) = 0 then BO.BoxContent else B.DescriptionText+' '+BO.BoxContent end)),BO.ProjectCode) Description
,B.CorrosionProtect as Protection
,B.InnerLength
,B.InnerWidth
,B.InnerHeight
,B.OuterLength Lenght
,B.OuterWidth Width
,B.OuterHeight Height
,B.Netto NetWeight
,BO.BuildingCode Macros
,BO.ProjectCode
,BO.Code+' '+ BO.Note Note
,BO.CustomerName
,BO.SendToProduction DeliveryDate
,M.Name
,M.Descript


 FROM DCNLPWSQL05.[BoxCAD].[dbo].[Box] B
INNER JOIN  DCNLPWSQL05.[BoxCAD].[dbo].[BoxOrder] BO on B.IDXOrder = BO.IDX
INNER JOIN DCNLPWSQL05.[BoxCAD].[dbo].Mandants M on BO.IDXMandant = M.IDX
INNER JOIN DCNLPWSQL05.[BoxCAD].[dbo].C_OrderState S on BO.IDOrderState = S.ID-- and S.ID < 2
LEFT JOIN HandlingUnit HU on BO.Code = HU.Code COLLATE SQL_Latin1_General_CP1250_CI_AS
LEFT JOIN PackingOrderHeader POH on HU.Id = POH.HandlingUnitId

WHERE POH.Code IS NULL AND
(B.OuterLength+B.OuterWidth+B.OuterHeight > 0) AND M.Name = '00004' AND BO.CustomerName = 'SIEMENS - Drásov' and BO.SendToProduction > '2023-01-01'
--and BO.BoxContent like '%1643649/10%'
order by BO.Code