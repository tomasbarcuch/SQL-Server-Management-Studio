
begin TRANSACTION
--update BU set BU.ReportSubfolder =
select BU.[Type],BU.name,BU.ReportSubfolder,
case BU.type
when 0 then NULL
when 1 then NULL
when 3 then NULL
else '/'+replace(BU.name,' ','_')
end as NewFolder,
'update BusinessUnit set ReportSubfolder = '''+case BU.type
when 0 then NULL
when 1 then NULL
when 3 then NULL
else '/'+replace(BU.name,' ','_') 
end+''''+' where name = '''+ BU.Name+''''
from businessunit BU 

where type in (2) and

disabled = 0
and ReportSubfolder <> '/TESTING'
order by BU.Name

ROLLBACK

begin TRANSACTION
select DT.filename,
--update DocumentTemplate set filename =  

REPLACE(
    DT.Filename,
    left(replace(DT.filename,'/Reports/PackCenter/PRD/',''),charindex('/',replace(DT.filename,'/Reports/PackCenter/PRD/',''))),
''
    )



from DocumentTemplate DT
where disabled = 0 and ReportType = 1 and DT.Filename not like '%TESTING%'
    AND
    DT.filename <>
REPLACE(
    DT.Filename,
    left(replace(DT.filename,'/Reports/PackCenter/PRD/',''),charindex('/',replace(DT.filename,'/Reports/PackCenter/PRD/',''))),
''
    )

ROLLBACK


--update BusinessUnit set ReportSubfolder = '/Krauss_Maffei_SK' where name = 'Krauss Maffei SK'

begin transaction
--update documenttemplate set filename =
select
 replace(filename,'Vrutky_SK','Krauss_Maffei_SK') from DocumentTemplate where [FileName] like '/Reports/PackCenter/PRD/Vrutky_SK%'
COMMIT