/*
Select
CH.FormatHeight,
CH.FormatLength,
CL.QuantityNet, -- =CHQuantityNet
CL.QuantityGross 'QuantityGross = QuantityNet+M',
case when WasteUnitId = 7 then CL.QuantityNet+MO.Waste 
else 
case when WasteUnitId = 3 then MO.Waste else
0 end end as CalculedQuantityGross, 
M.Speed 'CL.Speed = M.Speed',
M.SpeedUnitId 'CL.SpeedUnitId = M.SpeedUnitID',
SpeedUnit.Code as SpeedUnit,
MO.Setup 'CL.SetupTime = MO.Setup',
MO.SetupUnitId 'MO.SetupUnitId = CL.SetupUnitId',
MO.Waste,
WasteUnit.Code,
WasteUnit.ID

from CalculationLines CL
inner join CalculationHeaders CH on CL.CalculationHeaderID = CH.id
inner join MachineOperations MO on CL.MachineOperationId = MO.Id
inner join Machines M on MO.MachineId = M.Id
inner join Articles A on CL.ArticleId = A.Id
left join Units SpeedUnit on M.SpeedUnitId = SpeedUnit.Id
left join Units WasteUnit on MO.WasteUnitId = WasteUnit.Id

--===================================

select CH.ProfitLevelId,PL.Id from 
CalculationHeaders CH
,ProfitLevels PL 
where CH.QuantityNet between PL.FromQuantity and PL.ToQuantity

select 
QuantityNet = CH.QuantityNet
from CalculationLines CL
inner join CalculationHeaders CH on CL.CalculationHeaderId = CH.Id

select 
RevsNet =  CH.QuantityNet / CL.Utilization
from CalculationLines CL
inner join CalculationHeaders CH on CL.CalculationHeaderId = CH.Id

*/
Declare @BruttoMetru as DECIMAL 

select
MO.Name
,MO.WasteUnitId
,MO.Type
,'CalculationLines.RevsNet' = ((CH.QuantityNet/CL.Utilization/CL.LandscapePrintouts)+(MO.Waste/C.Circumference))*1.05 
,'NetMeters' = (((CH.QuantityNet/CL.Utilization/CL.LandscapePrintouts)+(MO.Waste/C.Circumference))*1.05)*(C.Circumference*CU.BaseUnitCoefficient)
,'Počet Obratů' = (C.Circumference / (select Circumference from Cylinders C where C.[Default] = 1))* (CH.QuantityNet/CL.Utilization/CL.LandscapePrintouts)
,'Netto Metrů papíru' = CASE WHEN A.ArticleType = 1 THEN (Select Circumference*CU.BaseUnitCoefficient from Cylinders where Id = CL.CylinderId) *(C.Circumference / (select Circumference from Cylinders C where C.[Default] = 1))* (CH.QuantityNet/CL.Utilization/CL.LandscapePrintouts) else 0 end
,'Brutto metrů papíru' = CASE WHEN A.ArticleType = 1 THEN (Select Circumference*CU.BaseUnitCoefficient from Cylinders where Id = CL.CylinderId) *(C.Circumference / (select Circumference from Cylinders C where C.[Default] = 1))* (CH.QuantityNet/CL.Utilization/CL.LandscapePrintouts)+MO.Waste*WU.BaseUnitCoefficient else 0 end
,'Počet rolí' = ROUND (CASE when A.RollLength > 0 then A.RollLength /  ((Select Circumference*CU.BaseUnitCoefficient from Cylinders where Id = CL.CylinderId) *(C.Circumference / (select Circumference from Cylinders C where C.[Default] = 1))* (CH.QuantityNet/CL.Utilization/CL.LandscapePrintouts)) else 0 end,0)
,''
,(C.Circumference*CU.BaseUnitCoefficient)
,'CalculationLines.RevsGros' = 
case when MO.Type in (2) and MO.WasteUnitId = 7 then (CH.QuantityNet/CL.Utilization/CL.LandscapePrintouts)+(MO.Waste/C.Circumference) +(MO.Waste*WU.BaseUnitCoefficient)/(C.Circumference*CU.BaseUnitCoefficient)
else 
case when MO.Type in (1) and MO.WasteUnitId = 3 then (CH.QuantityNet/CL.Utilization/CL.LandscapePrintouts)+(MO.Waste/C.Circumference) +(MO.Waste*WU.BaseUnitCoefficient)/(C.Circumference*CU.BaseUnitCoefficient)
else 0
end end
,'CalculationLines.MachineSpeed' = MO.Speed
,'CalculationLines.SetupTime' = MO.Setup
,'SetupTime' = CL.SetupTime*SU.BaseUnitCoefficient, BSU.Code
,'CalculationLines.CylinderId' = MO.CylinderId
,(CH.FormatHeight*FU.BaseUnitCoefficient) * (CH.FormatLength*FU.BaseUnitCoefficient) 
,FU.BaseUnitCoefficient
,C.[Space]
,C.Circumference
,C.[Space]
,MIN(CL.Speed) over (partition by CL.CalculationHeaderID,M.Id)

from CalculationLines CL
inner join CalculationHeaders CH on CL.CalculationHeaderId = CH.Id
inner join MachineOperations MO on CL.MachineOperationId = MO.Id
inner join Machines M on MO.MachineId = M.Id
left join Cylinders C on CL.CylinderId = C.Id
inner join Units FU on CH.FormatUnitId = FU.Id
left join Units CU on C.CircumferenceUnitId = CU.Id
left join Units WU on MO.WasteUnitId = WU.Id
left join Units SU on MO.SetupUnitId = SU.Id
left join Units BSU on SU.BaseUnitId = BSU.Id
left join ArticleCalculationLines ACL on CL.id = ACL.CalculationLineId 
left join Articles A on ACL.ArticleId = A.Id

where CH.id = 16

