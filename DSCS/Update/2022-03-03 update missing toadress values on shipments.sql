
begin TRANSACTION
update SH set
--select 
SH.ToAddressId=L.AddressId,
SH.ToAddressName=A.Name,
SH.ToAddressStreet=A.Street,
SH.ToAddressCity=A.City,
SH.ToAddressPostCode=A.PostCode,
SH.ToAddressCountry=A.Country,
SH.ToAddressPhoneNo=A.PhoneNo,
SH.ToAddressContactPerson=A.ContactPerson

 from ShipmentHeader SH
INNER join Location L on SH.ToLocationId = L.id
left join Address A on L.AddressId = A.id
where 
(
    (SH.ToAddressID is not null and LEN(SH.ToAddressName) = 0)
OR
    (SH.ToAddressID is null and LEN(SH.ToAddressName) = 0)
)
and YEAR(SH.Created) = 2022
ROLLBACK


begin TRANSACTION
update SH set
--select 
SH.ToAddressId=A.Id,
SH.ToAddressName=A.Name,
SH.ToAddressStreet=A.Street,
SH.ToAddressCity=A.City,
SH.ToAddressPostCode=A.PostCode,
SH.ToAddressCountry=A.Country
--SH.ToAddressPhoneNo=A.PhoneNo,
--SH.ToAddressContactPerson=A.ContactPerson

 from ShipmentHeader SH
--left join Location L on SH.ToLocationId = L.id
left join Address A on SH.ToAddressId = A.id
where SH.ToAddressId is not null and LEN(ISNULL(SH.ToAddressName,'')) = 0
and YEAR(SH.Created) = 2022
ROLLBACK

select * from ShipmentHeader SH where SH.ToAddressId is not null and LEN(ISNULL(SH.ToAddressName,'')) = 0