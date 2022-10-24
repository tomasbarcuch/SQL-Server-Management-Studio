/*
SELECT TOP (1000) ZAEHLER ,DAT_ABRUF,BARCODE,W_STATUS, W_STANDORT
  FROM [KRO_VV].[dbo].[DAT_KISTEN]
  order by DAT_ABRUF desc
 */
/*
select * from (
SELECT  
max(DAT_LASTMOD) OVER (PARTITION BY Z_Kisten) AS DAT_LASTMOD,Z_Kisten
  FROM [KRO_VV].[dbo].[LOG_KISTEN] LK
  --inner join DAT_KISTEN K on LK.Z_KISTEN = K.ZAEHLER
  where ZUSATZ like 'inventur%'   --and Z_Kisten = 1826275
)DATA 
group by data.Z_KISTEN, data.DAT_LASTMOD
having data.DAT_LASTMOD > '2019-07-11'
order by data.DAT_LASTMOD desc

  

SELECT  
cast(DAT_LASTMOD as date) InvDay,
count(Z_KISTEN) Kisten
  FROM [KRO_VV].[dbo].[LOG_KISTEN] LK
  --inner join DAT_KISTEN K on LK.Z_KISTEN = K.ZAEHLER
  where ZUSATZ like 'inventur%' 
  group by  cast(DAT_LASTMOD as date)
 order by  cast(DAT_LASTMOD as date) desc
*/

SELECT  
L.ZAEHLER
  FROM [KRO_VV].[dbo].[DAT_LOSTEILE] L
  inner join LOG_LOSTEILE LL on L.ZAEHLER = LL.Z_LOSTEILE
  
  where 
 LL.ZUSATZ like 'inventur%'  and cast(LL.DAT_LASTMOD as date) = '2019-06-08' 
 UNION
SELECT  
L.ZAEHLER
  FROM [KRO_VV].[dbo].[DAT_LOSTEILE] L
  inner join LOG_LOSTEILE LL on L.ZAEHLER = LL.Z_LOSTEILE
  
  where 

L.Z_KISTEN in (

SELECT  
Z_KISTEN
  FROM [KRO_VV].[dbo].[LOG_KISTEN] LK
  where ZUSATZ like 'inventur%' 
  and cast(LK.DAT_LASTMOD as date) = '2019-06-08'
)