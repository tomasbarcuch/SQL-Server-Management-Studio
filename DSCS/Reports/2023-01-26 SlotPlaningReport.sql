select 
L.Code Location
,Z.Name Zone
,B.Code Bin
,B.MaximumVolume
,B.Length*B.Width as MaximumBaseArea
,B.[Description] BinDescription, B.Priority, B.Empty
,BRH.[Description]
,BRH.ValidFrom
,BRH.ValidTill
,S.Name Status
, CASE WHEN B.Empty = 1 AND S.Color IS NULL THEN '#ffffff' ELSE
CASE WHEN B.Empty = 0 AND S.Color IS NULL THEN '#a3ffa1' ELSE S.Color END END Color

,UsedArea = 
ISNULL((select SUM(HU.BaseArea) as BaseArea from HandlingUnit HU where HU.ActualBinId = B.Id group by HU.ActualBinId
UNION
select SUM(LP.BaseArea) as BaseArea from LoosePart LP where LP.ActualBinId = B.Id AND LP.ActualHandlingUnitId IS NULL group by LP.ActualBinId
 ),0)
,ISNULL(BHUS.[BinContent],'')+' '+ISNULL(BLPS.[BinContent],'') BinContent
,Getdate() ActualDate
 from 
Bin B
LEFT JOIN BinReservationHeader BRH on B.Id = BRH.BinId
INNER JOIN [Location] L on B.LocationId = L.Id and B.LocationId = (select id from Location where code = 'Wallmann Terminal')
LEFT JOIN ZONE Z on B.ZoneId = Z.Id
LEFT JOIN Status S on BRH.StatusId = S.Id 
LEFT  JOIN (      SELECT 
   B.Id,
(SELECT ' '+ CASE WHEN BU.Name = 'DEUFOL CUSTOMERS' THEN LEFT(DV.[Description],5) ELSE LEFT(BU.Name,5) END+' ['+CAST(Count(HU.Id) as VARCHAR)+']'
    FROM HandlingUnit HU
    inner join BusinessUnitPermission BUP on HU.id = BUP.HandlingUnitId
    inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id and BU.Type = 2 AND BU.[Disabled] = 0
    LEFT JOIN EntityDimensionValueRelation EDVR on HU.Id = EDVR.EntityId
    LEFT JOIN DimensionValue DV on EDVR.DimensionValueId = DV.Id
    LEFT JOIN Dimension D on DV.DimensionId = D.Id
    WHERE  D.Name = 'Customer'
    GROUP BY HU.ActualBinId ,BU.Name,DV.[Description]
    FOR XML PATH('')) [BinContent]
FROM Bin B
WHERE B.EnableReservation = 1
GROUP BY B.Id
      
) BHUS ON B.id = BHUS.Id

LEFT  JOIN (      SELECT 
   B.Id,
(SELECT ' '+ CASE WHEN BU.Name = 'DEUFOL CUSTOMERS' THEN LEFT(DV.[Description],5) ELSE LEFT(BU.Name,5) END+' ['+CAST(Count(LP.Id) as VARCHAR)+']'
    FROM LoosePart LP
    inner join BusinessUnitPermission BUP on LP.id = BUP.LoosePartId
    inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id and BU.Type = 2 AND BU.[Disabled] = 0
    LEFT JOIN EntityDimensionValueRelation EDVR on LP.Id = EDVR.EntityId
    LEFT JOIN DimensionValue DV on EDVR.DimensionValueId = DV.Id
    LEFT JOIN Dimension D on DV.DimensionId = D.Id
    WHERE  D.Name = 'Customer'
    GROUP BY ActualBinId,BU.Name,DV.[Description]
    FOR XML PATH('')) [BinContent]
FROM Bin B
WHERE B.EnableReservation = 1
GROUP BY B.Id
) BLPS ON B.id = BLPS.Id 

where B.EnableReservation = 1 and B.[Disabled] = 0 and (BRH.ValidTill > Getdate() OR BRH.ValidTill IS NULL)
order by B.Priority,B.Code