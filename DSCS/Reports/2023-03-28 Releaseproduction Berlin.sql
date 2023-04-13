select 
BU.Name as Packer,
CL.Name,
HU.Surface  as 'Surface',
CASE REPLACE(HU.Macros,';','') 
WHEN 'ConPLY Kiste' THEN 'Non Wood'
ELSE 'OSB' END
Macros ,
S.Name Status,
CASE HU.ReleaseProduction
 WHEN  'fertigung_dtg_berlin' THEN 'Deufol Berlin'
 ELSE 'Externe Fertigung' END as 'Production'

from HandlingUnit HU 

INNER JOIN WorkflowEntry WFE ON HU.Id = WFE.EntityId AND WFE.WorkflowAction = 1 AND CAST(WFE.Created as DATE) <= '2023-03-28' --$P{ReportingDate}
INNER JOIN BusinessUnit BU on WFE.BusinessUnitId = BU.Id and BU.Name = 'Deufol Berlin'
INNER JOIN BusinessUnit CL on WFE.ClientBusinessUnitId = CL.Id
INNER JOIN [Status] S on WFE.StatusId = S.Id AND HU.StatusId = S.Id
