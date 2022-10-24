
SELECT 
---LK.*,
K.BARCODE as 'Code'

,K.[ABMESS1_MM] as 'Length'
,K.[ABMESS2_MM] as 'Width'
,K.[ABMESS3_MM] as 'Height'
,K.[TARA_KG] as 'Weight'

,K.[NETTO_KG] as 'Netto'
,K.[BRUTTO_KG] as 'Brutto'
,ROUND(K.[ABMESS1_MM]*K.[ABMESS2_MM]*K.[ABMESS3_MM]/1000000000,3) as 'Volume'
,ROUND((K.[ABMESS1_MM]*(K.[ABMESS2_MM]+K.[ABMESS3_MM])+K.[ABMESS2_MM]*K.[ABMESS3_MM])/500000,3) as 'Surface'
,ROUND(K.[ABMESS1_MM]*K.[ABMESS2_MM]/1000000,3) as 'BaseArea'


  FROM DCNLPWSQL02.[KRO_VV].[dbo].[DAT_KISTEN] K 









	
order by DATA.Code asc



