/****** Script for SelectTopNRows command from SSMS  ******/
SELECT *
  FROM DimensionFieldValue dfv
  inner join dimensionfield df on dfv.dimensionfieldid = df.id
  inner join dimension d on df.dimensionid = d.id

  
     where DimensionFieldId = 'FF69ECE4-C69D-4CFD-A319-0552A8DA1B83' --df.name = 'Kennwort'
  --where content like 'Banklongsuan 115kV'
