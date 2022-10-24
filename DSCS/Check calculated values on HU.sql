

select
BU.Name
,U.LOGIN
,CONVERT(datetime, 
               SWITCHOFFSET(CONVERT(datetimeoffset, 
                                    HU.Created), 
                            DATENAME(TzOffset, SYSDATETIMEOFFSET()))) 
       AS Created
,HU.Code 
,HU.Length
,HU.Width
,HU.Height
,HU.BaseArea
,ROUND(((HU.Length/1000.00 * HU.Width/1000.00)),5) BaseAreaCalc
,HU.Surface
,ROUND(2*(
    ((HU.Length/1000.00 * HU.Width/1000.00))
    +
    ((HU.Length/1000.00 * HU.Height/1000.00))
    +
    ((HU.Width/1000.00 * HU.Height/1000.00))
    ) ,5) SurfaceCalc
,HU.Volume
,ROUND((HU.Length/1000.00 * HU.Width/1000.00 * HU.Height/1000.00),5) VolumeCalc


from HandlingUnit HU
inner join BusinessUnitPermission BUP on HU.Id = BUP.HandlingUnitId
--and BUP.BusinessUnitId = (select id from BusinessUnit where name = 'KRONES GLOBAL')
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id and BU.[Type] = 2 
inner join [User] U on HU.CreatedById = U.Id

where 


ROUND(((HU.Length/1000.00 * HU.Width/1000.00)),5) - HU.BaseArea not between -0.1 and 0.1
OR
ROUND(2*(
    ((HU.Length/1000.00 * HU.Width/1000.00))
    +
    ((HU.Length/1000.00 * HU.Height/1000.00))
    +
    ((HU.Width/1000.00 * HU.Height/1000.00))
    ) ,5) - HU.Surface not between -0.1 and 0.1
OR
ROUND((HU.Length/1000.00 * HU.Width/1000.00 * HU.Height/1000.00),5) - HU.Volume not between -0.1 and 0.1


