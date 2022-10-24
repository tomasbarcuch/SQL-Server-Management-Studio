/*
select * from DAT_KISTEN K
   --inner join Ordner O on K.Zaehler = O.Zaehler and O.Tabelle = 'DAT_KISTEN'
where barcode like '%00200250216417%'



select * from dat_pappkartons K
 -- inner join Ordner O on K.Zaehler = O.Zaehler and O.Tabelle = 'dat_pappkartons' and O.ORDNERNAME like '%LVS%' --= 'MIGRATION OBE 2021'
where barcode ='WE160118/009-004'


select * from DAT_LOSTEILE K
inner join Ordner O on K.Zaehler = O.Zaehler and O.Tabelle = 'DAT_LOSTEILE'
where barcode between '60743' and '60750' and Z_KISTEN = '63097'
*/



select 
P.TX_VERTRIEBSBEREICH 'Content',
'MIG' 'ParentDimensionValue',
'Project' 'Dimension',
P.Proj_TxX 'DF_VVCustomer',
P.INTERNINFO 'DF_packing instruction',
'' 'DF_freight type',
'' 'DF_wood type',
'' 'DF_protection months',
'' 'DF_box skids type',
'' 'DF_foil type',
'' 'DF_Is Containerdimension nessesary',
'' 'DF_Is Fotodocu',
'' 'DF_Is CPC',
P.MARKIERUNGBOX 'DF_Marking',
P.SAP_LANDWempf 'DF_Project_DeliveryLand',
'' 'DF_HT',
'' 'DF_Valeron',
'' 'DF_Packaging type ',
'' 'DF_treatment ',
'Deufol Dorthmund' 'RelatedBusinessUnit'

,*

from LoosePart P

 select * from  DCNLPWSQL02.[LVS_VV].[dbo].SAP_LAENDER L on P.SAP_LANDWempf = L.SAP_KEY COLLATE Latin1_General_CI_AS
 --where TX_VERTRIEBSBEREICH = '51110753'