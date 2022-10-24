SELECT 
"SL"."Description",
"CBU"."Name",
"PBU"."Name" AS 'BU',
"ST"."Code" AS 'ST Code',
"ST"."Description" AS 'ST Description',
"HU"."Code" AS 'HU Code',
"HU"."Description" AS 'HU Descritpion',
"S"."Name" AS 'Status', 
"DFK"."Name" AS 'DimFieldName',
"DFKV"."Content" AS 'Kennwort'
,"WE"."Created" AS 'Created'
,"DV"."Content" AS 'Projekt'
,"CV_MAR"."Content" as 'Markierungstyp'

FROM 
"ServiceLine" AS SL
INNER JOIN "ServiceType"AS ST ON "ST"."Id" = "SL"."ServiceTypeId"
INNER JOIN "HandlingUnit" AS HU ON "HU"."Id" = "SL"."EntityId" AND "SL"."Entity" = 11
INNER JOIN "BusinessUnit"AS CBU ON "CBU"."Id" = "SL"."ClientBusinessUnitId"
INNER JOIN "BusinessUnit"AS PBU ON "PBU"."Id" = "SL"."PackerBusinessUnitId"
INNER JOIN "WorkflowEntry" AS WE ON "SL"."StatusID" = "WE"."StatusId"
INNER JOIN "Status"AS S ON "S"."Id" = "WE"."StatusId"

LEFT JOIN "EntityDimensionValueRelation"AS EDVR ON "EDVR"."EntityId" = "HU"."Id"
LEFT JOIN "DimensionValue"AS DV ON "DV"."ID" = "EDVR"."DimensionValueId"
LEFT JOIN "Dimension"AS D ON "D"."ID" = "DV"."DimensionId"
LEFT JOIN "DimensionField"AS DFK ON "DFK"."DimensionId" = "D"."Id" AND "DFK"."Name" IN ('Kennwort')
LEFT JOIN "DimensionFieldValue"AS DFKV ON "DFKV"."DimensionFieldId" = "DFK"."Id" AND "DV"."Id" = "DFKV"."DimensionValueId"
LEFT JOIN customfield CF_MAR on sl.ClientBusinessUnitId = CF_MAR.clientbusinessunitid and CF_MAR.name = 'Marking type'
LEFT JOIN customvalue CV_MAR on CV_MAR.customfieldid = CF_MAR.Id and CV_MAR.EntityId = sl.Id

WHERE
"CBU"."Name" = 'SIEMENS Berlin'
AND "S"."Name" = 'SlStart'
AND "ST"."Code" = 'Nachträgliche Markierung'
AND "WE"."Created" >=$P{Von} 
AND "WE"."Created" <=$P{Bis} 

GROUP BY
"SL"."Description",
"CBU"."Name",
"PBU"."Name",
"ST"."Code",
"ST"."Description",
"HU"."Code",
"HU"."Description",
"S"."Name",
"DFK"."Name",
"DFKV"."Content"
,"WE"."Created"
,"DV"."Content"
,"CV_MAR"."Content"

