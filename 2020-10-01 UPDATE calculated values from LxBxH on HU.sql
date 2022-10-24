BEGIN TRANSACTION


UPDATE HU set 
HU.BaseArea = ROUND(((HU.Length/1000.00 * HU.Width/1000.00)),5)
,HU.Surface = ROUND(2*(
    ((HU.Length/1000.00 * HU.Width/1000.00))
    +
    ((HU.Length/1000.00 * HU.Height/1000.00))
    +
    ((HU.Width/1000.00 * HU.Height/1000.00))
    ) ,5)
,HU.Volume = ROUND((HU.Length/1000.00 * HU.Width/1000.00 * HU.Height/1000.00),5)


from HandlingUnit HU
inner join BusinessUnitPermission BUP on HU.Id = BUP.HandlingUnitId --and BUP.BusinessUnitId = (select id from BusinessUnit where name = 'KRONES GLOBAL')

where 

ROUND(((HU.Length/1000.00 * HU.Width/1000.00)),5) - HU.BaseArea not between -0.1 and 0.1
OR
ROUND(2*(((HU.Length/1000.00 * HU.Width/1000.00))+((HU.Length/1000.00 * HU.Height/1000.00))+((HU.Width/1000.00 * HU.Height/1000.00))),5) - HU.Surface not between -0.1 and 0.1
OR

ROUND((HU.Length/1000.00 * HU.Width/1000.00 * HU.Height/1000.00),5) - HU.Volume not between -0.1 and 0.1


COMMIT
