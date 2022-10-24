  select distinct
  REPLACE(C.Name+' - '+REPLACE(C.[Name 2],'  ',' ') +' '+ REPLACE(C.City,'  ',' '),'  ',' ') as Name ,
  MAX(C.Address) as Street,
  MAX(C.City) as City,
  MAX(C.[Post Code]) as PostCode,
  Countries.Country,
'' as PhoneNo,
'' as ContactPerson,
MAX([E-Mail]) as [CF_E-Mail]

 from [DCNLPWSQL04].[DFDSE_NAV110DE_PRD].[dbo].Deufol_Central_Company$Customer as C

left join (SELECT Countries.Code, Countries.Country, Countries.Stock, Countries.Freight
 FROM (VALUES 
('AF','Afghanistan','LRG','SEE+'),
('AX','Aland Islands','NULL','NULL'),
('AL','Albania','H30','Europa'),
('DZ','Algeria','LRG','Übersee'),
('AS','American Samoa','LRG','Übersee'),
('AD','Andorra','H30','Europa'),
('AO','Angola','LRG','Übersee'),
('AI','Anguilla','LRG','Übersee'),
('AQ','Antarctica','NULL','NULL'),
('AG','Antigua and Barbuda','LRG','Übersee'),
('AR','Argentina','GRP','Übersee'),
('AM','Armenia','H30','Übersee'),
('AW','Aruba','LRG','Übersee'),
('AU','Australia','LRG','Übersee'),
('AT','Austria','H30','Europa'),
('AZ','Azerbaijan','H30','Übersee'),
('BS','Bahamas','GRP','Übersee'),
('BH','Bahrain','LRG','Übersee'),
('BD','Bangladesh','LRG','Übersee'),
('BB','Barbados','LRG','Übersee'),
('BY','Belarus','H30','Übersee'),
('BE','Belgium','H30','Europa'),
('BZ','Belize','LRG','Übersee'),
('BJ','Benin','LRG','Übersee'),
('BM','Bermuda','LRG','Übersee'),
('BT','Bhutan','LRG','Übersee'),
('BO','Bolivia','GRP','Übersee'),
('BA','Bosnia and Herzegovina','H30','Europa'),
('BW','Botswana','LRG','Übersee'),
('BV','Bouvet Island','LRG','Übersee'),
('BR','Brazil','GRP','Übersee'),
('VG','British Virgin Islands','LRG','Übersee'),
('IO','British Indian Ocean Territory','LRG','Übersee'),
('BN','Brunei Darussalam','LRG','Übersee'),
('BG','Bulgaria','H30','Europa'),
('BF','Burkina Faso','LRG','Übersee'),
('BI','Burundi','LRG','SEE+'),
('KH','Cambodia','LRG','Übersee'),
('CM','Cameroon','LRG','Übersee'),
('CA','Canada','GRP','Übersee'),
('CV','Cape Verde','LRG','Übersee'),
('KY','Cayman Islands','LRG','Übersee'),
('CF','Central African Republic','LRG','SEE+'),
('TD','Chad','LRG','SEE+'),
('CL','Chile','GRP','Übersee'),
('CN','China','LRG','Übersee'),
('HK','Hong Kong SAR China','LRG','Übersee'),
('MO','Macao SAR China','LRG','Übersee'),
('CX','Christmas Island','LRG','Übersee'),
('CC','Cocos (Keeling) Islands','LRG','Übersee'),
('CO','Colombia','GRP','Übersee'),
('KM','Comoros','LRG','Übersee'),
('CG','CongoÂ (Brazzaville)','LRG','Übersee'),
('CD','Congo (Kinshasa)','NULL','NULL'),
('CK','Cook Islands','LRG','Übersee'),
('CR','Costa Rica','GRP','Übersee'),
('CI','CĂ´te dIvoire','LRG','Übersee'),
('HR','Croatia','H30','Übersee'),
('CU','Cuba','LRG','Übersee'),
('CY','Cyprus','H30','Europa'),
('CZ','Czech Republic','H30','Europa'),
('DK','Denmark','H30','Europa'),
('DJ','Djibouti','LRG','Übersee'),
('DM','Dominica','LRG','Übersee'),
('DO','Dominican Republic','GRP','Übersee'),
('EC','Ecuador','GRP','Übersee'),
('EG','Egypt','LRG','Übersee'),
('SV','El Salvador','GRP','Übersee'),
('GQ','Equatorial Guinea','LRG','Übersee'),
('ER','Eritrea','LRG','Übersee'),
('EE','Estonia','H30','Europa'),
('ET','Ethiopia','LRG','Übersee'),
('FK','Falkland Islands (Malvinas)','LRG','Übersee'),
('FO','Faroe Islands','H30','Europa'),
('FJ','Fiji','LRG','Übersee'),
('FI','Finland','H30','Europa'),
('FR','France','H30','Europa'),
('GF','French Guiana','LRG','Übersee'),
('PF','French Polynesia','LRG','Übersee'),
('TF','French Southern Territories','LRG','Übersee'),
('GA','Gabon','LRG','Übersee'),
('GM','Gambia','LRG','Übersee'),
('GE','Georgia','H30','Übersee'),
('DE','Germany','H30','Europa'),
('GH','Ghana','LRG','Übersee'),
('GI','Gibraltar','H30','Europa'),
('GR','Greece','H30','Europa'),
('GL','Greenland','LRG','Übersee'),
('GD','Grenada','LRG','Übersee'),
('GP','Guadeloupe','LRG','Übersee'),
('GU','Guam','LRG','Übersee'),
('GT','Guatemala','GRP','Übersee'),
('GG','Guernsey','H30','Europa'),
('GN','Guinea','LRG','Übersee'),
('GW','Guinea-Bissau','LRG','Übersee'),
('GY','Guyana','GRP','Übersee'),
('HT','Haiti','GRP','Übersee'),
('HM','Heard and Mcdonald Islands','LRG','Übersee'),
('VA','Holy SeeÂ (Vatican City State)','H30','Europa'),
('HN','Honduras','GRP','Übersee'),
('HU','Hungary','H30','Europa'),
('IS','Iceland','H30','Europa'),
('IN','India','LRG','Übersee'),
('ID','Indonesia','LRG','Übersee'),
('IR','Iran Islamic Republic of','LRG','Übersee'),
('IQ','Iraq','LRG','Übersee'),
('IE','Ireland','H30','Europa'),
('IM','Isle of Man','H30','Europa'),
('IL','Israel','LRG','Übersee'),
('IT','Italy','H30','Europa'),
('JM','Jamaica','GRP','Übersee'),
('JP','Japan','LRG','Übersee'),
('JE','Jersey','H30','Europa'),
('JO','Jordan','LRG','Übersee'),
('KZ','Kazakhstan','H30','Europa'),
('KE','Kenya','LRG','Übersee'),
('KI','Kiribati','LRG','Übersee'),
('KP','KoreaÂ (North)','NULL','NULL'),
('KR','KoreaÂ (South)','LRG','Übersee'),
('KW','Kuwait','LRG','Übersee'),
('KG','Kyrgyzstan','H30','Europa'),
('LA','Lao PDR','LRG','Übersee'),
('LV','Latvia','H30','Europa'),
('LB','Lebanon','LRG','Übersee'),
('LS','Lesotho','LRG','Übersee'),
('LR','Liberia','LRG','Übersee'),
('LY','Libya','NULL','NULL'),
('LI','Liechtenstein','H30','Europa'),
('LT','Lithuania','H30','Europa'),
('LU','Luxembourg','H30','Europa'),
('MK','Macedonia Republic of','H30','Europa'),
('MG','Madagascar','LRG','Übersee'),
('MW','Malawi','LRG','Übersee'),
('MY','Malaysia','LRG','Übersee'),
('MV','Maldives','LRG','Übersee'),
('ML','Mali','LRG','SEE+'),
('MT','Malta','H30','Europa'),
('MH','Marshall Islands','LRG','Übersee'),
('MQ','Martinique','GRP','Übersee'),
('MR','Mauritania','LRG','Übersee'),
('MU','Mauritius','LRG','Übersee'),
('YT','Mayotte','LRG','Übersee'),
('MX','Mexico','GRP','Übersee'),
('FM','Micronesia Federated States of','LRG','Übersee'),
('MD','Moldova','H30','Europa'),
('MC','Monaco','H30','Europa'),
('MN','Mongolia','LRG','SEE+'),
('ME','Montenegro','H30','Übersee'),
('MS','Montserrat','LRG','Übersee'),
('MA','Morocco','LRG','Übersee'),
('MZ','Mozambique','LRG','Übersee'),
('MM','Myanmar','LRG','Übersee'),
('NA','Namibia','LRG','Übersee'),
('NR','Nauru','LRG','Übersee'),
('NP','Nepal','LRG','SEE+'),
('NL','Netherlands','H30','Übersee'),
('AN','Netherlands Antilles','LRG','Übersee'),
('NC','New Caledonia','LRG','Übersee'),
('NZ','New Zealand','LRG','Übersee'),
('NI','Nicaragua','GRP','Übersee'),
('NE','Niger','LRG','SEE+'),
('NG','Nigeria','LRG','Übersee'),
('NU','Niue','LRG','Übersee'),
('NF','Norfolk Island','LRG','Übersee'),
('MP','Northern Mariana Islands','LRG','Übersee'),
('NO','Norway','H30','Europa'),
('OM','Oman','LRG','Übersee'),
('PK','Pakistan','LRG','Übersee'),
('PW','Palau','LRG','Übersee'),
('PS','Palestinian Territory','LRG','Übersee'),
('PA','Panama','GRP','Übersee'),
('PG','Papua New Guinea','LRG','Übersee'),
('PY','Paraguay','GRP','Übersee'),
('PE','Peru','GRP','Übersee'),
('PH','Philippines','LRG','Übersee'),
('PN','Pitcairn','LRG','Übersee'),
('PL','Poland','H30','Europa'),
('PT','Portugal','H30','Europa'),
('PR','Puerto Rico','GRP','Übersee'),
('QA','Qatar','LRG','Übersee'),
('RE','RĂ©union','NULL','NULL'),
('RO','Romania','H30','Europa'),
('RU','Russian Federation','H30','Europa'),
('RW','Rwanda','LRG','SEE+'),
('BL','Saint-BarthĂ©lemy','NULL','NULL'),
('SH','Saint Helena','LRG','Übersee'),
('KN','Saint Kitts and Nevis','GRP','Übersee'),
('LC','Saint Lucia','LRG','Übersee'),
('MF','Saint-Martin (French part)','NULL','NULL'),
('PM','Saint Pierre and Miquelon','LRG','Übersee'),
('VC','Saint Vincent and Grenadines','LRG','Übersee'),
('WS','Samoa','LRG','Übersee'),
('SM','San Marino','H30','Europa'),
('ST','Sao Tome and Principe','LRG','Übersee'),
('SA','Saudi Arabia','LRG','Übersee'),
('SN','Senegal','LRG','Übersee'),
('RS','Serbia','H30','Europa'),
('SC','Seychelles','LRG','Übersee'),
('SL','Sierra Leone','LRG','Übersee'),
('SG','Singapore','LRG','Übersee'),
('SK','Slovakia','H30','Europa'),
('SI','Slovenia','H30','Europa'),
('SB','Solomon Islands','LRG','Übersee'),
('SO','Somalia','LRG','Übersee'),
('ZA','South Africa','LRG','Übersee'),
('GS','South Georgia and the South Sandwich Islands','LRG','Übersee'),
('SS','South Sudan','NULL','NULL'),
('ES','Spain','','Europa'),
('LK','Sri Lanka','LRG','Übersee'),
('SD','Sudan','LRG','Übersee'),
('SR','Suriname','LRG','Übersee'),
('SJ','Svalbard and Jan Mayen Islands','NULL','NULL'),
('SZ','Swaziland','LRG','Übersee'),
('SE','Sweden','H30','Europa'),
('CH','Switzerland','H30','Europa'),
('SY','Syrian Arab RepublicÂ (Syria)','LRG','Übersee'),
('TW','Taiwan Republic of China','LRG','Übersee'),
('TJ','Tajikistan','H30','Europa'),
('TZ','Tanzania United Republic of','LRG','Übersee'),
('TH','Thailand','LRG','Übersee'),
('TL','Timor-Leste','NULL','NULL'),
('TG','Togo','LRG','Übersee'),
('TK','Tokelau','LRG','Übersee'),
('TO','Tonga','LRG','Übersee'),
('TT','Trinidad and Tobago','GRP','Übersee'),
('TN','Tunisia','LRG','Übersee'),
('TR','Turkey','H30','Europa'),
('TM','Turkmenistan','H30','Europa'),
('TC','Turks and Caicos Islands','LRG','Übersee'),
('TV','Tuvalu','LRG','Übersee'),
('UG','Uganda','LRG','SEE+'),
('UA','Ukraine','H30','Europa'),
('AE','United Arab Emirates','LRG','Übersee'),
('GB','United Kingdom','H30','Europa'),
('US','United States of America','GRP','KDI-Verpackung'),
('UM','US Minor Outlying Islands','LRG','Übersee'),
('UY','Uruguay','GRP','Übersee'),
('UZ','Uzbekistan','H30','Europa'),
('VU','Vanuatu','LRG','Übersee'),
('VE','VenezuelaÂ (Bolivarian Republic)','GRP','Übersee'),
('VN','Viet Nam','LRG','Übersee'),
('VI','Virgin Islands US','LRG','Übersee'),
('WF','Wallis and Futuna Islands','LRG','Übersee'),
('EH','Western Sahara','NULL','NULL'),
('YE','Yemen','LRG','Übersee'),
('ZM','Zambia','LRG','SEE+'),
('ZW','Zimbabwe','LRG','Übersee')


 ) Countries (Code, Country, Stock, Freight)) Countries on C.[Country_Region Code] = Countries.Code


 left join (
    select Customer.* from ( select
        DV.Content Customer_no
        ,DV.[Description] Customer
        ,DF.Name
        ,DFV.Content
    from [DCNLPWSQL08].[DFCZ_OSLET].[dbo].DimensionField DF

        inner join [DCNLPWSQL08].[DFCZ_OSLET].[dbo].DimensionFieldValue DFV on Df.id = DFV.DimensionFieldId
        inner join [DCNLPWSQL08].[DFCZ_OSLET].[dbo].DimensionValue DV on DFV.DimensionValueId = DV.Id
        inner join BusinessUnitPermission BUP on DV.id = BUP.DimensionValueId and BUP.BusinessUnitId = (select id from BusinessUnit where name = 'DEUFOL CUSTOMERS')
        inner join [DCNLPWSQL08].[DFCZ_OSLET].[dbo].Dimension D on DF.DimensionId = D.id and D.name = 'Customer'
    where 
        DF.name in ((select name 
                    from [DCNLPWSQL08].[DFCZ_OSLET].[dbo].DimensionField 
                    where ClientBusinessUnitId = (select id from BusinessUnit  where name = 'DEUFOL CUSTOMERS') 
                    group by name)))SRC
    pivot (max(SRC.Content) for SRC.Name in ([VAT Registration No_])) as Customer) as dc on dc.[VAT Registration No_] collate database_default = c.[VAT Registration No_] collate database_default
where c.[VAT Registration No_] <> ''   and dc.Customer_no is NULL
--and Blocked_Editing <> 0

--order by c.[Last Modified Date Time] desc

 group by C.Name+' - '+REPLACE(C.[Name 2],'  ',' ') +' '+ REPLACE(C.City,'  ',' '),Countries.Country