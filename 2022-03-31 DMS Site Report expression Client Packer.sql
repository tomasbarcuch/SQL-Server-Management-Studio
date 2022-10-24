


SELECT 

      ISNULL([BU].[DMSSiteName],(Select DMSSiteName from BusinessUnit where id =  (select id from BusinessUnit where name = 'Deufol Nürnberg') )) as [DMSSiteName]
      ,CASE WHEN LEN([BU].[DMSSiteName]) = 0 then (Select DMSSiteName from BusinessUnit where id =  (select id from BusinessUnit where name = 'Deufol Nürnberg')) else [BU].[DMSSiteName]  END
     
  FROM [HandlingUnit] as [ENT]

INNER JOIN [BusinessUnitPermission] [BUP] on [ENT].[id] = [BUP].[HandlingUnitId] and [BUP].[BusinessUnitId] =(select id from BusinessUnit where name = 'DEUFOL CUSTOMERS')
INNER join [BusinessUnit] as [BU] on [BUP].[BusinessUnitId] = [BU].[Id] and [BU].[Type]='2'