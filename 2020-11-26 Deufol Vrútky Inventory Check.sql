/*
BEGIN TRANSACTION
update CustomValue set content = '3'


where CustomFieldId = '0c6d71b6-7521-4175-85dc-e64bfb38e0c4'
and EntityId in (
    select LP.id from LoosePart LP
inner join CustomValue CV on LP.Id = CV.EntityId and CV.CustomFieldId = '6c9c4a35-b8c5-49a4-ac1a-1d5555ac7759' and CV.Content like '%AEF%'
inner join BusinessUnitPermission BUP on LP.id = BUP.LoosePartId and BUP.BusinessUnitId = (select id from BusinessUnit where name = 'Krauss Maffei SK') 
)

and content not in ('1','2','3')
ROLLBACK
*/
 
BEGIN TRANSACTION
update CustomValue set content = '2'
where CustomFieldId = '0c6d71b6-7521-4175-85dc-e64bfb38e0c4'
and EntityId in (
    select LP.id from LoosePart LP
inner join CustomValue CV on LP.Id = CV.EntityId and CV.CustomFieldId = '6c9c4a35-b8c5-49a4-ac1a-1d5555ac7759' and (
 CV.content LIKE '%Podvozok%' OR
 CV.content LIKE '%MB%' OR
 CV.content LIKE '%Schliesse%' OR
 (CV.content LIKE '%BWAP%' and LP.[Description] LIKE '6%') OR
 (CV.content LIKE '%Stuetze%' and LP.[Description] LIKE '6%') OR
 (CV.content LIKE '%FWAP%' OR LP.[Description] LIKE '6%') OR
  CV.content LIKE '%Paleta%' OR
   CV.content LIKE '%Plastifizierung%'
 )

inner join BusinessUnitPermission BUP on LP.id = BUP.LoosePartId and BUP.BusinessUnitId = (select id from BusinessUnit where name = 'Krauss Maffei SK') 
)
--and content not in ('1','2','3')

ROLLBACK


BEGIN TRANSACTION
--select * from CustomValue
update CustomValue set content = '1'
where CustomFieldId = '0c6d71b6-7521-4175-85dc-e64bfb38e0c4'
and EntityId in (
    select  LP.id from LoosePart LP
inner join CustomValue CV on LP.Id = CV.EntityId and CV.CustomFieldId = '6c9c4a35-b8c5-49a4-ac1a-1d5555ac7759' and (
 CV.content LIKE '%AEF – Stueck%' OR
 CV.content LIKE '%Stueck%' OR
 CV.content LIKE '%Drobný materiál%' OR
 CV.content LIKE '%Skri%' OR
 CV.content LIKE '%Schiene%' OR
 CV.content LIKE '%Saeule%' OR
 CV.content LIKE '%Speicher%' OR
 CV.content LIKE '%Zylinder%' OR
 CV.content LIKE '%Sud%' OR
 CV.content LIKE '%Gehaeuse%' OR
 CV.content LIKE '%Odliatky %' OR
 (CV.content LIKE '%Stuetze%' and LP.[Description] LIKE '2%') OR
 (CV.content LIKE '%BWAP%' and LP.[Description] LIKE '2%') OR
 (CV.content LIKE '%FWAP%' and LP.[Description] LIKE '2%')
 )


inner join BusinessUnitPermission BUP on LP.id = BUP.LoosePartId and BUP.BusinessUnitId = (select id from BusinessUnit where name = 'Krauss Maffei SK') 
)


ROLLBACK

/*
 select content from CustomValue CV where CV.CustomFieldId = '6c9c4a35-b8c5-49a4-ac1a-1d5555ac7759'
 group by Content
 */
/*
 update CustomValue set content = '0'
where CustomFieldId = '0c6d71b6-7521-4175-85dc-e64bfb38e0c4' and content = '1'
*/