declare @StockPicked  as int

set @StockPicked = 1

SELECT

	TEMP.[1]															[Mandant Code]
	,BX_M.Descript														[Mandant Descript]
	,TEMP.[2]															[Periode Year]
	,TEMP.[3]															[Periode Month]
	    ,SUM(TEMP.[6])										            	[bestellte Aufträge Stk.]
	,SUM(TEMP.[7])											            [Anzahl Böden Stk.]
	,CASE 
		WHEN SUM(TEMP.[8]) > 0 
			THEN (SUM(TEMP.[8]) * 1.0) / (SUM(TEMP.[7]) * 1.0) * 100.0
		ELSE 0 
	END																	[davon ConPals proc]
	,SUM(TEMP.[9])											[Bodenverpackungen Gesamt kg]
	,SUM(TEMP.[10])						                    [Anzahl Kiste Stk.]
	,CASE 
		WHEN SUM(TEMP.[11]) > 0 
			THEN (SUM(TEMP.[11]) * 1.0) / (SUM(TEMP.[10]) * 1.0) * 100.0
		ELSE 0
	END																	[davon ConBox proc]
	,SUM(TEMP.[12])											[Kistenverpackungen Gesamt kg]
	,SUM(TEMP.[13])											[Sonderbau kg]
	,SUM(TEMP.[14])											[Schwergut, ab 10.000 kg m2]
	,SUM(TEMP.[15])				[SPH Kisten bis 500 kg kg]
	,SUM(TEMP.[16])				[SPH Kisten bis 500 kg m2]
	,SUM(TEMP.[17])				[SPH Kisten bis 1000 kg kg]
	,SUM(TEMP.[18])				[SPH Kisten bis 1000 kg m2]
	,SUM(TEMP.[19])				[SPH Kisten bis 5000 kg kg]
	,SUM(TEMP.[20])				[SPH Kisten bis 5000 kg m2]
	,SUM(TEMP.[21])				[SPH Kisten bis 10000 kg kg]
	,SUM(TEMP.[22])				[SPH Kisten bis 10000 kg m2]
	,SUM(TEMP.[23])				[SPH Kisten ab 10000 kg kg]
	,SUM(TEMP.[24])				[SPH Kisten ab 10000 kg m2]
	,SUM(TEMP.[25])				[OSB Kisten bis 500 kg kg]
	,SUM(TEMP.[26])				[OSB Kisten bis 500 kg m2]
	,SUM(TEMP.[27])				[OSB Kisten bis 1000 kg kg]
	,SUM(TEMP.[28])				[OSB Kisten bis 1000 kg m2]
	,SUM(TEMP.[29])				[OSB Kisten bis 5000 kg kg]
	,SUM(TEMP.[30])				[OSB Kisten bis 5000 kg m2]
	,SUM(TEMP.[31])				[OSB Kisten bis 10000 kg kg]
	,SUM(TEMP.[32])				[OSB Kisten bis 10000 kg m2]
	,SUM(TEMP.[33])				[OSB Kisten ab 10000 kg kg]
	,SUM(TEMP.[34])				[OSB Kisten ab 10000 kg m2]
	,SUM(TEMP.[35])			    [Vollholzkiste bis 1000 kg kg]
	,SUM(TEMP.[36])			    [Vollholzkiste bis 1000 kg m2]
	,SUM(TEMP.[37])			    [Vollholzkiste bis 5000 kg kg]
	,SUM(TEMP.[38])			    [Vollholzkiste bis 5000 kg m2]
	,SUM(TEMP.[39])			    [Vollholzkiste bis 10000 kg kg]
	,SUM(TEMP.[40])			    [Vollholzkiste bis 10000 kg m2]
	,SUM(TEMP.[41])			    [Vollholzkiste ab 10000 kg kg]
	,SUM(TEMP.[42])			    [Vollholzkiste ab 10000 kg m2]
	,MAX(TEMP.[43])							[Verpackungsperformance m2divMA]
	,SUM(TEMP.[44])							                                                	[SPH Kiste EUR]
	,CASE 
		WHEN (SUM(TEMP.[16]) + SUM(TEMP.[18]) + SUM(TEMP.[20]) + SUM(TEMP.[22]) + SUM(TEMP.[24])) = 0 
			THEN 0 
		ELSE
			SUM(TEMP.[44]) / (SUM(TEMP.[16]) + SUM(TEMP.[18]) + SUM(TEMP.[20]) + SUM(TEMP.[22]) + SUM(TEMP.[24]))
	END																										[m2 SPH Kiste EUR]
	,SUM(TEMP.[45])								                                                [OSB Kiste EUR]
	,CASE 
		WHEN (SUM(TEMP.[26]) + SUM(TEMP.[28]) + SUM(TEMP.[30]) + SUM(TEMP.[32]) + SUM(TEMP.[34])) = 0 
			THEN 0 
		ELSE
			SUM(TEMP.[45]) / (SUM(TEMP.[26]) + SUM(TEMP.[28]) + SUM(TEMP.[30]) + SUM(TEMP.[32]) + SUM(TEMP.[34]))	
	END																										[m2 OSB Kiste EUR]
	,SUM(TEMP.[46])						                                                    	[Vollholzkiste EUR]
	,CASE 
		WHEN (SUM(TEMP.[36]) + SUM(TEMP.[38]) + SUM(TEMP.[40]) + SUM(TEMP.[42])) = 0 
			THEN 0 
		ELSE
			SUM(TEMP.[46]) / (SUM(TEMP.[36]) + SUM(TEMP.[38]) + SUM(TEMP.[40]) + SUM(TEMP.[42]))	
	END																										[m2 Vollholzkiste EUR]
	,SUM(TEMP.[47])							                                                	[Sonderbau EUR]
	,CASE
		WHEN SUM(TEMP.[13]) = 0
			THEN 0
		ELSE
			SUM(TEMP.[47]) / SUM(TEMP.[13])
	END																										[kg Sonderbau EUR]
	,MAX(TEMP.[48])																                            [Innovation (KVP Vorschläge) Stk.]
	,MAX(TEMP.[49])																                            [int. Schadensmeldungen Stk.]
	,MAX(TEMP.[50])																                            [int. Schadenshöhe Tsd. EUR]
	,MAX(TEMP.[51])															                            	[int. Schulungsbedarf proc]
	,MAX(TEMP.[52])														                                    [Konstruktion - Schulungsbedarf proc]
	,SUM(TEMP.[53] * 1.0) / SUM(TEMP.[6] * 1.0)				                                    [Liefertreue nicht geschaft proc von Gesamtaufträge]
	,SUM(TEMP.[54] * 1.0) / SUM(TEMP.[6] * 1.0)						                            [Bestell-Zeitfenster Tage]
	,MAX(TEMP.[55])																                            [Kundenzufriedenheit Faktor]

FROM (
	SELECT 
	
		SUBSTRING (BX_BO.Code,1,5) [1]--Mandant Code
		,YEAR(BX_BO.OrderCreated) [2]--Periode Year
		,MONTH(BX_BO.OrderCreated) [3]--Periode Month
		,BX_BO.Code [4]--BxCode
		,BX_U.Name [5]--UserName
		,BX_BO.Quantity [6]--bestellte Aufträge [Stk.]
		,CASE 
			WHEN BX_B.FloorOnly = 0 AND BX_BO.SpecialConstruction = 0 
				THEN BX_BO.Quantity
			ELSE 0
		END [7]--Anzahl Böden [Stk.]
		,CASE 
			WHEN BX_B.FloorOnly = 0 AND (BX_BO.BuildingMode like 'ConPal%' OR BX_BO.BoxContent like '%ConPal%') AND BX_BO.SpecialConstruction = 0 
				THEN BX_BO.Quantity
			ELSE 0
		END [8]--davon ConPals [%]
		,CASE 
			WHEN BX_B.FloorOnly = 0 AND BX_BO.SpecialConstruction = 0
				THEN BX_BO.Quantity * (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight) 
			ELSE 0 
		END [9]--Bodenverpackungen Gesamt [kg]
		,CASE 
			WHEN BX_B.FloorOnly = 1 AND BX_BO.SpecialConstruction = 0 
				THEN BX_BO.Quantity
			ELSE 0
		END [10]--Anzahl Kiste [Stk.]
		,CASE 
			WHEN BX_B.FloorOnly = 1 AND (BX_BO.BuildingMode like 'ConBox%' OR BX_BO.BoxContent like '%ConBox%')  AND BX_BO.SpecialConstruction = 0 
				THEN BX_BO.Quantity
			ELSE 0
		END [11]--davon ConBox [%]
		,CASE 
			WHEN BX_B.FloorOnly = 1 AND BX_BO.SpecialConstruction = 0
				THEN BX_BO.Quantity * (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight)
				--BX_BO.Quantity * FLOOR(2 * (((ROUND((CONVERT(FLOAT, BX_B.OuterLength) /10 + 0.49), 0) * 10) * (ROUND((CONVERT(FLOAT, BX_B.OuterWidth) /10 + 0.49), 0) * 10)) + ((ROUND((CONVERT(FLOAT, BX_B.OuterWidth) /10 + 0.49), 0) * 10) * (ROUND((CONVERT(FLOAT,  BX_B.OuterHeight) /10 + 0.49), 0) * 10)) + ((ROUND((CONVERT(FLOAT, BX_B.OuterLength) /10 + 0.49), 0) * 10) * (ROUND((CONVERT(FLOAT,  BX_B.OuterHeight) /10 + 0.49), 0) * 10))) / 100000 + 0.5) /10 
			ELSE 0
		END [12]--Kistenverpackungen Gesamt [kg]
		,CASE 
			WHEN BX_BO.SpecialConstruction = 1 
				THEN BX_BO.Quantity * (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight) --(BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight) -- (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight + BX_B.AddendumWeight)
			ELSE 0 
		END [13]--Sonderbau [kg]
		
		,CASE 
			WHEN BX_B.Netto >= 10000 
				THEN BX_BO.Quantity * ([schwgeu_anz] * [schwgeu_dick] * [schwgeu_lang] / 100000.00  + [schwgeo_anz] * [schwgeo_dick] * [schwgeo_lang] / 100000.00)
			ELSE 0 
		END [14]--Schwergut, ab 10.000 kg [m2]
		,CASE 
			WHEN BX_B.Netto <= 500 AND BX_B.IDSideArt IN (3) THEN 
				BX_BO.Quantity * (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight) --(BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight)		-- (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight + BX_B.AddendumWeight) 
			ELSE 0
		END [15]--SPH Kisten bis 500 kg [kg]

		,CASE 
			WHEN BX_B.Netto <= 500 AND BX_B.IDSideArt IN (3) THEN 
				CASE 
					WHEN BX_B.FloorOnly = 1 THEN 
						BX_BO.Quantity * FLOOR((2 * ((ROUND((CONVERT(FLOAT, BX_B.OuterLength) /10 + 0.49), 0) * 10) * (ROUND((CONVERT(FLOAT, BX_B.OuterWidth) /10 + 0.49), 0) * 10) + 
						(ROUND((CONVERT(FLOAT, BX_B.OuterWidth) /10 + 0.49), 0) * 10) * (ROUND((CONVERT(FLOAT,  BX_B.OuterHeight) /10 + 0.49), 0) * 10) + 
						(ROUND((CONVERT(FLOAT, BX_B.OuterLength) /10 + 0.49), 0) * 10) * (ROUND((CONVERT(FLOAT,  BX_B.OuterHeight) /10 + 0.49), 0) * 10) )) / 100000 + 0.5)/10 
					ELSE 
						ROUND(CONVERT(FLOAT,((CONVERT(FLOAT,BX_B.OuterLength) * BX_B.OuterWidth) + (2.0 * CONVERT(FLOAT,BX_B.OuterLength) * ( BX_B.OuterHeight - BX_B.InnerHeight)) + (2.0 * CONVERT(FLOAT,BX_B.OuterWidth) * ( BX_B.OuterHeight - BX_B.InnerHeight))))/1000000,1) 
				END
			ELSE 0
		END [16]--SPH Kisten bis 500 kg [m2]

		,CASE 
			WHEN BX_B.Netto > 500 AND  BX_B.Netto <= 1000 AND BX_B.IDSideArt IN (3) THEN 
				BX_BO.Quantity * (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight)		-- (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight + BX_B.AddendumWeight) 
			ELSE 0
		END [17]--SPH Kisten bis 1000 kg [kg]

		,CASE 
			WHEN BX_B.Netto > 500 AND  BX_B.Netto <= 1000 AND BX_B.IDSideArt IN (3) THEN 
				CASE 
					WHEN BX_B.FloorOnly = 1 THEN 
						BX_BO.Quantity * FLOOR((2 * ((ROUND((CONVERT(FLOAT, BX_B.OuterLength) /10 + 0.49), 0) * 10) * (ROUND((CONVERT(FLOAT, BX_B.OuterWidth) /10 + 0.49), 0) * 10) + 
						(ROUND((CONVERT(FLOAT, BX_B.OuterWidth) /10 + 0.49), 0) * 10) * (ROUND((CONVERT(FLOAT,  BX_B.OuterHeight) /10 + 0.49), 0) * 10) + 
						(ROUND((CONVERT(FLOAT, BX_B.OuterLength) /10 + 0.49), 0) * 10) * (ROUND((CONVERT(FLOAT,  BX_B.OuterHeight) /10 + 0.49), 0) * 10) )) / 100000 + 0.5)/10 
					ELSE 
						ROUND(CONVERT(FLOAT,((CONVERT(FLOAT,BX_B.OuterLength) * BX_B.OuterWidth) + (2.0 * CONVERT(FLOAT,BX_B.OuterLength) * ( BX_B.OuterHeight - BX_B.InnerHeight)) + (2.0 * CONVERT(FLOAT,BX_B.OuterWidth) * ( BX_B.OuterHeight - BX_B.InnerHeight))))/1000000,1) 
				END
			ELSE 0
		END [18]--SPH Kisten bis 1000 kg [m2]

		,CASE 
			WHEN BX_B.Netto > 1000 AND  BX_B.Netto <= 5000 AND BX_B.IDSideArt IN (3) THEN 
				BX_BO.Quantity * (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight)		-- (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight + BX_B.AddendumWeight) 
			ELSE 0
		END [19]--SPH Kisten bis 5000 kg [kg]

		,CASE 
			WHEN BX_B.Netto > 1000 AND  BX_B.Netto <= 5000 AND BX_B.IDSideArt IN (3) THEN 
				CASE 
					WHEN BX_B.FloorOnly = 1 THEN 
						BX_BO.Quantity * FLOOR((2 * ((ROUND((CONVERT(FLOAT, BX_B.OuterLength) /10 + 0.49), 0) * 10) * (ROUND((CONVERT(FLOAT, BX_B.OuterWidth) /10 + 0.49), 0) * 10) + 
						(ROUND((CONVERT(FLOAT, BX_B.OuterWidth) /10 + 0.49), 0) * 10) * (ROUND((CONVERT(FLOAT,  BX_B.OuterHeight) /10 + 0.49), 0) * 10) + 
						(ROUND((CONVERT(FLOAT, BX_B.OuterLength) /10 + 0.49), 0) * 10) * (ROUND((CONVERT(FLOAT,  BX_B.OuterHeight) /10 + 0.49), 0) * 10) )) / 100000 + 0.5)/10 
					ELSE 
						ROUND(CONVERT(FLOAT,((CONVERT(FLOAT,BX_B.OuterLength) * BX_B.OuterWidth) + (2.0 * CONVERT(FLOAT,BX_B.OuterLength) * ( BX_B.OuterHeight - BX_B.InnerHeight)) + (2.0 * CONVERT(FLOAT,BX_B.OuterWidth) * ( BX_B.OuterHeight - BX_B.InnerHeight))))/1000000,1) 
				END
			ELSE 0
		END [20]--SPH Kisten bis 5000 kg [m2]

		,CASE 
			WHEN BX_B.Netto > 5000 AND  BX_B.Netto <= 10000 AND BX_B.IDSideArt IN (3) THEN 
				BX_BO.Quantity * (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight)		-- (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight + BX_B.AddendumWeight) 
			ELSE 0
		END [21]--SPH Kisten bis 10000 kg [kg]

		,CASE 
			WHEN BX_B.Netto > 5000 AND  BX_B.Netto <= 10000 AND BX_B.IDSideArt IN (3) THEN 
				CASE 
					WHEN BX_B.FloorOnly = 1 THEN 
						BX_BO.Quantity * FLOOR((2 * ((ROUND((CONVERT(FLOAT, BX_B.OuterLength) /10 + 0.49), 0) * 10) * (ROUND((CONVERT(FLOAT, BX_B.OuterWidth) /10 + 0.49), 0) * 10) + 
						(ROUND((CONVERT(FLOAT, BX_B.OuterWidth) /10 + 0.49), 0) * 10) * (ROUND((CONVERT(FLOAT,  BX_B.OuterHeight) /10 + 0.49), 0) * 10) + 
						(ROUND((CONVERT(FLOAT, BX_B.OuterLength) /10 + 0.49), 0) * 10) * (ROUND((CONVERT(FLOAT,  BX_B.OuterHeight) /10 + 0.49), 0) * 10) )) / 100000 + 0.5)/10 
					ELSE 
						ROUND(CONVERT(FLOAT,((CONVERT(FLOAT,BX_B.OuterLength) * BX_B.OuterWidth) + (2.0 * CONVERT(FLOAT,BX_B.OuterLength) * ( BX_B.OuterHeight - BX_B.InnerHeight)) + (2.0 * CONVERT(FLOAT,BX_B.OuterWidth) * ( BX_B.OuterHeight - BX_B.InnerHeight))))/1000000,1) 
				END
			ELSE 0
		END [22]--SPH Kisten bis 10000 kg [m2]

		,CASE 
			WHEN BX_B.Netto > 10000 AND BX_B.IDSideArt IN (3) THEN 
				BX_BO.Quantity * (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight)		-- (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight + BX_B.AddendumWeight) 
			ELSE 0
		END [23]--SPH Kisten ab 10000 kg [kg]

		,CASE 
			WHEN BX_B.Netto > 10000 AND BX_B.IDSideArt IN (3) THEN 
				CASE 
					WHEN BX_B.FloorOnly = 1 THEN 
						BX_BO.Quantity * FLOOR((2 * ((ROUND((CONVERT(FLOAT, BX_B.OuterLength) /10 + 0.49), 0) * 10) * (ROUND((CONVERT(FLOAT, BX_B.OuterWidth) /10 + 0.49), 0) * 10) + 
						(ROUND((CONVERT(FLOAT, BX_B.OuterWidth) /10 + 0.49), 0) * 10) * (ROUND((CONVERT(FLOAT,  BX_B.OuterHeight) /10 + 0.49), 0) * 10) + 
						(ROUND((CONVERT(FLOAT, BX_B.OuterLength) /10 + 0.49), 0) * 10) * (ROUND((CONVERT(FLOAT,  BX_B.OuterHeight) /10 + 0.49), 0) * 10) )) / 100000 + 0.5)/10 
					ELSE 
						ROUND(CONVERT(FLOAT,((CONVERT(FLOAT,BX_B.OuterLength) * BX_B.OuterWidth) + (2.0 * CONVERT(FLOAT,BX_B.OuterLength) * ( BX_B.OuterHeight - BX_B.InnerHeight)) + (2.0 * CONVERT(FLOAT,BX_B.OuterWidth) * ( BX_B.OuterHeight - BX_B.InnerHeight))))/1000000,1) 
				END
			ELSE 0
		END [24]--SPH Kisten ab 10000 kg [m2]

		,CASE 
			WHEN BX_B.Netto <= 500 AND BX_B.IDSideArt IN (4) THEN 
				BX_BO.Quantity * (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight)		-- (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight + BX_B.AddendumWeight) 
			ELSE 0
		END [25]--OSB Kisten bis 500 kg [kg]

		,CASE 
			WHEN BX_B.Netto <= 500 AND BX_B.IDSideArt IN (4) THEN 
				CASE 
					WHEN BX_B.FloorOnly = 1 THEN 
						BX_BO.Quantity * FLOOR((2 * ((ROUND((CONVERT(FLOAT, BX_B.OuterLength) /10 + 0.49), 0) * 10) * (ROUND((CONVERT(FLOAT, BX_B.OuterWidth) /10 + 0.49), 0) * 10) + 
						(ROUND((CONVERT(FLOAT, BX_B.OuterWidth) /10 + 0.49), 0) * 10) * (ROUND((CONVERT(FLOAT,  BX_B.OuterHeight) /10 + 0.49), 0) * 10) + 
						(ROUND((CONVERT(FLOAT, BX_B.OuterLength) /10 + 0.49), 0) * 10) * (ROUND((CONVERT(FLOAT,  BX_B.OuterHeight) /10 + 0.49), 0) * 10) )) / 100000 + 0.5)/10 
					ELSE 
						ROUND(CONVERT(FLOAT,((CONVERT(FLOAT,BX_B.OuterLength) * BX_B.OuterWidth) + (2.0 * CONVERT(FLOAT,BX_B.OuterLength) * ( BX_B.OuterHeight - BX_B.InnerHeight)) + (2.0 * CONVERT(FLOAT,BX_B.OuterWidth) * ( BX_B.OuterHeight - BX_B.InnerHeight))))/1000000,1) 
				END
			ELSE 0
		END [26]--OSB Kisten bis 500 kg [m2]
	
		,CASE 
			WHEN BX_B.Netto > 500 AND  BX_B.Netto <= 1000 AND BX_B.IDSideArt IN (4) THEN 
				BX_BO.Quantity * (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight)		-- (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight + BX_B.AddendumWeight) 
			ELSE 0
		END [27]--OSB Kisten bis 1000 kg [kg]

		,CASE 
			WHEN BX_B.Netto > 500 AND  BX_B.Netto <= 1000 AND BX_B.IDSideArt IN (4) THEN 
				CASE 
					WHEN BX_B.FloorOnly = 1 THEN 
						BX_BO.Quantity * FLOOR((2 * ((ROUND((CONVERT(FLOAT, BX_B.OuterLength) /10 + 0.49), 0) * 10) * (ROUND((CONVERT(FLOAT, BX_B.OuterWidth) /10 + 0.49), 0) * 10) + 
						(ROUND((CONVERT(FLOAT, BX_B.OuterWidth) /10 + 0.49), 0) * 10) * (ROUND((CONVERT(FLOAT,  BX_B.OuterHeight) /10 + 0.49), 0) * 10) + 
						(ROUND((CONVERT(FLOAT, BX_B.OuterLength) /10 + 0.49), 0) * 10) * (ROUND((CONVERT(FLOAT,  BX_B.OuterHeight) /10 + 0.49), 0) * 10) )) / 100000 + 0.5)/10 
					ELSE 
						ROUND(CONVERT(FLOAT,((CONVERT(FLOAT,BX_B.OuterLength) * BX_B.OuterWidth) + (2.0 * CONVERT(FLOAT,BX_B.OuterLength) * ( BX_B.OuterHeight - BX_B.InnerHeight)) + (2.0 * CONVERT(FLOAT,BX_B.OuterWidth) * ( BX_B.OuterHeight - BX_B.InnerHeight))))/1000000,1) 
				END
			ELSE 0
		END [28]--OSB Kisten bis 1000 kg [m2]

		,CASE 
			WHEN BX_B.Netto > 1000 AND  BX_B.Netto <= 5000 AND BX_B.IDSideArt IN (4) THEN 
				BX_BO.Quantity * (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight)		-- (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight + BX_B.AddendumWeight) 
			ELSE 0
		END [29]--OSB Kisten bis 5000 kg [kg]

		,CASE 
			WHEN BX_B.Netto > 1000 AND  BX_B.Netto <= 5000 AND BX_B.IDSideArt IN (4) THEN 
				CASE 
					WHEN BX_B.FloorOnly = 1 THEN 
						BX_BO.Quantity * FLOOR((2 * ((ROUND((CONVERT(FLOAT, BX_B.OuterLength) /10 + 0.49), 0) * 10) * (ROUND((CONVERT(FLOAT, BX_B.OuterWidth) /10 + 0.49), 0) * 10) + 
						(ROUND((CONVERT(FLOAT, BX_B.OuterWidth) /10 + 0.49), 0) * 10) * (ROUND((CONVERT(FLOAT,  BX_B.OuterHeight) /10 + 0.49), 0) * 10) + 
						(ROUND((CONVERT(FLOAT, BX_B.OuterLength) /10 + 0.49), 0) * 10) * (ROUND((CONVERT(FLOAT,  BX_B.OuterHeight) /10 + 0.49), 0) * 10) )) / 100000 + 0.5)/10 
					ELSE 
						ROUND(CONVERT(FLOAT,((CONVERT(FLOAT,BX_B.OuterLength) * BX_B.OuterWidth) + (2.0 * CONVERT(FLOAT,BX_B.OuterLength) * ( BX_B.OuterHeight - BX_B.InnerHeight)) + (2.0 * CONVERT(FLOAT,BX_B.OuterWidth) * ( BX_B.OuterHeight - BX_B.InnerHeight))))/1000000,1) 
				END
			ELSE 0
		END [30]--OSB Kisten bis 5000 kg [m2]

		,CASE 
			WHEN BX_B.Netto > 5000 AND  BX_B.Netto <= 10000 AND BX_B.IDSideArt IN (4) THEN 
				BX_BO.Quantity * (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight)		-- (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight + BX_B.AddendumWeight) 
			ELSE 0
		END [31]--OSB Kisten bis 10000 kg [kg]

		,CASE 
			WHEN BX_B.Netto > 5000 AND  BX_B.Netto <= 10000 AND BX_B.IDSideArt IN (4) THEN 
				CASE 
					WHEN BX_B.FloorOnly = 1 THEN 
						BX_BO.Quantity * FLOOR((2 * ((ROUND((CONVERT(FLOAT, BX_B.OuterLength) /10 + 0.49), 0) * 10) * (ROUND((CONVERT(FLOAT, BX_B.OuterWidth) /10 + 0.49), 0) * 10) + 
						(ROUND((CONVERT(FLOAT, BX_B.OuterWidth) /10 + 0.49), 0) * 10) * (ROUND((CONVERT(FLOAT,  BX_B.OuterHeight) /10 + 0.49), 0) * 10) + 
						(ROUND((CONVERT(FLOAT, BX_B.OuterLength) /10 + 0.49), 0) * 10) * (ROUND((CONVERT(FLOAT,  BX_B.OuterHeight) /10 + 0.49), 0) * 10) )) / 100000 + 0.5)/10 
					ELSE 
						ROUND(CONVERT(FLOAT,((CONVERT(FLOAT,BX_B.OuterLength) * BX_B.OuterWidth) + (2.0 * CONVERT(FLOAT,BX_B.OuterLength) * ( BX_B.OuterHeight - BX_B.InnerHeight)) + (2.0 * CONVERT(FLOAT,BX_B.OuterWidth) * ( BX_B.OuterHeight - BX_B.InnerHeight))))/1000000,1) 
				END
			ELSE 0
		END [32]--OSB Kisten bis 10000 kg [m2]

		,CASE 
			WHEN BX_B.Netto > 10000 AND BX_B.IDSideArt IN (4) THEN 
				BX_BO.Quantity * (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight)		-- (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight + BX_B.AddendumWeight) 
			ELSE 0
		END [33]--OSB Kisten ab 10000 kg [kg]

		,CASE 
			WHEN BX_B.Netto > 10000 AND BX_B.IDSideArt IN (4) THEN 
				CASE 
					WHEN BX_B.FloorOnly = 1 THEN 
						BX_BO.Quantity * FLOOR((2 * ((ROUND((CONVERT(FLOAT, BX_B.OuterLength) /10 + 0.49), 0) * 10) * (ROUND((CONVERT(FLOAT, BX_B.OuterWidth) /10 + 0.49), 0) * 10) + 
						(ROUND((CONVERT(FLOAT, BX_B.OuterWidth) /10 + 0.49), 0) * 10) * (ROUND((CONVERT(FLOAT,  BX_B.OuterHeight) /10 + 0.49), 0) * 10) + 
						(ROUND((CONVERT(FLOAT, BX_B.OuterLength) /10 + 0.49), 0) * 10) * (ROUND((CONVERT(FLOAT,  BX_B.OuterHeight) /10 + 0.49), 0) * 10) )) / 100000 + 0.5)/10 
					ELSE 
						ROUND(CONVERT(FLOAT,((CONVERT(FLOAT,BX_B.OuterLength) * BX_B.OuterWidth) + (2.0 * CONVERT(FLOAT,BX_B.OuterLength) * ( BX_B.OuterHeight - BX_B.InnerHeight)) + (2.0 * CONVERT(FLOAT,BX_B.OuterWidth) * ( BX_B.OuterHeight - BX_B.InnerHeight))))/1000000,1) 
				END
			ELSE 0
		END [34]--OSB Kisten ab 10000 kg [m2]

		,CASE 
			WHEN BX_B.Netto <= 1000 AND BX_B.IDSideArt IN (1) THEN 
				BX_BO.Quantity * (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight)		-- (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight + BX_B.AddendumWeight) 
			ELSE 0
		END [35]--Vollholzkiste bis 1000 kg [kg]

		,CASE 
			WHEN BX_B.Netto <= 1000 AND BX_B.IDSideArt IN (1) THEN 
				CASE 
					WHEN BX_B.FloorOnly = 1 THEN 
						BX_BO.Quantity * FLOOR((2 * ((ROUND((CONVERT(FLOAT, BX_B.OuterLength) /10 + 0.49), 0) * 10) * (ROUND((CONVERT(FLOAT, BX_B.OuterWidth) /10 + 0.49), 0) * 10) + 
						(ROUND((CONVERT(FLOAT, BX_B.OuterWidth) /10 + 0.49), 0) * 10) * (ROUND((CONVERT(FLOAT,  BX_B.OuterHeight) /10 + 0.49), 0) * 10) + 
						(ROUND((CONVERT(FLOAT, BX_B.OuterLength) /10 + 0.49), 0) * 10) * (ROUND((CONVERT(FLOAT,  BX_B.OuterHeight) /10 + 0.49), 0) * 10) )) / 100000 + 0.5)/10 
					ELSE 
						ROUND(CONVERT(FLOAT,((CONVERT(FLOAT,BX_B.OuterLength) * BX_B.OuterWidth) + (2.0 * CONVERT(FLOAT,BX_B.OuterLength) * ( BX_B.OuterHeight - BX_B.InnerHeight)) + (2.0 * CONVERT(FLOAT,BX_B.OuterWidth) * ( BX_B.OuterHeight - BX_B.InnerHeight))))/1000000,1) 
				END
			ELSE 0
		END [36]--Vollholzkiste bis 1000 kg [m2]

		,CASE 
			WHEN BX_B.Netto > 1000 AND  BX_B.Netto <= 5000 AND BX_B.IDSideArt IN (1) THEN 
				BX_BO.Quantity * (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight)		-- (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight + BX_B.AddendumWeight) 
			ELSE 0
		END [37]--Vollholzkiste bis 5000 kg [kg]

		,CASE 
			WHEN BX_B.Netto > 1000 AND  BX_B.Netto <= 5000 AND BX_B.IDSideArt IN (1) THEN 
				CASE 
					WHEN BX_B.FloorOnly = 1 THEN 
						BX_BO.Quantity * FLOOR((2 * ((ROUND((CONVERT(FLOAT, BX_B.OuterLength) /10 + 0.49), 0) * 10) * (ROUND((CONVERT(FLOAT, BX_B.OuterWidth) /10 + 0.49), 0) * 10) + 
						(ROUND((CONVERT(FLOAT, BX_B.OuterWidth) /10 + 0.49), 0) * 10) * (ROUND((CONVERT(FLOAT,  BX_B.OuterHeight) /10 + 0.49), 0) * 10) + 
						(ROUND((CONVERT(FLOAT, BX_B.OuterLength) /10 + 0.49), 0) * 10) * (ROUND((CONVERT(FLOAT,  BX_B.OuterHeight) /10 + 0.49), 0) * 10) )) / 100000 + 0.5)/10 
					ELSE 
						ROUND(CONVERT(FLOAT,((CONVERT(FLOAT,BX_B.OuterLength) * BX_B.OuterWidth) + (2.0 * CONVERT(FLOAT,BX_B.OuterLength) * ( BX_B.OuterHeight - BX_B.InnerHeight)) + (2.0 * CONVERT(FLOAT,BX_B.OuterWidth) * ( BX_B.OuterHeight - BX_B.InnerHeight))))/1000000,1) 
				END
			ELSE 0
		END [38]--Vollholzkiste bis 5000 kg [m2]

		,CASE 
			WHEN BX_B.Netto > 5000 AND  BX_B.Netto <= 10000 AND BX_B.IDSideArt IN (1) THEN 
				BX_BO.Quantity * (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight)		-- (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight + BX_B.AddendumWeight) 
			ELSE 0
		END [39]--Vollholzkiste bis 10000 kg [kg]

		,CASE 
			WHEN BX_B.Netto > 5000 AND  BX_B.Netto <= 10000 AND BX_B.IDSideArt IN (1) THEN 
				CASE 
					WHEN BX_B.FloorOnly = 1 THEN 
						BX_BO.Quantity * FLOOR((2 * ((ROUND((CONVERT(FLOAT, BX_B.OuterLength) /10 + 0.49), 0) * 10) * (ROUND((CONVERT(FLOAT, BX_B.OuterWidth) /10 + 0.49), 0) * 10) + 
						(ROUND((CONVERT(FLOAT, BX_B.OuterWidth) /10 + 0.49), 0) * 10) * (ROUND((CONVERT(FLOAT,  BX_B.OuterHeight) /10 + 0.49), 0) * 10) + 
						(ROUND((CONVERT(FLOAT, BX_B.OuterLength) /10 + 0.49), 0) * 10) * (ROUND((CONVERT(FLOAT,  BX_B.OuterHeight) /10 + 0.49), 0) * 10) )) / 100000 + 0.5)/10 
					ELSE 
						ROUND(CONVERT(FLOAT,((CONVERT(FLOAT,BX_B.OuterLength) * BX_B.OuterWidth) + (2.0 * CONVERT(FLOAT,BX_B.OuterLength) * ( BX_B.OuterHeight - BX_B.InnerHeight)) + (2.0 * CONVERT(FLOAT,BX_B.OuterWidth) * ( BX_B.OuterHeight - BX_B.InnerHeight))))/1000000,1) 
				END
			ELSE 0
		END [40]--Vollholzkiste bis 10000 kg [m2]

		,CASE 
			WHEN BX_B.Netto > 10000 AND BX_B.IDSideArt IN (1) THEN 
				BX_BO.Quantity * (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight)		-- (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight + BX_B.AddendumWeight) 
			ELSE 0
		END [41]--Vollholzkiste ab 10000 kg [kg]

		,CASE 
			WHEN BX_B.Netto > 10000 AND BX_B.IDSideArt IN (1) THEN 
				CASE 
					WHEN BX_B.FloorOnly = 1 THEN 
						BX_BO.Quantity * FLOOR((2 * ((ROUND((CONVERT(FLOAT, BX_B.OuterLength) /10 + 0.49), 0) * 10) * (ROUND((CONVERT(FLOAT, BX_B.OuterWidth) /10 + 0.49), 0) * 10) + 
						(ROUND((CONVERT(FLOAT, BX_B.OuterWidth) /10 + 0.49), 0) * 10) * (ROUND((CONVERT(FLOAT,  BX_B.OuterHeight) /10 + 0.49), 0) * 10) + 
						(ROUND((CONVERT(FLOAT, BX_B.OuterLength) /10 + 0.49), 0) * 10) * (ROUND((CONVERT(FLOAT,  BX_B.OuterHeight) /10 + 0.49), 0) * 10) )) / 100000 + 0.5)/10 
					ELSE 
						ROUND(CONVERT(FLOAT,((CONVERT(FLOAT,BX_B.OuterLength) * BX_B.OuterWidth) + (2.0 * CONVERT(FLOAT,BX_B.OuterLength) * ( BX_B.OuterHeight - BX_B.InnerHeight)) + (2.0 * CONVERT(FLOAT,BX_B.OuterWidth) * ( BX_B.OuterHeight - BX_B.InnerHeight))))/1000000,1) 
				END
			ELSE 0
		END [42]--Vollholzkiste ab 10000 kg [m2]

		,'-----' [43]--Verpackungsperformance [m2/MA]
	
		,CASE 
			WHEN BX_B.IDSideArt IN (3) AND BX_BO.SpecialConstruction = 0 THEN 
				CASE WHEN OL.Currency NOT IN ('CZK')	
					THEN (ROUND(ISNULL(DFCZCHEB_SIL.[Unit Price],ISNULL(DFCZIVA_SIL.[Unit Price],ISNULL(DNL.Price,OL.CustomerApprovedPrice))), 2)) 
				ELSE (ROUND(ISNULL(DFCZCHEB_SIL.[Unit Price],ISNULL(DFCZIVA_SIL.[Unit Price],ISNULL(DNL.Price,OL.CustomerApprovedPrice)))/25.5, 2))
				END
			ELSE 0
		END [44]--SPH Kiste [€]

		,CASE 
			WHEN BX_B.IDSideArt IN (4) AND BX_BO.SpecialConstruction = 0 THEN 
				CASE WHEN OL.Currency NOT IN ('CZK')	
					THEN (ROUND(ISNULL(DFCZCHEB_SIL.[Unit Price],ISNULL(DFCZIVA_SIL.[Unit Price],ISNULL(DNL.Price,OL.CustomerApprovedPrice))), 2)) 
				ELSE (ROUND(ISNULL(DFCZCHEB_SIL.[Unit Price],ISNULL(DFCZIVA_SIL.[Unit Price],ISNULL(DNL.Price,OL.CustomerApprovedPrice)))/25.5, 2))
				END 
			ELSE 0
		END [45]--OSB Kiste [€]

		,CASE 
			WHEN BX_B.IDSideArt IN (1) AND BX_BO.SpecialConstruction = 0 THEN 
				CASE WHEN OL.Currency NOT IN ('CZK')	
					THEN (ROUND(ISNULL(DFCZCHEB_SIL.[Unit Price],ISNULL(DFCZIVA_SIL.[Unit Price],ISNULL(DNL.Price,OL.CustomerApprovedPrice))), 2)) 
				ELSE (ROUND(ISNULL(DFCZCHEB_SIL.[Unit Price],ISNULL(DFCZIVA_SIL.[Unit Price],ISNULL(DNL.Price,OL.CustomerApprovedPrice)))/25.5, 2))
				END
			ELSE 0
		END [46]--Vollholzkiste [€]

		,CASE 
			WHEN BX_BO.SpecialConstruction = 1 THEN 
				CASE WHEN OL.Currency NOT IN ('CZK')	
					THEN (ROUND(ISNULL(DFCZCHEB_SIL.[Unit Price],ISNULL(DFCZIVA_SIL.[Unit Price],ISNULL(DNL.Price,OL.CustomerApprovedPrice))), 2)) 
				ELSE (ROUND(ISNULL(DFCZCHEB_SIL.[Unit Price],ISNULL(DFCZIVA_SIL.[Unit Price],ISNULL(DNL.Price,OL.CustomerApprovedPrice)))/25.5, 2))
				END
			ELSE 0 
		END [47]--Sonderbau [€]
		,'-----' [48]--Innovation (KVP Vorschläge) [Stk.]
		,'-----' [49]--int. Schadensmeldungen [Stk.]
		,'-----' [50]--int. Schadenshöhe [Tsd. €]
		,'-----' [51]--int. Schulungsbedarf [%]
		,'-----' 	[52]--Konstruktion - Schulungsbedarf [%]
		,CASE 
			WHEN ISNULL(DATEDIFF(DAY,CAST(BX_BO.[DateComplete] AS DATE),ISNULL(CAST(L.[Date] AS DATE),ISNULL(CAST(DNH.DeliveryDate AS DATE),CAST(OH.[CompletingDate] AS DATE)))),0) > 0
				THEN DATEDIFF(DAY,CAST(BX_BO.[DateComplete] AS DATE),ISNULL(CAST(L.[Date] AS DATE),ISNULL(CAST(DNH.DeliveryDate AS DATE),CAST(OH.[CompletingDate] AS DATE))))
			ELSE 0
		END	[53]--Liefertreue nicht geschaft [Tage]
		,ISNULL(DATEDIFF(DAY,CAST(BXOH.ImportDateTime AS DATE),ISNULL(CAST(L.[Date] AS DATE),ISNULL(CAST(DNH.DeliveryDate AS DATE),CAST(OH.[CompletingDate] AS DATE)))),0)
		[54]--Bestell-Zeitfenster [Tage]
		,'-----'  	[55]--Kundenzufriedenheit [Faktor]


	FROM 

					BoxCAD_TEMP.dbo.BoxOrder						AS BX_BO 
		INNER JOIN	BoxCAD_TEMP.dbo.Box								AS BX_B		ON BX_B.IDXOrder = BX_BO.IDX
		INNER JOIN	BoxCAD_TEMP.dbo.Parameters						AS BX_P		ON BX_P.IDXBox = BX_B.IDX
		INNER JOIN	BoxCAD_TEMP.dbo.AddendumMaterial				AS BX_ADDM	ON BX_ADDM.IDXOrder = BX_BO.IDX
		LEFT JOIN	BoxCAD_TEMP.dbo.Users							AS BX_U		ON BX_U.IDX = BX_BO.IDXUser
		INNER JOIN	LoadBalancer_TEMP.dbo.OrderLine					AS OL		ON OL.BxOrderCode COLLATE DATABASE_DEFAULT = BX_BO.Code COLLATE DATABASE_DEFAULT 
		INNER JOIN	LoadBalancer_TEMP.dbo.OrderHeader				AS OH		ON OH.ID = OL.OrderHeaderID
		INNER JOIN	LoadBalancer_TEMP.dbo.BXOrderHeader				AS BXOH		ON BXOH.ID = OL.BXOrderHeaderID
		LEFT JOIN	LoadBalancer_TEMP.dbo.DeliveryNoteLine			AS DNL		ON DNL.OrderLineID = OL.ID
		LEFT JOIN	LoadBalancer_TEMP.dbo.DeliveryNoteHeader		AS DNH		ON DNH.ID = DNL.DeliveryNoteHeaderID
		LEFT JOIN	LoadBalancer_TEMP.dbo.LoadingDestination		AS LD		ON LD.OrderLineID = OL.ID AND LD.Valid = 1
		LEFT JOIN	LoadBalancer_TEMP.dbo.Loading					AS L		ON L.ID = LD.LoadingID
		LEFT JOIN	[DFCZE_NAV100CZ_PRD_TEMP].[dbo].[Deufol CZ Production, s_r_o_$Sales Invoice Line] AS DFCZCHEB_SIL	ON DFCZCHEB_SIL.[LB BoxCAD Code] COLLATE DATABASE_DEFAULT = BX_BO.Code COLLATE DATABASE_DEFAULT
		LEFT JOIN	[DFCZE_NAV100CZ_PRD_TEMP].[dbo].[Deufol CZ Production, s_r_o_$Sales Invoice Header] AS DFCZCHEB_SIH	ON DFCZCHEB_SIH.No_ = DFCZCHEB_SIL.[Document No_]
		LEFT JOIN	[DFCZE_NAV100CZ_PRD_TEMP].[dbo].[Deufol Česká republika a_ s_$Sales Invoice Line] AS DFCZIVA_SIL		ON DFCZIVA_SIL.[LB BoxCAD Code] COLLATE DATABASE_DEFAULT = BX_BO.Code COLLATE DATABASE_DEFAULT
		LEFT JOIN	[DFCZE_NAV100CZ_PRD_TEMP].[dbo].[Deufol Česká republika a_ s_$Sales Invoice Header] AS DFCZIVA_SIH	ON DFCZIVA_SIH.[No_] = DFCZIVA_SIL.[Document No_]

	
where BX_BO.IDOrderState IN (32,50) AND BX_BO.OrderCreated between '2018-12-01' AND '2019-03-01' and


(((case when @StockPicked = 0 AND OL.StockPicked = 0 then 1 else 0 end ) = 1 )
or
((case when @StockPicked = 1 then 1 else 0 end) = 1 ))


) AS TEMP
INNER JOIN  [BoxCAD_TEMP].[dbo].[Mandants]	AS BX_M		ON BX_M.Name = TEMP.[1]


GROUP BY
	TEMP.[1]
	,BX_M.Descript
	,TEMP.[2]
	,TEMP.[3]