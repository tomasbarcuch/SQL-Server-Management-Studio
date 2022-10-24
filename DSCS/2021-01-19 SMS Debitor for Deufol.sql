select 
id buid,
name bu,
case name 
when 'Deufol Hamburg Rosshafen' then '108008'
when 'Deufol Hub Bremerhaven'then '109980'
when 'Deufol Peine' then '104447'
end as 'SMS Debitor'
 from businessunit
where name in (
    'Deufol Hamburg Rosshafen',
    'Deufol Hub Bremerhaven',
    'Deufol Peine'
) 