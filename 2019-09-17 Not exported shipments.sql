SELECT 
O.txx as Location,
OS.txx as StartLocation,
OZ.TXX as TargetLocation,
Cont.zaehler,
Cont.WELTWEITE as Shipment
,S.txx as Status
,Cont.DAT_VERSAND
,Cont.DAT_LASTMOD
,I.RECEIVED

  FROM [KRO_VV].[dbo].[DAT_CONTAINER] cont
  inner join N_STATUS S on Cont.W_STATUS = S.WERT and S.SAP_SPRACHE = 'D'
  inner join N_ORTE O on Cont.W_STANDORT = O.WERT
  inner join N_ORTE OS on Cont.W_ORT_START = OS.WERT
  inner join N_ORTE OZ on Cont.W_ORT_ZIEL = OZ.WERT

left join  VV_PCENTER_INTERFACE I on Cont.zaehler = I.vvid and I.OBJECT_TYPE = 'SHP'

where S.txx = 'erledigt' and Cont.DAT_VERSAND > '2019-09-01'
--and RECEIVED is null
 and Cont.WELTWEITE in (
    'LKW05/682-544',
    'TL01/678-052',
    'LKW12/682-544',
    'LKW02/697-085',
    'LKW01/697-085',
    'LKW11/578-362',
    'LKW05/697-085',
    'LKW03/697-085',
    'TRANSPORT',
    'CGD2P37',
    'RS623.',
    'RT4351',
    '-KR820HA-1744M'
    )

order by Cont.DAT_VERSAND, Cont.DAT_LASTMOD, RECEIVED

