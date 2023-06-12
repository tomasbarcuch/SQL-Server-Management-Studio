SELECT
CAST(Data.Id as INT) Id
,CAST(Data.UserName as VARCHAR(20)) AS UserName
,CAST(Data.UserId as smallint) AS UserName
,CAST(Data.Language as varchar(2)) AS Language
,Data.ReportCode
,Data.ReportDescription
,Data.TextField
,CAST(Data.NumberField as DECIMAL) NumberField
,CAST(Data.DateField as datetime2) as DateField
,CAST(Data.BooleanField as bit) as BooleanField
 FROM (VALUES 
(1,'tomas.barcuch','011','de','REP-001','Report 001','žrádlo' COLLATE Latin1_General_CI_AS,121515,'2021-04-01','TRUE'),
(2,'tomas.pesko','012','en','REP-002','Report 002','přeska' ,546876.15,'1975-05-01','FALSE'),
(3,'ales.barcuch','013','cs','REP-003','Report 003','ůl a včela',1858766.156,'1995-08-09','FALSE'),
(4,'marek.pesko','014','hu','REP-004','Report 004','výběr',94840489.00,'1881-12-31','TRUE'),
(5,'david.duchon','015','fr','REP-005','Report 005','škatulář',5,'2000-06-30','FALSE'),
(6,'tomas.barcuch','011','de','REP-001','Report 001','žrádlo',12151,'2021-04-01','TRUE'),
(7,'tomas.pesko','012','en','REP-002','Report 002','přeska',546876.56,'1975-05-01','FALSE'),
(8,'ales.barcuch','013','cs','REP-003','Report 003','ůl a včela',1858766,'1995-08-09','FALSE'),
(9,'marek.pesko','014','hu','REP-004','Report 004','výběr',9484048.00,'1881-12-31','TRUE'),
(10,'david.duchon','015','fr','REP-005','Report 005','škatulář',5.01,'2000-06-30','FALSE')

 ) Data (Id , UserName, UserId, Language, ReportCode, ReportDescription, TextField, NumberField, DateField, BooleanField)