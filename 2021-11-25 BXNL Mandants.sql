
SELECT Mandants.Name,Mandants.Descript,Mandants.Region
 FROM (VALUES 
('00002','DE017 Deufol West / Mülheim','West'),
('00003','DE058 Deufol Nord','Nord - Ost'),
('00004','CZ001 Deufol Ceska republika / Ivancice','CZ&SK'),
('00005','DE017 Deufol West / Dortmund','West'),
('00006','DE022 Deufol Remscheid','West'),
('00007','DE062 DRELU / Bochum','West'),
('00008','BLOCK Deufol Hanau','NULL'),
('00009','SK001 Deufol Slovensko','CZ&SK'),
('00010','DE017 Deufol West / Voerde Siemens','West'),
('00011','BLOCK CZ0001 Deufol Ceska republika / Olomouc','CZ&SK'),
('00012','DE017 Deufol West / Duisburg Siemens','West'),
('00013','DE017 Deufol West / Dortmund - Juchostr.','West'),
('00014','DE033 Deufol Bochum','West'),
('00015','DE031 Deufol Berlin','Nord - Ost'),
('00016','BLOCK LPO Ledec','CZ&SK'),
('00017','DE032 Deufol Hamburg / Ellerholzdamm','Nord - Ost'),
('00018','AT002 Deufol Austria Pack Center Solutions','Austria'),
('00019','BLOCK DTG Hamburg','NULL'),
('00020','DE053 Deufol Real Estate / Hinterweidenthal','Süd - West'),
('00021','DE054 Deufol Südwest / Frankenthal VP','Süd - West'),
('00022','DE042 Deufol Süd / Neutraubling','Süd - Ost'),
('00023','DE054 Deufol Südwest / Rotterdamer Str.','Süd - West'),
('00024','CZ001 Deufol Ceska republika / Plzen','CZ&SK'),
('00026','DE048 DTG Verpackungslogistik / Fellbach','Süd - West'),
('00027','BLOCK Weinzierl Sinzing','NULL'),
('00028','BLOCK BVU München','NULL'),
('00029','BLOCK IAD München','NULL'),
('00030','BLOCK Weinzierl München','NULL'),
('00031','BLOCK DTG Mannh. Pfaudler','NULL'),
('00032','BLOCK DTG Mannh. Pfenning','NULL'),
('00033','BLOCK DTG Mannh. Alstom','NULL'),
('00034','DE044 Deufol Frankfurt','Süd - West'),
('00035','BLOCK GTV','BeNeLuxFra'),
('00036','BLOCK DTG Verpl. CWP','NULL'),
('00037','BLOCK DTI KIBO','NULL'),
('00038','BE016 Deufol Port of Antwerp / Aprojects','BeNeLuxFra'),
('00039','DE017 Deufol West / Mülheim - Ratingen ABB','West'),
('00040','BLOCK CWP Stuttgart','NULL'),
('00041','BLOCK GGZ','NULL'),
('00042','BLOCK Walpa','NULL'),
('00043','BLOCK Duerr Waiblingen','NULL'),
('00044','BLOCK DTI Nuernberg MAN','NULL'),
('00045','DTI Untermarchenbach','NULL'),
('00046','DE017 Deufol West / Dortmund - Kleve','West'),
('00047','IT002 Deufol Italia','Italia'),
('00048','DE048 DTG Verpackungslogistik / Rottenburg','Süd - West'),
('00049','BLOCK Deufol (Suzhou) Packaging','NULL'),
('00050','US004 Deufol Charlotte','USA'),
('00051','AT008 Deufol Austria Supply Chain Solutions','Austria'),
('00052','AT007 Packing Center Terminal Graz','Austria'),
('00053','BLOCK Deufol München','NULL'),
('00054','DE032 Deufol Hamburg / Rosshafen - Halle M','Nord - Ost'),
('00055','PL001 Deufol Poland','Poland'),
('00056','DE062 Deufol Rheinland','West'),
('00057','BLOCK Drásov','CZ&SK'),
('00058','BLOCK Deufol Mörfelden','NULL'),
('00059','DE054 Deufol Südwest / Bad Kreuznach - KHS','Süd - West'),
('00060','DE054 Deufol Südwest / Worms - KHS','Süd - West'),
('00061','BLOCK Deufol Yantai','China'),
('00062','DE017 Deufol West / Mülheim - Produktion','West'),
('00063','DE032 Deufol Hamburg / Rosshafen','Nord - Ost'),
('00064','DE054 Deufol Südwest / Frankenthal - KSB','Süd - West'),
('00065','US003 Deufol Sunman','USA'),
('00066','CZ005 Deufol CZ Production / Cheb','CZ&SK'),
('00067','CZ005 Deufol CZ Production / Cheb - ConPal','CZ&SK'),
('00068','BE016 Deufol Port of Antwerp','BeNeLuxFra'),
('00069','FR001 Deufol Paris','BeNeLuxFra'),
('00070','BE015 Deufol Lier','BeNeLuxFra'),
('00071','DE032 Deufol Hamburg / Bremerhaven','Nord - Ost'),
('00072','DE054 Deufol Südwest / Hofheim','Süd - West'),
('00073','US005 Deufol Worldwide Packaging / Cincinnati','USA'),
('00074','US005 Deufol Worldwide Packaging / Cleveland','USA'),
('00075','US005 Deufol Worldwide Packaging / Pittsburgh','USA'),
('00076','AT006 Rieder Kistenproduktionsgesellschaft / Ramsau','Austria'),
('00077','DE054 Deufol Südwest / Frankenthal - Eppingen','Süd - West'),
('00078','BE010 Deufol Techni','BeNeLuxFra'),
('00079','HU001 Deufol Hungary / Debrecen','Hungary'),
('00080','DE058 Deufol Nord / Braunschweig','Nord - Ost'),
('00081','DE058 Deufol Nord / Erfurt','Nord - Ost'),
('00082','HU002 Deufol Hungary / Debrecen Krones','Hungary'),
('00083','BE015 Deufol Lier / Brussel','BeNeLuxFra'),
('00084','DE017 Deufol West / Münsterland','NULL'),
('00111','BLOCK Krings (Test)','Test'),
('00149','CN001 Deufol Suzhou 2','China'),
('00150','CN001 Deufol Suzhou 1','China'),
('00161','CN002 Deufol Yantai','China'),
('00162','CN003 Deufol GDN','China'),
('00171','BLOCK Deufol SWPM','China'),
('00815','Testmandant','Test'),
('00816','BLOCK Testmandant EN','Test'),
('00817','BLOCK Testmandant CH','Test')




 ) Mandants (Name, Descript, Region)