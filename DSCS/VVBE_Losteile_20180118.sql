/****** Script for SelectTopNRows command from SSMS  ******/

use [SIEMENSBERLIN_VV]
SELECT L.[ZAEHLER]
      ,L.[DAT_LASTMOD]
      ,L.[LISTE_KZ]
      ,L.[EDV1]
      ,LS.TXX LosteilStatus
      ,L.[LOG_Status]
      ,L.[DAT_STATUS]
      ,L.[BARCODE]
      ,[Z_KISTEN]
	  ,KS.TXX KisteStatus
	  ,K.[VS_HIER1] KistenProjekt
      ,L.[VS_HIER1] LosteilProjekt
      ,L.[VS_HIER2]
      ,L.[VS_HIER3]
      ,L.[W_STANDORT]
      ,L.[LAGERORT1]
      ,L.[LAGERORT2]
      ,L.[LAGERORT3]
      ,[LT_TXD]
      ,[LT_TXX1]
      ,[LT_MENGE]
      ,[W_LT_MENGENEINHEIT]
      ,L.[ABMESS1_MM]
      ,L.[ABMESS2_MM]
      ,L.[ABMESS3_MM]
      ,L.[BRUTTO_KG]
      ,L.[NETTO_KG]
      ,[ERFASSID]
      ,[Z_BEST]
      ,[Z_BPOS]
      ,L.[NEUTRAL20]
      ,[EXPORT_ECCN]
      ,[EXPORT_ALNR]
      ,L.[GEFAHRGUT_KLASSE]
      ,L.[GEFAHRGUT_UNNR]
      ,[Z_VS_HIER2]
      ,[FARBTON]
      ,[DAT_LACKIERT]
      ,[DAT_EINLAGERUNG]
      ,[DAT_AUSLAGERUNG]
      ,[DAT_STATUS_WE]
      ,[DAT_FIRST_HANDOVER]
      ,L.[W_FAKTSTATUS]
      ,L.[FAKTRENUM]
      ,L.[DAT_FAKTURIERT]
  FROM [SIEMENSBERLIN_VV].[dbo].[DAT_LOSTEILE] as L
    inner join N_STATUS as LS on L.W_STATUS = LS.WERT and LS.SAP_SPRACHE = 'D'
    left outer join DAT_Kisten as K on L.Z_KISTEN = K.ZAEHLER
    left outer join N_STATUS as KS on K.W_STATUS = KS.WERT and KS.SAP_SPRACHE = 'D'
  where L.DAT_AUSLAGERUNG is null
	and K.W_STATUS <> 12110
	
  
  