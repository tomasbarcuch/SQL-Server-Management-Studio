select

--right(CURRENT_USER,len(CURRENT_USER)-(charindex('\',CURRENT_USER))),
HU.Code 'Code',
HU.[Description] 'Bemerkung',
HU_Type.Text 'Type',
HU.Length*0.10 'Länge [CM]',
HU.Width*0.10 'Breite [CM]',
HU.Height*0.10 'Höhe [CM]',
HU.Weight 'Gewicht [KG]',
HU.Brutto 'Brutto [KG]',
HU.Netto 'Netto [KG]',
HU.ColliNumber 'Collinummer',
CV.Content as 'UUP',
LP.Code as 'Losteil Code',
LP.[Description] 'LP Description'

from HandlingUnit HU
inner join BusinessUnitPermission BUP on HU.id = BUP.HandlingUnitId and BUP.BusinessUnitId = (select id from BusinessUnit where name = 'Siempelkamp Maschinen- und Anlagenbau GmbH')
left join LoosePart LP on HU.id = LP.ActualHandlingUnitId
left join HandlingUnitType HUT on HU.TypeId = HUT.Id
left join Translation HU_Type on HUT.id = HU_Type.EntityId and HU_Type.[Language] = 'de' and HU_Type.[Column] = 'Description'
inner join CustomValue CV on LP.id = CV.EntityId and CV.CustomFieldId = (select id from CustomField where name = 'UUP' and ClientBusinessUnitId = (select id from BusinessUnit where name = 'Siempelkamp Maschinen- und Anlagenbau GmbH') and entity = 15)
inner join [User] U on right(CURRENT_USER,len(CURRENT_USER)-(charindex('\',CURRENT_USER))) = U.[Login]
left join DisplayUOM on U.DisplayUOMId = DisplayUOM.id