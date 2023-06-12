begin TRANSACTION
update U set U.DisplayUOMId = 'eeee64b5-3ae8-4082-a415-d79a34019022'
--select U.Login, UOM.Code, 'eeee64b5-3ae8-4082-a415-d79a34019022', BU.Name 
from [User] U 
inner join DisplayUOM UOM on U.DisplayUOMId = UOM.Id
inner join BusinessUnit BU on U.LastBusinessUnitId = BU.id
where BU.Name = 'Deufol Hub Houston' and UOM.Code <> 'IN x YD x LB x BBL (US)'

ROLLBACK
 
begin transaction
Update U set U.DisplayUOMId = 'b095697d-51bd-4b51-8379-42194524b5d3' from [User] U where U.Login in 
('a.kourlopoulos',
'scott.stillman',
'brian.throckmorton',
'danny.tschochner',
'erkan.guelabi',
'florian.muehlthaler',
'florian.wein',
'mark.jacob',
'jesse.villarreal',
'chad.asmus',
'michael.dernbach',
'michael.galaz',
'orlando.smith',
'christoph.muhrer',
'cody.claassen',
'pablo.rivera',
'stefan.sesselmann',
'jeremy.eide',
'adrian.hoechter')

Rollback