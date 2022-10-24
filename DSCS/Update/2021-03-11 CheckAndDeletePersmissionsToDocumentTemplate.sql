
--delete from BusinessUnitPermission where id in (

select BUP.Id
,BU.Name, BU.[Type], DT.FILENAME, DT.NAme
 from BusinessUnitPermission BUP
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id
inner join DocumentTemplate DT on BUP.DocumentTemplateId = DT.Id

where BUP.DocumentTemplateId in
(select id from documenttemplate where 
name in ( 
'REP-0055'
 ) 
--    and filename like '%Krones%'  
    
  
    )

--and BU.type = 0 and BU.name  in ('Deufol Frankenthal')
--)
--order by BU.Name



