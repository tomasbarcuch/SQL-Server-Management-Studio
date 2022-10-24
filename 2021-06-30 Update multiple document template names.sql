BEGIN TRANSACTION
UPDATE  DocumentTemplate  SET 
Name = CONCAT(dt.Name , (SELECT COUNT(*) FROM ( SELECT * FROM DocumentTemplate ) AS sub  WHERE (sub.Name = dt.Name) AND (sub.Id > dt.Id)  )) 
, Description = CONCAT(dt.description , ' {RENAME}' )
FROM  DocumentTemplate AS dt
WHERE 0 < (SELECT COUNT(*) FROM ( SELECT* FROM DocumentTemplate ) AS sub  WHERE (sub.Name = dt.Name) AND (sub.Id > dt.Id)  )

COMMIT

