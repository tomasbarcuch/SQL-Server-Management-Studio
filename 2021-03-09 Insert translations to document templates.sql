begin TRANSACTION


insert into dbo.Translation (id,Language,Entity,[Column],Text,CreatedById,UpdatedById,Created,Updated,EntityId) 

select newid(),'de','34','Description', 
DT.Description as text,
(select id from [User] where login = 'tomas.barcuch'),(select id from [User] where login = 'tomas.barcuch'),getdate(),getdate(), 
DT.id as EntityId




from documenttemplate DT

left join Translation T on DT.Id = T.EntityId and T.[Column] = 'Description' and T.language = 'de'

where disabled = 0   and T.text is null --and ReportType = 1

ROLLBACK