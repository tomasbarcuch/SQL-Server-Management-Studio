SELECT TOP (1000)
      [TXX]
      ,[DBSELECT]
      ,[VERKNUEPFUNG]
      ,[V_BESCHREIBUNG]
  FROM [KRO_VV].[dbo].[N_AUSWAHLFELDER]
  where (TXX like 'Adresse: Warenempfänger 1'
  or TXX like 'Innenkiste von'
  or TXX like 'Transport Zielort (intern)'
  or TXX like 'Versandsperre am Auftrag'
    or TXX like 'Luftfracht'
      or TXX like 'Datum Eingang-HH'
      or TXX like 'Text 1'
      or TXX like 'Land WEMPF'
)
and SAP_SPRACHE='D' and DBTAB='DAT_KISTEN'




  