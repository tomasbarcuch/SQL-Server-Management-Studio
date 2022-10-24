SELECT 
dbo.ShipmentHeader.LoadingDate,
CONVERT(datetime, 
               SWITCHOFFSET(CONVERT(datetimeoffset, 
                                    dbo.ShipmentHeader.LoadingDate), 
                            DATENAME(TzOffset, SYSDATETIMEOFFSET()))) 
       AS LoadingDateInLocalTime
       ,GETUTCDATE()
       ,GETDATE()
       ,DATEDIFF(HOUR,GETUTCDATE(),GETDATE())
       ,DATEADD(HOUR,DATEDIFF(HOUR,GETUTCDATE(),GETDATE()),dbo.ShipmentHeader.LoadingDate)
FROM dbo.ShipmentHeader
