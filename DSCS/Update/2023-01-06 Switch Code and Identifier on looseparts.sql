BEGIN TRANSACTION
CREATE TABLE #TEMP (LPID UNIQUEIDENTIFIER,CODE NVARCHAR(20),LPIID UNIQUEIDENTIFIER, IDENTIFIER NVARCHAR(20))
INSERT INTO #TEMP 
/*
select LP.Id LPID, LP.Code, LPI.Id LPIID, LEFT(LPI.Identifier,20) from LoosePart LP
inner join BusinessUnitPermission BUp on LP.id = BUP.LoosePartId and BUP.BusinessUnitId = (Select id from BusinessUnit where name = 'Siemens Duisburg')
left join LoosePartIdentifier LPI on LP.Id = LPI.LoosePartId
Where LP.Code like '7%' and (LEN(LPI.Identifier)> 10 and LPI.Identifier like 'B%')
*/


select  LP.Id LPID, LP.Code, LPI.Id LPIID, LEFT(LPI.Identifier,20) from LoosePart LP
inner join BusinessUnitPermission BUp on LP.id = BUP.LoosePartId and BUP.BusinessUnitId = (Select id from BusinessUnit where name = 'Siemens Duisburg')
left join LoosePartIdentifier LPI on LP.Id = LPI.LoosePartId
Where LP.Code like 'B%'and LPI.Identifier like 'B%' and LPI.Identifier <> LP.Code



--SELECT  * 
UPDATE LP SET LP.Code = #TEMP.IDENTIFIER
from #TEMP
INNER JOIN LoosePart LP on #TEMP.LPID = LP.Id
WHERE LP.Code <> #TEMP.IDENTIFIER

--SELECT  * 
UPDATE LPI SET LPI.Identifier = #TEMP.CODE
from #TEMP
INNER JOIN LoosePartIdentifier LPI on #TEMP.LPIID = LPI.Id
WHERE LPI.Identifier <> #TEMP.CODE


select * from #TEMP

DROP TABLE #TEMP
ROLLBACK