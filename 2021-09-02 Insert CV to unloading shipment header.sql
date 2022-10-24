begin TRANSACTION
insert into CustomValue 
select
NEWID()[Id],
	CV.[CustomFieldId] ,
	31 [Entity],
	USH.Id [EntityId],
	CV.[Content],
	USH.[CreatedById],
	USH.[UpdatedById],
	USH.[Created],
	USH.[Updated]


from ShipmentHeader SH  with (NOLOCK)
inner join CustomValue CV with (NOLOCK) on SH.id = CV.EntityId
inner join ShipmentHeader USH on SH.UnloadingShipmentHeaderId = USH.ID
left join CustomValue ECV with (NOLOCK) on SH.UnloadingShipmentHeaderId = ECV.EntityId

where ECV.EntityId is NULL


COMMIT


--delete from CustomValue where EntityId in ((select UnloadingShipmentHeaderId from ShipmentHeader where UnloadingShipmentHeaderId is not null))