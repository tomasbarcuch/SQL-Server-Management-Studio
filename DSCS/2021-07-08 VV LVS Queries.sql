select dat_pappkartons.*, dat_kisten.W_STATUS
from dat_pappkartons left join dat_kisten on case when dat_pappkartons.Z_kisten>0 then dat_pappkartons.Z_kisten else dat_pappkartons.Z_kisten_soll end = dat_kisten.zaehler
where dat_kisten.W_STATUS >=12030 and dat_kisten.w_status <12110
and dat_pappkartons.W_STATUS >=23010 and dat_pappkartons.w_status <23035
and dat_pappkartons.vs_hier1 not in (select distinct txx from vs_hier1 where vs_hier1.proj_txx ='Siemens Mülheim' or vs_hier1.proj_txx ='Siemens Duisburg'or vs_hier1.proj_txx ='Siemens Charlotte')
order by dat_pappkartons.VS_HIER1


 select count(*) as Anzahl, vs_hier1.proj_txx as Kunde  FROM [LVS_VV].[dbo].[DAT_KISTEN]
  left join vs_hier1 on dat_kisten.vs_hier1 = vs_hier1.txx
  where dat_kisten.W_STATUS >=12030 and dat_kisten.w_status <12110 and vs_hier1 not in
  (select distinct txx from vs_hier1 where vs_hier1.proj_txx ='Siemens Mülheim' or vs_hier1.proj_txx ='Siemens Duisburg'or vs_hier1.proj_txx ='Siemens Charlotte')
  group by vs_hier1.proj_txx
  order by kunde


select count(*) as Anzahl, vs_hier1.proj_txx as Kunde, n_orte.TXX as Ort, w_standort
  FROM [LVS_VV].[dbo].[DAT_KISTEN]
  left join n_orte on dat_kisten.W_STANDORT=n_orte.WERT
  left join vs_hier1 on dat_kisten.vs_hier1 = vs_hier1.txx
  where dat_kisten.W_STATUS >=12030 and dat_kisten.w_status <12110 and vs_hier1 not in
  (select distinct txx from vs_hier1 where vs_hier1.proj_txx ='Siemens Mülheim' or vs_hier1.proj_txx ='Siemens Duisburg'or vs_hier1.proj_txx ='Siemens Charlotte')
  group by vs_hier1.proj_txx, w_standort, n_orte.TXX
  order by kunde, ort


  select * from DAT_KISTEN K
 
  --inner join Ordner O on K.Zaehler = O.Zaehler and O.Tabelle = 'DAT_KISTEN'
   where barcode like '%00200250216417%'



   select * from dat_pappkartons K
 -- inner join Ordner O on K.Zaehler = O.Zaehler and O.Tabelle = 'dat_pappkartons' and O.ORDNERNAME like '%LVS%' --= 'MIGRATION OBE 2021'

where barcode ='WE160118/009-004'


   select * from DAT_LOSTEILE K
  --inner join Ordner O on K.Zaehler = O.Zaehler and O.Tabelle = 'DAT_LOSTEILE'
where barcode between '60743' and '60750'

