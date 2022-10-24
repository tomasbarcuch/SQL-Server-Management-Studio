use DFCZ_OSLET

Select 
    lp.code
    ,lpcf.Position
    ,lpcf.[Position Number] as Positionsnummer
    ,c.CommissionNr as Auftrag
    ,lpcf.STPOSNR
    ,'ja' as 'Lieferrelevante Position'
    ,hu.ColliNumber as 'Colli-Nummer'
    ,lpcf.MaterialNo as Material
    ,lp.[Description] as Materialkurztext
    ,wc.QuantityBase as Menge
    ,uom.Code as Basismengeneinheit
-- TODO
    ,'' as Lieferung -- TODO
    ,lpcf.ObjectProcEng as 'Objekt Verfahrenstechnik'
    ,case when hut.Container = 1 THEN
        huc.ColliNumber
    else NULL end as 'Pack. Stufe 1' -- Container ColliNr
    ,hu.ColliNumber as 'Pack. Stufe 2' -- Kiste ColliNr
    ,hu.ColliNumber as 'Pack. Stufe 3' -- Kiste ColliNr
    ,lpcf.[BZO inherited] as 'BZO vererbt'

    --Container Info
    ,case when hut.Container = 1 THEN huc.ColliNumber else NULL end as 'Cont-Nr Cont List'
    ,case when hut.Container = 1 THEN huc.[Description] else NULL end as 'Container Cont List'
    ,case when hut.Container = 1 THEN huc.Brutto else NULL end as 'Brutto / kg Cont List'
    ,case when hut.Container = 1 THEN huc.Netto else NULL end as 'Netto / kg Cont List'
    ,case when hut.Container = 1 THEN huc.Length else NULL end as 'Länge / cm Cont List'
    ,case when hut.Container = 1 THEN huc.Width else NULL end as 'Breite / cm Cont List'
    ,case when hut.Container = 1 THEN huc.Height else NULL end as 'Höhe / cm Cont List'
    ,case when hut.Container = 1 THEN huc.[Description] else NULL end as 'Container-Nr List'
    ,case when hut.Container = 1 THEN hut.Code else NULL end as 'Cont-Art Cont List'
-- TODO
    ,'' as 'Lief Cont List' -- TODO
    ,case when hut.Container = 1 THEN HUcCF.USSealNo else NULL end as 'Siegel-Nr Cont List'
    ,case when hut.Container = 1 THEN huc.Weight else NULL end as 'Tara/SH Cont List'

    --Crate Info
    ,hu.ColliNumber as 'Colli-Nr Colli List'
    ,hutb.Code as 'Colli-Art Colli List'
    ,hu.Brutto as 'Brutto / kg Colli List'
    ,hu.Netto as 'Netto / kg Colli List'
    ,hu.Length as 'Länge / cm Colli List'
    ,hu.Width as 'Breite / cm Colli List'
    ,hu.Height as 'Höhe / cm Colli List'
    ,'---' as 'Podest Colli List'
    ,case when hut.Container = 1 THEN 
        huc.ColliNumber
    else NULL end as 'Cont#-Nr Colli List' -- Container ColliNr
-- TODO
    ,'' as 'Lief Colli List' -- TODO
    ,lpcf.[BZO inherited] as 'BZO Colli List'
    ,c.CommissionNr as 'Netzplan Colli List'
    ,c.Commission as 'Notiz Colli List'
    ,lpcf.Position as 'Position Colli List'

from LoosePart as lp
    inner join UnitOfMeasure as uom on uom.id = lp.BaseUnitOfMeasureId
    left join WarehouseContent as wc on wc.LoosePartId = lp.Id -- and wc.LocationId = lp.ActualLocationId and wc.ZoneId = lp.ActualZoneId and wc.BinId = lp.ActualBinId
    left join HandlingUnit as hu on lp.ActualHandlingUnitId = hu.Id
    left join HandlingUnitType as hutb on hu.TypeId = hutb.Id
    left join HandlingUnit as huc on lp.TopHandlingUnitId = huc.Id
    left join HandlingUnitType as hut on huc.TypeId = hut.Id and hut.Container = 1
    inner join BusinessUnitPermission as bup on bup.LoosePartId = lp.id and bup.BusinessUnitId = 'e580c9b0-b4d9-4c86-93be-2de2c873ddff'

    left join (SELECT
            CustomField.Name as CF_Name, 
            CV.Content as CV_Content,
            CV.EntityId as EntityID
        FROM CustomField 
            INNER JOIN CustomValue CV ON (CustomField.Id = CV.CustomFieldId)
        where 
            name in ('Position','Position Number','STPOSNR','Comments','MaterialNo','ObjectProcEng','BZO inherited') and CV.Entity = 15
    ) SRC
    PIVOT (max(src.CV_Content) for src.CF_Name  in ([Position],[Position Number],[STPOSNR],[Comments],[MaterialNo],[ObjectProcEng],[BZO inherited])
        ) as LPCF on lp.id = LPCF.EntityID

    left join (SELECT
            CustomField.Name as CF_Name, 
            CV.Content as CV_Content,
            CV.EntityId as EntityID
        FROM CustomField 
            INNER JOIN CustomValue CV ON (CustomField.Id = CV.CustomFieldId)
        where 
            name in ('USSealNo') and CV.Entity = 11
    ) SRCh
    PIVOT (max(srch.CV_Content) for srch.CF_Name  in ([USSealNo])
        ) as HUcCF on huc.id = HUcCF.EntityID

    left join (select
            DV.Content CommissionNr,
            DV.[Description] Commission, 
            D.[Description] Dimension,
            EDVR.EntityId,
            DF.Name, 
            DFV.Content
        from DimensionField DF
            inner join DimensionFieldValue DFV on Df.id = DFV.DimensionFieldId
            inner join EntityDimensionValueRelation EDVR on DFV.DimensionValueId = EDVR.DimensionValueId
            inner join DimensionValue DV on EDVR.DimensionValueId = DV.Id
            inner join Dimension D on DF.DimensionId = D.id and D.name = 'Commission'
        where 
            DF.name in ('Plant','Comments','OrderPosition','Network')
    ) SRCc
    pivot (max(SRCc.Content) for SRCc.Name   in ([Plant],[Comments],[OrderPosition],[Network])
        ) as C on lp.id = C.EntityID
--where hut.Container = 1 