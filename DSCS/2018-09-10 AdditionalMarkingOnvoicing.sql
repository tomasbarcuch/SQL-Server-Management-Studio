SELECT 
DB_NAME() AS 'Current Database',
BU.name as ClientBusinessName,
convert(varchar,min("WE"."Created"),104)  AS 'Date'
,"HU"."Code" as 'HU'
,"CV_MAR"."Content" as 'Markierungstyp'
,"CV_KA"."Content" as 'Kistenart'
,"DFKV"."Content" AS 'Kennwort'
,"DFPV"."Content" AS 'P-Linie'
,"DV"."Content" AS 'Projekt'
,"HU"."Length" AS 'Lange'
,"HU"."Width" AS 'Breite'
,"HU"."Height" AS 'Hohe'
,"HU"."Netto" AS 'Netto'
,"HU"."Brutto" AS 'Brutto'
 ,"HU"."ColliNumber" AS 'Kolli-Nr.'
FROM 
 "WorkflowEntry" as "WE"
 LEFT JOIN  "Status" AS "WS" ON   "WE"."StatusId" = "WS"."Id" 
 LEFT JOIN  "ServiceLine" AS "SL" ON "WE"."EntityId" = "SL"."Id"
left join (SELECT "ServiceLineId","BusinessUnitId"  FROM "BusinessUnitPermission" WHERE "ServiceLineId" is not null) "BUPsl" on "SL"."Id" = "BUPsl"."ServiceLineId"
left join BusinessUnit BU on BUPsl.BusinessUnitId = BU.Id
 LEFT JOIN  "HandlingUnit" AS "HU" ON  "HU"."Id" = "SL"."EntityId"
left join (SELECT "HandlingUnitId","BusinessUnitId"  FROM "BusinessUnitPermission" WHERE "HandlingUnitId" is not null) "BUPhu" on "HU"."id" = "BUPhu"."HandlingUnitId"
 LEFT JOIN  "ServiceType" AS "ST" ON  "SL"."ServiceTypeId" = "ST"."Id"
 LEFT JOIN "EntityDimensionValueRelation"AS EDVR ON "EDVR"."EntityId" = "HU"."Id"
 LEFT JOIN "DimensionValue"AS DV ON "DV"."ID" = "EDVR"."DimensionValueId"
 LEFT JOIN "Dimension"AS D ON "D"."ID" = "DV"."DimensionId"

LEFT JOIN "DimensionField"AS DFK ON "DFK"."DimensionId" = "D"."Id" AND "DFK"."Name" IN ('Kennwort')
LEFT JOIN "DimensionFieldValue"AS DFKV ON "DFKV"."DimensionFieldId" = "DFK"."Id" AND "DV"."Id" = "DFKV"."DimensionValueId"

LEFT JOIN "DimensionField"AS DFP ON "DFP"."DimensionId" = "D"."Id" AND "DFP"."Name" IN ('Produktlinie')
LEFT JOIN "DimensionFieldValue"AS DFPV ON "DFPV"."DimensionFieldId" = "DFP"."Id" AND "DV"."Id" = "DFPV"."DimensionValueId"
 
inner JOIN customfield CF_MAR on BUPsl.BusinessUnitId  = CF_MAR.clientbusinessunitid and CF_MAR.name = 'Markierung'
LEFT JOIN customvalue CV_MAR on CV_MAR.customfieldid = CF_MAR.Id and CV_MAR.EntityId = sl.Id
 
inner JOIN customfield CF_KA on BUPhu.BusinessUnitId = CF_KA.clientbusinessunitid and CF_KA.name = 'Macros'
LEFT JOIN customvalue CV_KA on CV_KA.customfieldid = CF_KA.Id and CV_KA.EntityId = hu.Id
 
 WHERE 
 "WE"."Entity" = '48' 
 and "SL"."Entity" = '11'
 and "WS"."Name" = 'SlStart' 
 and "ST"."Code" = 'Nachträgliche Markierung'
 --and "WE"."Created" >= $P{Von} 
 --and "WE"."Created" <=  $P{Bis} 
 and WE.Created between '2021-05-01' and '2021-05-31'

 GROUP BY
 "BU"."Name",
 "WE"."Created"
 ,"HU"."Code"
 ,"CV_MAR"."Content"
 ,"CV_KA"."Content"
  ,"DV"."Content"
 ,"DFKV"."Content"
 ,"DFPV"."Content"
 ,"HU"."Length"
 ,"HU"."Width"
 ,"HU"."Height"
 ,"HU"."Netto"
 ,"HU"."Brutto"
 ,"HU"."ColliNumber"