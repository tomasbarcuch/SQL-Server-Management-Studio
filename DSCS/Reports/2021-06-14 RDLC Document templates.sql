select * from DocumentTemplate 
--where ReportType = 1 
order by Name

select * from DocumentTemplateSubreport
where DocumentTemplateId in (select id from DocumentTemplate 
where ReportType = 0
)