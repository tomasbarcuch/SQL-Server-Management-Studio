
Select 
    lp.code
    ,lpcf.Position
    ,lpcf.[Position Number] as 'Positionsnummer'
    ,c.CommissionNr as 'Auftrag'
    ,O.OrderNr as 'Order'
    ,lpcf.STPOSNR
    ,'ja' as 'Lieferrelevante Position'
    ,hu.ColliNumber as 'Colli-Nummer'
    ,lpcf.MaterialNo as 'Material'
    ,lp.[Description] as 'Materialkurztext'
    ,wc.QuantityBase as 'Menge'
    ,uom.Code as 'Basismengeneinheit'
    ,SHCF.TruckNumber as 'Lieferung'
    ,lpcf.ObjectProcEng as 'Objekt Verfahrenstechnik'
    ,case when hut.Container = 1 THEN huc.ColliNumber else '' end as 'Pack. Stufe 1' 
    ,hu.ColliNumber as 'Pack. Stufe 2'
    ,hu.ColliNumber as 'Pack. Stufe 3'
    ,lpcf.[BZO inherited] as 'BZO vererbt'
    ,lpcf.Cause as 'Verursacher'
    ,case when hut.Container = 1 THEN huc.ColliNumber else '' end as 'Cont-Nr Cont List'
    ,case when hut.Container = 1 THEN huc.[Description] else '' end as 'Container Cont List'
    ,case when hut.Container = 1 THEN huc.Brutto else 0.0 end as 'Brutto / kg Cont List'
    ,case when hut.Container = 1 THEN huc.Netto else 0.0 end as 'Netto / kg Cont List'
    ,case when hut.Container = 1 THEN huc.Length else 0.0 end as 'Länge / cm Cont List'
    ,case when hut.Container = 1 THEN huc.Width else 0.0 end as 'Breite / cm Cont List'
    ,case when hut.Container = 1 THEN huc.Height else 0.0 end as 'Höhe / cm Cont List'
    ,case when hut.Container = 1 THEN huc.[Description] else '' end as 'Container-Nr List'
    ,case when hut.Container = 1 THEN hut.Code else '' end as 'Cont-Art Cont List'
    ,'' as 'Lief Cont List' 
    ,case when hut.Container = 1 THEN HUcCF.USSealNo else '' end as 'Siegel-Nr Cont List'
    ,case when hut.Container = 1 THEN huc.Weight else 0.0 end as 'Tara/SH Cont List'
    ,hu.ColliNumber as 'Colli-Nr Colli List'
    ,hutb.Code as 'Colli-Art Colli List'
    ,hu.Brutto as 'Brutto / kg Colli List'
    ,hu.Netto as 'Netto / kg Colli List'
    ,hu.Length as 'Länge / cm Colli List'
    ,hu.Width as 'Breite / cm Colli List'
    ,hu.Height as 'Höhe / cm Colli List'
    ,'' as 'Podest Colli List'
    ,case when hut.Container = 1 THEN 
        huc.ColliNumber
    else '' end as 'Cont#-Nr Colli List'

    ,'' as 'Lief Colli List' 
    ,lpcf.[BZO inherited] as 'BZO Colli List'
    ,c.CommissionNr as 'Netzplan Colli List'
    ,c.Commission as 'Notiz Colli List'
    ,lpcf.Position as 'Position Colli List'
    ,isnull(T.Text,S.name) as Status_lp
      ,isnull(Thu.Text,Shu.name) as Status_hu
        ,isnull(Thuc.Text,Shuc.name) as Status_con
,L.code as Location
,Z.name as Zone
,B.code as Bin
,HU.Code HandlingUnitCode
,HUC.Code ContainerCode
from LoosePart as lp
    inner join status S on LP.statusid = S.id
    left join translation T on S.id = T.EntityId and T.Language = 'en'
    inner join UnitOfMeasure as uom on uom.id = lp.BaseUnitOfMeasureId
    left join WarehouseContent as wc on wc.LoosePartId = lp.Id 
    left join HandlingUnit as hu on lp.ActualHandlingUnitId = hu.Id
    left join status Shu on HU.statusid = Shu.id
    left join translation Thu on Shu.id = Thu.EntityId and Thu.Language = 'en'
    left join HandlingUnitType as hutb on hu.TypeId = hutb.Id
    left join HandlingUnit as huc on lp.TopHandlingUnitId = huc.Id
    left join status Shuc on huc.statusid = Shuc.id
     left join translation Thuc on Shuc.id = Thuc.EntityId and Thuc.Language = 'en'
    left join HandlingUnitType as hut on huc.TypeId = hut.Id and hut.Container = 1
    inner join BusinessUnitPermission as bup on bup.LoosePartId = lp.id and bup.BusinessUnitId = (select id from businessunit where name = 'Krones AG')
left join [Location] L on lp.ActualLocationId = L.Id
left join Zone Z on lp.ActualZoneId = Z.Id
left join Bin B on LP.ActualBinId = B.Id

left join (
    
select SL.ShipmentHeaderId, SL.id slid, isnull(SL.LoosePartid,LPHU.lpid) as LoosePartID from 
ShipmentLine SL
inner join ShipmentHeader SH on SL.ShipmentHeaderId = SH.id and SH.ToLocationId = (Select id from location where code = 'Port of Santos')
inner join businessunitpermission BUP on SL.id = BUP.ShipmentLineID and BUP.BUsinessUnitID = (SELECT id from businessUnit where name = 'Krones AG' )
left join (select id lpid, TopHandlingUnitId from LoosePart) LPHU on SL.HandlingUnitId = LPHU.TopHandlingUnitId
) SLHU on lp.id = SLHU.LoosePartID
left join ShipmentHeader SH on SLHU.ShipmentHeaderId = SH.id 

left join (
SELECT
CustomField.Name as CF_Name, 

CV.Content as CV_Content,
CV.EntityId as EntityID
FROM CustomField 
INNER JOIN CustomValue CV ON (CustomField.Id = CV.CustomFieldId)
where name in ('TruckNumber') and CV.Entity = 31
) SRC
PIVOT (max(src.CV_Content) for src.CF_Name  in ([TruckNumber])
        ) as SHCF on SH.id = SHCF.EntityID

    inner join (SELECT
            CustomField.Name as CF_Name, 
            CV.Content as CV_Content,
            CV.EntityId as EntityID
        FROM CustomField 
            INNER JOIN CustomValue CV ON (CustomField.Id = CV.CustomFieldId)
        where 
            name in ('Position','Position Number','STPOSNR','Comments','MaterialNo','ObjectProcEng','BZO inherited','Cause') and CV.Entity = 15
    ) SRC
    PIVOT (max(src.CV_Content) for src.CF_Name  in ([Position],[Position Number],[STPOSNR],[Comments],[MaterialNo],[ObjectProcEng],[BZO inherited],[Cause])
    	
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
        
        
    inner join  (
select
DV.Content 'OrderNr',
DV.[Description] 'Order', 
D.[Description] Dimension,
EDVR.EntityId,
DF.Name, 
DFV.Content
from DimensionField DF
inner join DimensionFieldValue DFV on Df.id = DFV.DimensionFieldId
inner join EntityDimensionValueRelation EDVR on DFV.DimensionValueId = EDVR.DimensionValueId
inner join DimensionValue DV on EDVR.DimensionValueId = DV.Id
inner join Dimension D on DF.DimensionId = D.id and D.name = 'Order'
where 
DF.name in ('Comments','DateOfPlannedDeliveryToCustomer'))SRC
pivot (max(SRC.Content) for SRC.Name   in ([Comments],[DateOfPlannedDeliveryToCustomer])) as O on lp.id = O.EntityID
        
      
        
where O.OrderNr  =  '0007029952' --$P{Order}
and (SH.Type is null or SH.Type = 0)
and s.Name not in ('Canceled','Canceled2')


