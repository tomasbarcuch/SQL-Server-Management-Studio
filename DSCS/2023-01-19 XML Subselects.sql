SELECT 
   HU.Id,
   (SELECT ';' + LP.Code
    FROM LoosePart LP
    WHERE LP.ActualHandlingUnitId = HU.Id
    FOR XML PATH('')) [HandlingUnitContent]
FROM HandlingUnit HU
GROUP BY HU.Id

SELECT 
   B.Id,
   (SELECT ';' + HU.Code
    FROM HandlingUnit HU
    WHERE HU.ActualBinId = B.Id
    FOR XML PATH('')) [HandlingUnitContent]
FROM Bin B
GROUP BY B.Id



SELECT 
   TOPHU.Id,
   (SELECT ';' + HU.Code
    FROM HandlingUnit HU
    WHERE HU.TopHandlingUnitId = TOPHU.Id
    FOR XML PATH('')) [HandlingUnitContent]
FROM HandlingUnit TOPHU
GROUP BY TOPHU.Id

SELECT 
   HU.Id,
   (SELECT ';' + B.Code
    FROM LoosePart LP
    LEFT JOIN BIN B on LP.ActualBinId = B.Id
    WHERE LP.ActualHandlingUnitId = HU.Id
    FOR XML PATH('')) [HandlingUnitContent]
FROM HandlingUnit HU
GROUP BY HU.Id




SELECT 
 distinct DV.ID, 
            STUFF((select distinct ',' + IsNull(LP.Code, '')
            from LoosePart LP
            inner join EntityDimensionValueRelation EDVR on LP.Id = EDVR.EntityId
            inner join DimensionValue DVD ON DVD.Id = EDVR.DimensionValueId
            where DVD.ID = DV.ID
            group by DVD.ID, LP.Code
            for xml path('')), 1, 1, '') [LooseParts]

  from DimensionValue DV
  inner join Dimension D on DV.DimensionId = D.Id and D.Name = 'ReceiptGoods'
  inner join BusinessUnitPermission BUP on D.Id = BUP.DimensionId and BUP.BusinessUnitId = (select id from BusinessUnit where name = 'Siemens Duisburg')



,(Select distinct IsNull(isnull(data.werte, ''), '')  from
        (select distinct DV.ID, 
            stuff((select distinct ',' + IsNull(HUD.Code , '')
            from HandlingUnit HUD
            inner join EntityDimensionValueRelation EDVR on HUD.Id = EDVR.EntityId
            inner join DimensionValue DVD ON DVD.Id = EDVR.DimensionValueId
            where DVD.ID = DV.ID
            group by DVD.ID, HUD.Code
            for xml path('')), 1, 1, '') as werte
        from DimensionValue DV)
    as data where data.ID = DV.ID) as 'Externe WA-Nummer'