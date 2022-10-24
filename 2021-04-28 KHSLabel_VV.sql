select 
O.*,
LP.BARCODE,
O.ARTIKEL_NR,
P.TXX,
LP.NEUTRAL10,
P.PROJ_TXX,
replace(cast(P.Wempf as varchar(255)), char(13),' ') as Wempf,
case when LP.LISTE_KZ like '%ERR%' AND LP.LISTE_KZ NOT like'%LRA%' then'TRUE' else 'FALSE' end as LISTE_KZ,
P.BKUNDE,
O.ARTIKEL_TXX,
O.VS_HIER2,
O.ARTIKEL_NR,
O.ZUSATZTEXT1,
O.ZUSATZTEXT2,
L.TXX as Werk,
LP.LT_TXX2,
LP.LT_TXD,
LP.LT_MENGE,
ISNULL(ME.KUERZEL,SAP_KEY) as Mengeeinheit,
LP.MATERIAL_NR,
LP.GEFAHRGUT_UNNR,
LP.FARBTON,
TXENG.TXX LP_TXX_ENG,
TXGER.TXX LP_TXX_GER,
TX.TXX LP_TXX,
LP.ABMESS1_MM,
LP.ABMESS2_MM,
LP.ABMESS3_MM,
LP.ABMESS4_MM,
LP.ABMESS5_MM,
LP.ABMESS6_MM,
'#'+RIGHT(CONVERT(varchar(1000),(CONVERT(VARBINARY(8),((
case when SUBSTRING(FARBTON.FARBTON, 1, 1) > 8.901961 then 255*65536 else cast(ROUND(SUBSTRING(FARBTON.FARBTON, 1, 1)*25.5,0)*65536 as int) end+
case when SUBSTRING(FARBTON.FARBTON, 2, 1) > 8.901961 then 255*256 else cast(ROUND(SUBSTRING(FARBTON.FARBTON, 2, 1)*25.5,0)*256 as int) end+
case when SUBSTRING(FARBTON.FARBTON, 3, 1) > 8.901961 then 255 else cast(ROUND(SUBSTRING(FARBTON.FARBTON, 3, 1)*25.5,0)as int) end
)))),2),6) as ColorHexLeft,

'#'+RIGHT(CONVERT(varchar(1000),(CONVERT(VARBINARY(8),((
case when SUBSTRING(FARBTON.FARBTON, 5, 1) > 8.901961 then 255*65536 else cast(ROUND(SUBSTRING(FARBTON.FARBTON, 5, 1)*25.5,0)*65536 as int) end+
case when SUBSTRING(FARBTON.FARBTON, 6, 1) > 8.901961 then 255*256 else cast(ROUND(SUBSTRING(FARBTON.FARBTON, 6, 1)*25.5,0)*256 as int) end+
case when SUBSTRING(FARBTON.FARBTON, 7, 1) > 8.901961 then 255 else cast(ROUND(SUBSTRING(FARBTON.FARBTON, 7, 1)*25.5,0) as int) end
)))),2),6) as ColorHexRight,
case 
LEFT(FARBTON.FARBTON,3)
when'000' then 'Black (BK)'
when'099' then 'Cyan (TQ)'
when'900' then 'Red (RD)'
when'909' then 'Magenta (PK)'
when'990' then 'Yellow (YE)'
when'047' then 'Blue (BU)'
when'063' then 'Green (GN)'
when'970' then 'Orange (OG)'
when'999' then 'White (WH)'
else ''
end as ColorTextLeft,

case 
RIGHT(FARBTON.FARBTON,3)
when'000' then 'Black (BK)'
when'099' then 'Cyan (TQ)'
when'900' then 'Red (RD)'
when'909' then 'Magenta (PK)'
when'990' then 'Yellow (YE)'
when'047' then 'Blue (BU)'
when'063' then 'Green (GN)'
when'970' then 'Orange (OG)'
when'999' then 'White (WH)'
else ''
end as ColorTextRight,
case when (
cast(SUBSTRING(FARBTON.FARBTON, 1, 1) as int)+
cast(SUBSTRING(FARBTON.FARBTON, 2, 1) as int)+
cast(SUBSTRING(FARBTON.FARBTON, 3, 1) as int)) 
> 13 then '#000000' else '#ffffff' end as FontColorLeft,
case when (
cast(SUBSTRING(FARBTON.FARBTON, 5, 1) as int)+
cast(SUBSTRING(FARBTON.FARBTON, 6, 1) as int)+
cast(SUBSTRING(FARBTON.FARBTON, 7, 1) as int)) 
> 13 then '#000000' else '#ffffff' end as FontColorRight

from DAT_LOSTEILE LP
INNER JOIN VS_HIER1 P on LP.VS_HIER1 = P.TXX
INNER JOIN VS_HIER2 O on LP.Z_VS_HIER2 = O.ZAEHLER
LEFT JOIN N_ORTE L on O.W_FERTIGORT = L.WERT and L.SAP_SPRACHE='D'
LEFT JOIN SAP_MENGENEINHEITEN ME on LP.W_LT_MENGENEINHEIT = ME.WERT and ME.SAP_SPRACHE='D'
LEFT JOIN N_TEXTE TXENG on LP.W_TEXTE = TXENG.WERT and TXENG.SAP_SPRACHE='E' 
LEFT JOIN N_TEXTE TXGER on LP.W_TEXTE = TXGER.WERT and TXGER.SAP_SPRACHE='D'
LEFT JOIN N_TEXTE TX on LP.W_TEXTE = TX.WERT and TX.SAP_SPRACHE='XX'
INNER JOIN (
select
BARCODE,
case when len(FARBTON)<7 then '999-999' else isnull(FARBTON,'999-999') end as FARBTON
from DAT_LOSTEILE) FARBTON on LP.BARCODE = FARBTON.BARCODE



where --len(FARBTON)>0 and len(LP.GEFAHRGUT_UNNR)>0
LP.BARCODE in ('4268579')

