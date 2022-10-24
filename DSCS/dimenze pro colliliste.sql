/****** Script for SelectTopNRows command from SSMS  ******/
SELECT DV.[Description],lp.*
  FROM 
  
  loosepart LP
 inner join dbo.EntityDimensionValueRelation EDVR on lp.ID = EDVR.EntityId
 inner join dbo.DimensionValue DV on EDVR.DimensionValueId =  DV.Id
 inner join dbo.DimensionField DF on DV.DimensionId = DF.DimensionId and DF.id = 'ff69ece4-c69d-4cfd-a319-0552a8da1b83'
 inner join dbo.DimensionFieldValue DFV on DF.Id = DFV.DimensionFieldId and DFV.DimensionValueId = DV.Id
 inner join dbo.Dimension D on DV.DimensionId = D.Id


     where lp.id = '17fe550d-f84c-44e7-8309-b37d661aeec3'
     
   --  DimensionFieldId = 'FF69ECE4-C69D-4CFD-A319-0552A8DA1B83' --df.name = 'Kennwort'
  --where content like 'Banklongsuan 115kV'
  
