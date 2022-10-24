SELECT lower([ent].[Id]) Id
      ,[ent].[Code]
      ,[Description]
      ,[Dimensions].Client as [Customer]
      ,[Dimensions].[Project]
      ,[Dimensions].[Order]
      ,[Length]
      ,[Height]
      ,[Width]
      ,[Weight]
      ,[Volume]
      ,[Surface]
      ,[BaseArea]
      ,[SerialNo]
      ,[LotNo]
      ,[BU].[Name]
      ,[BU].[DMSSiteName]
      ,'Packer' = (select name from BusinessUnit where id = (select id from BusinessUnit where name = 'Deufol Sankt Pölten'))
  FROM [DFCZ_OSLET].[dbo].[LoosePart] [ent]
  


inner join  (
select D.name, T.text+': '+DV.[Description]+' ['+DV.Content+']' as Content, edvr.EntityId from DimensionValue DV 
inner join Dimension D on DV.DimensionId = D.id
inner join BusinessUnitPermission BUP on D.id = BUP.DimensionId and BUP.BusinessUnitId = (select [Id] from [BusinessUnit] where [Name] = 'Sonstige Kunden - Sankt Pölten')
inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
left join DimensionField DF on D.id = DF.DimensionId
left join Translation T on D.Id = T.EntityId and T.[Language] = 'de'

where D.name in ('Client','Project','Order') and D.[Disabled] = 0
) SRC
PIVOT (max(src.Content) for src.Name  in ([Client],[Project],[Order])
        ) as Dimensions on ent.id = Dimensions.EntityId

inner join [BusinessUnitPermission] [BUP] on [ent].[Id]=[BUP].[LoosePartId] and BUP.BusinessUnitId = (select [Id] from [BusinessUnit] where [Name] = 'Sonstige Kunden - Sankt Pölten')
inner join [BusinessUnit] [BU] on [BU].[Id]=[BUP].[BusinessUnitId] and [BU].[Type]='2'


where ent.id = '87be2c1d-4900-46a8-bcd8-5295db642002'

--WHERE $X{IN, [ent].[Id], HandlingUnitIDs}