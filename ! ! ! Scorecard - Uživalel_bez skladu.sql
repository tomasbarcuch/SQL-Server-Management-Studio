----------------------------------------------------------------------------------------------------------------------------------------------------------------
---------- DECLARE ---------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------

DECLARE @kurz	FLOAT = 25.5

----------------------------------------------------------------------------------------------------------------------------------------------------------------
---------- SELECT ----------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT
	--top 1
	TEMP.[Mandant Code]																						AS 'Mandant Code'
	,BX_M.Descript																							AS 'Mandant Descript'
	,TEMP.[Periode Year]																					AS 'Periode Year'
	,TEMP.[Periode Month]																					AS 'Periode Month'
	,TEMP.UserName																							AS 'User Name'

	----------------------------------------------------------------------------------------------------------------------------------------------------------------
	---------- AUFTRÄGE --------------------------------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------------------------------------------------

	,CONVERT(FLOAT,CAST(ROUND(SUM(TEMP.[bestellte Aufträge [Stk.]]]), 2) AS DECIMAL(12,2)))					AS 'bestellte Aufträge [Stk.]'
	,CONVERT(FLOAT,CAST(ROUND(SUM(TEMP.[Anzahl Böden [Stk.]]]), 2) AS DECIMAL(12,2)))						AS 'Anzahl Böden [Stk.]'
	,CASE 
		WHEN SUM(TEMP.[davon ConPals [%]]]) > 0 
			THEN CONVERT(FLOAT,CAST(ROUND((SUM(TEMP.[davon ConPals [%]]]) * 1.0) / (SUM(TEMP.[Anzahl Böden [Stk.]]]) * 1.0) * 100.0, 2) AS DECIMAL(12,2))) 
		ELSE 0 
	END																										AS 'davon ConPals [%]'
	,CONVERT(FLOAT,CAST(ROUND(SUM(TEMP.[Bodenverpackungen Gesamt [kg]]]), 2) AS DECIMAL(12,2)))				AS 'Bodenverpackungen Gesamt [kg]'
	,CONVERT(FLOAT,CAST(ROUND(SUM(TEMP.[Anzahl Kiste [Stk.]]]), 2) AS DECIMAL(12,2)))						AS 'Anzahl Kiste [Stk.]'
	,CASE 
		WHEN SUM(TEMP.[davon ConBox [%]]]) > 0 
			THEN CONVERT(FLOAT,CAST(ROUND((SUM(TEMP.[davon ConBox [%]]]) * 1.0) / (SUM(TEMP.[Anzahl Kiste [Stk.]]]) * 1.0) * 100.0, 2) AS DECIMAL(12,2)))
		ELSE 0
	END																										AS 'davon ConBox [%]'
	,CONVERT(FLOAT,CAST(ROUND(SUM(TEMP.[Kistenverpackungen Gesamt [kg]]]), 2) AS DECIMAL(12,2)))			AS 'Kistenverpackungen Gesamt [kg]'
	,CONVERT(FLOAT,CAST(ROUND(SUM(TEMP.[Sonderbau [kg]]]), 2) AS DECIMAL(12,2)))							AS 'Sonderbau [kg]'
	,CONVERT(FLOAT,CAST(ROUND(SUM(TEMP.[Schwergut, ab 10.000 kg [m2]]]), 2) AS DECIMAL(12,2)))				AS 'Schwergut, ab 10.000 kg [m2]'

	----------------------------------------------------------------------------------------------------------------------------------------------------------------
	---------- PERFORMANCE -----------------------------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------------------------------------------------

	,CONVERT(FLOAT,CAST(ROUND(SUM(TEMP.[SPH Kisten bis 500 kg [kg]]]), 2) AS DECIMAL(12,2)))				AS 'SPH Kisten bis 500 kg [kg]'
	,CONVERT(FLOAT,CAST(ROUND(SUM(TEMP.[SPH Kisten bis 500 kg [m2]]]), 2) AS DECIMAL(12,2)))				AS 'SPH Kisten bis 500 kg [m2]'
	,CONVERT(FLOAT,CAST(ROUND(SUM(TEMP.[SPH Kisten bis 1000 kg [kg]]]), 2) AS DECIMAL(12,2)))				AS 'SPH Kisten bis 1000 kg [kg]'
	,CONVERT(FLOAT,CAST(ROUND(SUM(TEMP.[SPH Kisten bis 1000 kg [m2]]]), 2) AS DECIMAL(12,2)))				AS 'SPH Kisten bis 1000 kg [m2]'
	,CONVERT(FLOAT,CAST(ROUND(SUM(TEMP.[SPH Kisten bis 5000 kg [kg]]]), 2) AS DECIMAL(12,2)))				AS 'SPH Kisten bis 5000 kg [kg]'
	,CONVERT(FLOAT,CAST(ROUND(SUM(TEMP.[SPH Kisten bis 5000 kg [m2]]]), 2) AS DECIMAL(12,2)))				AS 'SPH Kisten bis 5000 kg [m2]'
	,CONVERT(FLOAT,CAST(ROUND(SUM(TEMP.[SPH Kisten bis 10000 kg [kg]]]), 2) AS DECIMAL(12,2)))				AS 'SPH Kisten bis 10000 kg [kg]'
	,CONVERT(FLOAT,CAST(ROUND(SUM(TEMP.[SPH Kisten bis 10000 kg [m2]]]), 2) AS DECIMAL(12,2)))				AS 'SPH Kisten bis 10000 kg [m2]'
	,CONVERT(FLOAT,CAST(ROUND(SUM(TEMP.[SPH Kisten ab 10000 kg [kg]]]), 2) AS DECIMAL(12,2)))				AS 'SPH Kisten ab 10000 kg [kg]'
	,CONVERT(FLOAT,CAST(ROUND(SUM(TEMP.[SPH Kisten ab 10000 kg [m2]]]), 2) AS DECIMAL(12,2)))				AS 'SPH Kisten ab 10000 kg [m2]'
	,CONVERT(FLOAT,CAST(ROUND(SUM(TEMP.[OSB Kisten bis 500 kg [kg]]]), 2) AS DECIMAL(12,2)))				AS 'OSB Kisten bis 500 kg [kg]'
	,CONVERT(FLOAT,CAST(ROUND(SUM(TEMP.[OSB Kisten bis 500 kg [m2]]]), 2) AS DECIMAL(12,2)))				AS 'OSB Kisten bis 500 kg [m2]'
	,CONVERT(FLOAT,CAST(ROUND(SUM(TEMP.[OSB Kisten bis 1000 kg [kg]]]), 2) AS DECIMAL(12,2)))				AS 'OSB Kisten bis 1000 kg [kg]'
	,CONVERT(FLOAT,CAST(ROUND(SUM(TEMP.[OSB Kisten bis 1000 kg [m2]]]), 2) AS DECIMAL(12,2)))				AS 'OSB Kisten bis 1000 kg [m2]'
	,CONVERT(FLOAT,CAST(ROUND(SUM(TEMP.[OSB Kisten bis 5000 kg [kg]]]), 2) AS DECIMAL(12,2)))				AS 'OSB Kisten bis 5000 kg [kg]'
	,CONVERT(FLOAT,CAST(ROUND(SUM(TEMP.[OSB Kisten bis 5000 kg [m2]]]), 2) AS DECIMAL(12,2)))				AS 'OSB Kisten bis 5000 kg [m2]'
	,CONVERT(FLOAT,CAST(ROUND(SUM(TEMP.[OSB Kisten bis 10000 kg [kg]]]), 2) AS DECIMAL(12,2)))				AS 'OSB Kisten bis 10000 kg [kg]'
	,CONVERT(FLOAT,CAST(ROUND(SUM(TEMP.[OSB Kisten bis 10000 kg [m2]]]), 2) AS DECIMAL(12,2)))				AS 'OSB Kisten bis 10000 kg [m2]'
	,CONVERT(FLOAT,CAST(ROUND(SUM(TEMP.[OSB Kisten ab 10000 kg [kg]]]), 2) AS DECIMAL(12,2)))				AS 'OSB Kisten ab 10000 kg [kg]'
	,CONVERT(FLOAT,CAST(ROUND(SUM(TEMP.[OSB Kisten ab 10000 kg [m2]]]), 2) AS DECIMAL(12,2)))				AS 'OSB Kisten ab 10000 kg [m2]'
	,CONVERT(FLOAT,CAST(ROUND(SUM(TEMP.[Vollholzkiste bis 1000 kg [kg]]]), 2) AS DECIMAL(12,2)))			AS 'Vollholzkiste bis 1000 kg [kg]'
	,CONVERT(FLOAT,CAST(ROUND(SUM(TEMP.[Vollholzkiste bis 1000 kg [m2]]]), 2) AS DECIMAL(12,2)))			AS 'Vollholzkiste bis 1000 kg [m2]'
	,CONVERT(FLOAT,CAST(ROUND(SUM(TEMP.[Vollholzkiste bis 5000 kg [kg]]]), 2) AS DECIMAL(12,2)))			AS 'Vollholzkiste bis 5000 kg [kg]'
	,CONVERT(FLOAT,CAST(ROUND(SUM(TEMP.[Vollholzkiste bis 5000 kg [m2]]]), 2) AS DECIMAL(12,2)))			AS 'Vollholzkiste bis 5000 kg [m2]'
	,CONVERT(FLOAT,CAST(ROUND(SUM(TEMP.[Vollholzkiste bis 10000 kg [kg]]]), 2) AS DECIMAL(12,2)))			AS 'Vollholzkiste bis 10000 kg [kg]'
	,CONVERT(FLOAT,CAST(ROUND(SUM(TEMP.[Vollholzkiste bis 10000 kg [m2]]]), 2) AS DECIMAL(12,2)))			AS 'Vollholzkiste bis 10000 kg [m2]'
	,CONVERT(FLOAT,CAST(ROUND(SUM(TEMP.[Vollholzkiste ab 10000 kg [kg]]]), 2) AS DECIMAL(12,2)))			AS 'Vollholzkiste ab 10000 kg [kg]'
	,CONVERT(FLOAT,CAST(ROUND(SUM(TEMP.[Vollholzkiste ab 10000 kg [m2]]]), 2) AS DECIMAL(12,2)))			AS 'Vollholzkiste ab 10000 kg [m2]'
	,MAX(TEMP.[Verpackungsperformance [m2/MA]]])															AS 'Verpackungsperformance [m2/MA]'

	----------------------------------------------------------------------------------------------------------------------------------------------------------------
	---------- KOSTEN ----------------------------------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	,CONVERT(FLOAT,CAST(ROUND(SUM(TEMP.[SPH Kiste [€]]]), 2) AS DECIMAL(12,2)))								AS 'SPH Kiste [€]'
	,CASE 
		WHEN (SUM(TEMP.[SPH Kisten bis 500 kg [m2]]]) + SUM(TEMP.[SPH Kisten bis 1000 kg [m2]]]) + SUM(TEMP.[SPH Kisten bis 5000 kg [m2]]]) + SUM(TEMP.[SPH Kisten bis 10000 kg [m2]]]) + SUM(TEMP.[SPH Kisten ab 10000 kg [m2]]])) = 0 
			THEN 0 
		ELSE
			CONVERT(FLOAT,CAST(ROUND(SUM(TEMP.[SPH Kiste [€]]]) / (SUM(TEMP.[SPH Kisten bis 500 kg [m2]]]) + SUM(TEMP.[SPH Kisten bis 1000 kg [m2]]]) + SUM(TEMP.[SPH Kisten bis 5000 kg [m2]]]) + SUM(TEMP.[SPH Kisten bis 10000 kg [m2]]]) + SUM(TEMP.[SPH Kisten ab 10000 kg [m2]]])), 2) AS DECIMAL(12,2)))
	END																										AS 'm2 SPH Kiste [€]'
	,CONVERT(FLOAT,CAST(ROUND(SUM(TEMP.[OSB Kiste [€]]]), 2) AS DECIMAL(12,2)))								AS 'OSB Kiste [€]'
	,CASE 
		WHEN (SUM(TEMP.[OSB Kisten bis 500 kg [m2]]]) + SUM(TEMP.[OSB Kisten bis 1000 kg [m2]]]) + SUM(TEMP.[OSB Kisten bis 5000 kg [m2]]]) + SUM(TEMP.[OSB Kisten bis 10000 kg [m2]]]) + SUM(TEMP.[OSB Kisten ab 10000 kg [m2]]])) = 0 
			THEN 0 
		ELSE
			CONVERT(FLOAT,CAST(ROUND(SUM(TEMP.[OSB Kiste [€]]]) / (SUM(TEMP.[OSB Kisten bis 500 kg [m2]]]) + SUM(TEMP.[OSB Kisten bis 1000 kg [m2]]]) + SUM(TEMP.[OSB Kisten bis 5000 kg [m2]]]) + SUM(TEMP.[OSB Kisten bis 10000 kg [m2]]]) + SUM(TEMP.[OSB Kisten ab 10000 kg [m2]]])), 2) AS DECIMAL(12,2)))	
	END																										AS 'm2 OSB Kiste [€]'
	,CONVERT(FLOAT,CAST(ROUND(SUM(TEMP.[Vollholzkiste [€]]]), 2) AS DECIMAL(12,2)))							AS 'Vollholzkiste [€]'
	,CASE 
		WHEN (SUM(TEMP.[Vollholzkiste bis 1000 kg [m2]]]) + SUM(TEMP.[Vollholzkiste bis 5000 kg [m2]]]) + SUM(TEMP.[Vollholzkiste bis 10000 kg [m2]]]) + SUM(TEMP.[Vollholzkiste ab 10000 kg [m2]]])) = 0 
			THEN 0 
		ELSE
			CONVERT(FLOAT,CAST(ROUND(SUM(TEMP.[Vollholzkiste [€]]]) / (SUM(TEMP.[Vollholzkiste bis 1000 kg [m2]]]) + SUM(TEMP.[Vollholzkiste bis 5000 kg [m2]]]) + SUM(TEMP.[Vollholzkiste bis 10000 kg [m2]]]) + SUM(TEMP.[Vollholzkiste ab 10000 kg [m2]]])), 2) AS DECIMAL(12,2)))	
	END																										AS 'm2 Vollholzkiste [€]'
	,CONVERT(FLOAT,CAST(ROUND(SUM(TEMP.[Sonderbau [€]]]), 2) AS DECIMAL(12,2)))								AS 'Sonderbau [€]'
	,CASE
		WHEN SUM(TEMP.[Sonderbau [kg]]]) = 0
			THEN 0
		ELSE
			CONVERT(FLOAT,CAST(ROUND(SUM(TEMP.[Sonderbau [€]]]) / SUM(TEMP.[Sonderbau [kg]]]), 2) AS DECIMAL(12,2)))
	END																										AS 'kg Sonderbau [€]'

	----------------------------------------------------------------------------------------------------------------------------------------------------------------
	---------- QUALITÄT --------------------------------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------------------------------------------------	

	,MAX(TEMP.[Innovation (KVP Vorschläge) [Stk.]]])														AS 'Innovation (KVP Vorschläge) [Stk.]'
	,MAX(TEMP.[int. Schadensmeldungen [Stk.]]])																AS 'int. Schadensmeldungen [Stk.]'
	,MAX(TEMP.[int. Schadenshöhe [Tsd. €]]])																AS 'int. Schadenshöhe [Tsd. €]'
	,MAX(TEMP.[int. Schulungsbedarf [%]]])																	AS 'int. Schulungsbedarf [%]'

	----------------------------------------------------------------------------------------------------------------------------------------------------------------
	---------- KUNDENBEZUG -----------------------------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------------------------------------------------

	,MAX(TEMP.[Konstruktion - Schulungsbedarf [%]]])														AS 'Konstruktion - Schulungsbedarf [%]'
	,CONVERT(FLOAT,CAST(ROUND(SUM(TEMP.[Liefertreue nicht geschaft [Tage]]] * 1.0) / SUM(TEMP.[bestellte Aufträge [Stk.]]] * 1.0), 2) AS DECIMAL(12,2)))				AS 'Liefertreue nicht geschaft [% von Gesamtaufträge]'
	,CONVERT(FLOAT,CAST(ROUND(SUM(TEMP.[Bestell-Zeitfenster [Tage]]] * 1.0) / SUM(TEMP.[bestellte Aufträge [Stk.]]] * 1.0), 2) AS DECIMAL(12,2)))						AS 'Bestell-Zeitfenster [Tage]'
	,MAX(TEMP.[Kundenzufriedenheit [Faktor]]])																AS 'Kundenzufriedenheit [Faktor]'




----------------------------------------------------------------------------------------------------------------------------------------------------------------
---------- FROM ------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------

FROM (
	SELECT 
		--TOP (100) 
		SUBSTRING (BX_BO.Code,1,5) AS 'Mandant Code'
		,YEAR(BX_BO.OrderCreated) AS 'Periode Year'
		,MONTH(BX_BO.OrderCreated) AS 'Periode Month'

		----------------------------------------------------------------------------------------------------------------------------------------------------------------
		---------- AUFTRÄGE --------------------------------------------------------------------------------------------------------------------------------------------
		----------------------------------------------------------------------------------------------------------------------------------------------------------------
	
		,BX_BO.Code AS 'BxCode'
		,BX_U.Name AS 'UserName'
		,BX_BO.Quantity AS 'bestellte Aufträge [Stk.]'
		,CASE 
			WHEN BX_B.FloorOnly = 0 AND BX_BO.SpecialConstruction = 0 
				THEN BX_BO.Quantity
			ELSE 0
		END AS 'Anzahl Böden [Stk.]'
		,CASE 
			WHEN BX_B.FloorOnly = 0 AND (BX_BO.BuildingMode like 'ConPal%' OR BX_BO.BoxContent like '%ConPal%') AND BX_BO.SpecialConstruction = 0 
				THEN BX_BO.Quantity
			ELSE 0
		END AS 'davon ConPals [%]'
		,CASE 
			WHEN BX_B.FloorOnly = 0 AND BX_BO.SpecialConstruction = 0
				THEN BX_BO.Quantity * (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight) 
			ELSE 0 
		END AS 'Bodenverpackungen Gesamt [kg]'
		,CASE 
			WHEN BX_B.FloorOnly = 1 AND BX_BO.SpecialConstruction = 0 
				THEN BX_BO.Quantity
			ELSE 0
		END AS 'Anzahl Kiste [Stk.]'
		,CASE 
			WHEN BX_B.FloorOnly = 1 AND (BX_BO.BuildingMode like 'ConBox%' OR BX_BO.BoxContent like '%ConBox%')  AND BX_BO.SpecialConstruction = 0 
				THEN BX_BO.Quantity
			ELSE 0
		END AS 'davon ConBox [%]'
		,CASE 
			WHEN BX_B.FloorOnly = 1 AND BX_BO.SpecialConstruction = 0
				THEN BX_BO.Quantity * (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight)
				--BX_BO.Quantity * FLOOR(2 * (((ROUND((CONVERT(FLOAT, BX_B.OuterLength) /10 + 0.49), 0) * 10) * (ROUND((CONVERT(FLOAT, BX_B.OuterWidth) /10 + 0.49), 0) * 10)) + ((ROUND((CONVERT(FLOAT, BX_B.OuterWidth) /10 + 0.49), 0) * 10) * (ROUND((CONVERT(FLOAT,  BX_B.OuterHeight) /10 + 0.49), 0) * 10)) + ((ROUND((CONVERT(FLOAT, BX_B.OuterLength) /10 + 0.49), 0) * 10) * (ROUND((CONVERT(FLOAT,  BX_B.OuterHeight) /10 + 0.49), 0) * 10))) / 100000 + 0.5) /10 
			ELSE 0
		END AS 'Kistenverpackungen Gesamt [kg]'
		,CASE 
			WHEN BX_BO.SpecialConstruction = 1 
				THEN BX_BO.Quantity * (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight) --(BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight) -- (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight + BX_B.AddendumWeight)
			ELSE 0 
		END AS 'Sonderbau [kg]'
		/*,CASE 
			WHEN BX_B.Netto < 10000 
				THEN BX_BO.Quantity * ([schwgeu_anz] * [schwgeu_dick] * [schwgeu_lang] / 100000.00  + [schwgeo_anz] * [schwgeo_dick] * [schwgeo_lang] / 100000.00)
			ELSE 0 
		END AS 'Schwergut, bis 10.000 kg [m2]'*/
		,CASE 
			WHEN BX_B.Netto >= 10000 
				THEN BX_BO.Quantity * ([schwgeu_anz] * [schwgeu_dick] * [schwgeu_lang] / 100000.00  + [schwgeo_anz] * [schwgeo_dick] * [schwgeo_lang] / 100000.00)
			ELSE 0 
		END AS 'Schwergut, ab 10.000 kg [m2]'
	
		----------------------------------------------------------------------------------------------------------------------------------------------------------------
		---------- PERFORMANCE -----------------------------------------------------------------------------------------------------------------------------------------
		----------------------------------------------------------------------------------------------------------------------------------------------------------------

		,CASE 
			WHEN BX_B.Netto <= 500 AND BX_B.IDSideArt IN (3) THEN 
				BX_BO.Quantity * (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight) --(BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight)		-- (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight + BX_B.AddendumWeight) 
			ELSE 0
		END AS 'SPH Kisten bis 500 kg [kg]'
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
		END AS 'SPH Kisten bis 500 kg [m2]'	
		,CASE 
			WHEN BX_B.Netto > 500 AND  BX_B.Netto <= 1000 AND BX_B.IDSideArt IN (3) THEN 
				BX_BO.Quantity * (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight)		-- (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight + BX_B.AddendumWeight) 
			ELSE 0
		END AS 'SPH Kisten bis 1000 kg [kg]'
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
		END AS 'SPH Kisten bis 1000 kg [m2]'
		,CASE 
			WHEN BX_B.Netto > 1000 AND  BX_B.Netto <= 5000 AND BX_B.IDSideArt IN (3) THEN 
				BX_BO.Quantity * (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight)		-- (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight + BX_B.AddendumWeight) 
			ELSE 0
		END AS 'SPH Kisten bis 5000 kg [kg]'
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
		END AS 'SPH Kisten bis 5000 kg [m2]'
		,CASE 
			WHEN BX_B.Netto > 5000 AND  BX_B.Netto <= 10000 AND BX_B.IDSideArt IN (3) THEN 
				BX_BO.Quantity * (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight)		-- (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight + BX_B.AddendumWeight) 
			ELSE 0
		END AS 'SPH Kisten bis 10000 kg [kg]'
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
		END AS 'SPH Kisten bis 10000 kg [m2]'
		,CASE 
			WHEN BX_B.Netto > 10000 AND BX_B.IDSideArt IN (3) THEN 
				BX_BO.Quantity * (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight)		-- (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight + BX_B.AddendumWeight) 
			ELSE 0
		END AS 'SPH Kisten ab 10000 kg [kg]'
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
		END AS 'SPH Kisten ab 10000 kg [m2]'
		,CASE 
			WHEN BX_B.Netto <= 500 AND BX_B.IDSideArt IN (4) THEN 
				BX_BO.Quantity * (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight)		-- (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight + BX_B.AddendumWeight) 
			ELSE 0
		END AS 'OSB Kisten bis 500 kg [kg]'
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
		END AS 'OSB Kisten bis 500 kg [m2]'	
		,CASE 
			WHEN BX_B.Netto > 500 AND  BX_B.Netto <= 1000 AND BX_B.IDSideArt IN (4) THEN 
				BX_BO.Quantity * (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight)		-- (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight + BX_B.AddendumWeight) 
			ELSE 0
		END AS 'OSB Kisten bis 1000 kg [kg]'
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
		END AS 'OSB Kisten bis 1000 kg [m2]'
		,CASE 
			WHEN BX_B.Netto > 1000 AND  BX_B.Netto <= 5000 AND BX_B.IDSideArt IN (4) THEN 
				BX_BO.Quantity * (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight)		-- (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight + BX_B.AddendumWeight) 
			ELSE 0
		END AS 'OSB Kisten bis 5000 kg [kg]'
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
		END AS 'OSB Kisten bis 5000 kg [m2]'
		,CASE 
			WHEN BX_B.Netto > 5000 AND  BX_B.Netto <= 10000 AND BX_B.IDSideArt IN (4) THEN 
				BX_BO.Quantity * (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight)		-- (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight + BX_B.AddendumWeight) 
			ELSE 0
		END AS 'OSB Kisten bis 10000 kg [kg]'
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
		END AS 'OSB Kisten bis 10000 kg [m2]'
		,CASE 
			WHEN BX_B.Netto > 10000 AND BX_B.IDSideArt IN (4) THEN 
				BX_BO.Quantity * (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight)		-- (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight + BX_B.AddendumWeight) 
			ELSE 0
		END AS 'OSB Kisten ab 10000 kg [kg]'
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
		END AS 'OSB Kisten ab 10000 kg [m2]'
		,CASE 
			WHEN BX_B.Netto <= 1000 AND BX_B.IDSideArt IN (1) THEN 
				BX_BO.Quantity * (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight)		-- (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight + BX_B.AddendumWeight) 
			ELSE 0
		END AS 'Vollholzkiste bis 1000 kg [kg]'
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
		END AS 'Vollholzkiste bis 1000 kg [m2]'
		,CASE 
			WHEN BX_B.Netto > 1000 AND  BX_B.Netto <= 5000 AND BX_B.IDSideArt IN (1) THEN 
				BX_BO.Quantity * (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight)		-- (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight + BX_B.AddendumWeight) 
			ELSE 0
		END AS 'Vollholzkiste bis 5000 kg [kg]'
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
		END AS 'Vollholzkiste bis 5000 kg [m2]'
		,CASE 
			WHEN BX_B.Netto > 5000 AND  BX_B.Netto <= 10000 AND BX_B.IDSideArt IN (1) THEN 
				BX_BO.Quantity * (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight)		-- (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight + BX_B.AddendumWeight) 
			ELSE 0
		END AS 'Vollholzkiste bis 10000 kg [kg]'
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
		END AS 'Vollholzkiste bis 10000 kg [m2]'
		,CASE 
			WHEN BX_B.Netto > 10000 AND BX_B.IDSideArt IN (1) THEN 
				BX_BO.Quantity * (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight)		-- (BX_B.FlorWieght + BX_B.FrontWeight + BX_B.SideWeight + BX_B.CoverWeight + BX_B.AddendumWeight) 
			ELSE 0
		END AS 'Vollholzkiste ab 10000 kg [kg]'
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
		END AS 'Vollholzkiste ab 10000 kg [m2]'	
		,'-----' 
		AS 'Verpackungsperformance [m2/MA]'
	
		----------------------------------------------------------------------------------------------------------------------------------------------------------------
		---------- KOSTEN ----------------------------------------------------------------------------------------------------------------------------------------------
		----------------------------------------------------------------------------------------------------------------------------------------------------------------
	
		,CASE 
			WHEN BX_B.IDSideArt IN (3) AND BX_BO.SpecialConstruction = 0 THEN 
				CASE WHEN OL.Currency NOT IN ('CZK')	
					THEN CONVERT(FLOAT,CAST(ROUND(ISNULL(DFCZCHEB_SIL.[Unit Price],ISNULL(DFCZIVA_SIL.[Unit Price],ISNULL(DNL.Price,OL.CustomerApprovedPrice))), 2) AS DECIMAL(12,2))) 
				ELSE CONVERT(FLOAT,CAST(ROUND(ISNULL(DFCZCHEB_SIL.[Unit Price],ISNULL(DFCZIVA_SIL.[Unit Price],ISNULL(DNL.Price,OL.CustomerApprovedPrice)))/@kurz, 2) AS DECIMAL(12,2)))
				END
			ELSE 0
		END AS 'SPH Kiste [€]'
		,CASE 
			WHEN BX_B.IDSideArt IN (4) AND BX_BO.SpecialConstruction = 0 THEN 
				CASE WHEN OL.Currency NOT IN ('CZK')	
					THEN CONVERT(FLOAT,CAST(ROUND(ISNULL(DFCZCHEB_SIL.[Unit Price],ISNULL(DFCZIVA_SIL.[Unit Price],ISNULL(DNL.Price,OL.CustomerApprovedPrice))), 2) AS DECIMAL(12,2))) 
				ELSE CONVERT(FLOAT,CAST(ROUND(ISNULL(DFCZCHEB_SIL.[Unit Price],ISNULL(DFCZIVA_SIL.[Unit Price],ISNULL(DNL.Price,OL.CustomerApprovedPrice)))/@kurz, 2) AS DECIMAL(12,2)))
				END 
			ELSE 0
		END AS 'OSB Kiste [€]'
		,CASE 
			WHEN BX_B.IDSideArt IN (1) AND BX_BO.SpecialConstruction = 0 THEN 
				CASE WHEN OL.Currency NOT IN ('CZK')	
					THEN CONVERT(FLOAT,CAST(ROUND(ISNULL(DFCZCHEB_SIL.[Unit Price],ISNULL(DFCZIVA_SIL.[Unit Price],ISNULL(DNL.Price,OL.CustomerApprovedPrice))), 2) AS DECIMAL(12,2))) 
				ELSE CONVERT(FLOAT,CAST(ROUND(ISNULL(DFCZCHEB_SIL.[Unit Price],ISNULL(DFCZIVA_SIL.[Unit Price],ISNULL(DNL.Price,OL.CustomerApprovedPrice)))/@kurz, 2) AS DECIMAL(12,2)))
				END
			ELSE 0
		END AS 'Vollholzkiste [€]'
		,CASE 
			WHEN BX_BO.SpecialConstruction = 1 THEN 
				CASE WHEN OL.Currency NOT IN ('CZK')	
					THEN CONVERT(FLOAT,CAST(ROUND(ISNULL(DFCZCHEB_SIL.[Unit Price],ISNULL(DFCZIVA_SIL.[Unit Price],ISNULL(DNL.Price,OL.CustomerApprovedPrice))), 2) AS DECIMAL(12,2))) 
				ELSE CONVERT(FLOAT,CAST(ROUND(ISNULL(DFCZCHEB_SIL.[Unit Price],ISNULL(DFCZIVA_SIL.[Unit Price],ISNULL(DNL.Price,OL.CustomerApprovedPrice)))/@kurz, 2) AS DECIMAL(12,2)))
				END
			ELSE 0 
		END AS 'Sonderbau [€]'

		----------------------------------------------------------------------------------------------------------------------------------------------------------------
		---------- QUALITÄT --------------------------------------------------------------------------------------------------------------------------------------------
		----------------------------------------------------------------------------------------------------------------------------------------------------------------

		,'-----' AS 'Innovation (KVP Vorschläge) [Stk.]'
		,'-----' AS 'int. Schadensmeldungen [Stk.]'
		,'-----' AS 'int. Schadenshöhe [Tsd. €]'
		,'-----' AS 'int. Schulungsbedarf [%]'
		
		----------------------------------------------------------------------------------------------------------------------------------------------------------------
		---------- KUNDENBEZUG -----------------------------------------------------------------------------------------------------------------------------------------
		----------------------------------------------------------------------------------------------------------------------------------------------------------------

		,'-----' 
		AS 'Konstruktion - Schulungsbedarf [%]'
		,CASE 
			WHEN ISNULL(DATEDIFF(DAY,CAST(BX_BO.[DateComplete] AS DATE),ISNULL(CAST(L.[Date] AS DATE),ISNULL(CAST(DNH.DeliveryDate AS DATE),CAST(OH.[CompletingDate] AS DATE)))),0) > 0
				THEN DATEDIFF(DAY,CAST(BX_BO.[DateComplete] AS DATE),ISNULL(CAST(L.[Date] AS DATE),ISNULL(CAST(DNH.DeliveryDate AS DATE),CAST(OH.[CompletingDate] AS DATE))))
			ELSE 0
		END	AS 'Liefertreue nicht geschaft [Tage]'
		,ISNULL(DATEDIFF(DAY,CAST(BXOH.ImportDateTime AS DATE),ISNULL(CAST(L.[Date] AS DATE),ISNULL(CAST(DNH.DeliveryDate AS DATE),CAST(OH.[CompletingDate] AS DATE)))),0)
		AS 'Bestell-Zeitfenster [Tage]'
		,'-----' 
		AS 'Kundenzufriedenheit [Faktor]'

	FROM 
		-- BoxCAD
					BoxCAD_TEMP.dbo.BoxOrder						AS BX_BO 
		INNER JOIN	BoxCAD_TEMP.dbo.Box								AS BX_B		ON BX_B.IDXOrder = BX_BO.IDX
		INNER JOIN	BoxCAD_TEMP.dbo.Parameters						AS BX_P		ON BX_P.IDXBox = BX_B.IDX
		INNER JOIN	BoxCAD_TEMP.dbo.AddendumMaterial				AS BX_ADDM	ON BX_ADDM.IDXOrder = BX_BO.IDX
		LEFT JOIN	BoxCAD_TEMP.dbo.Users							AS BX_U		ON BX_U.IDX = BX_BO.IDXUser
		
		-- LoadBalancer
		INNER JOIN	LoadBalancer_TEMP.dbo.OrderLine					AS OL		ON OL.BxOrderCode COLLATE DATABASE_DEFAULT = BX_BO.Code COLLATE DATABASE_DEFAULT 
		INNER JOIN	LoadBalancer_TEMP.dbo.OrderHeader				AS OH		ON OH.ID = OL.OrderHeaderID
		INNER JOIN	LoadBalancer_TEMP.dbo.BXOrderHeader				AS BXOH		ON BXOH.ID = OL.BXOrderHeaderID
		LEFT JOIN	LoadBalancer_TEMP.dbo.DeliveryNoteLine			AS DNL		ON DNL.OrderLineID = OL.ID
		LEFT JOIN	LoadBalancer_TEMP.dbo.DeliveryNoteHeader		AS DNH		ON DNH.ID = DNL.DeliveryNoteHeaderID
		--LEFT JOIN	LoadBalancer.dbo.OrderLine						AS SOL		ON SOL.ID = OL.StockOrderLineID
		LEFT JOIN	LoadBalancer_TEMP.dbo.LoadingDestination		AS LD		ON LD.OrderLineID = OL.ID AND LD.Valid = 1
		LEFT JOIN	LoadBalancer_TEMP.dbo.Loading					AS L		ON L.ID = LD.LoadingID


		-- NAV CHEB
		LEFT JOIN	[DFCZE_NAV100CZ_PRD_TEMP].[dbo].[Deufol CZ Production, s_r_o_$Sales Invoice Line] AS DFCZCHEB_SIL	ON DFCZCHEB_SIL.[LB BoxCAD Code] COLLATE DATABASE_DEFAULT = BX_BO.Code COLLATE DATABASE_DEFAULT
		LEFT JOIN	[DFCZE_NAV100CZ_PRD_TEMP].[dbo].[Deufol CZ Production, s_r_o_$Sales Invoice Header] AS DFCZCHEB_SIH	ON DFCZCHEB_SIH.No_ = DFCZCHEB_SIL.[Document No_]
		

		-- NAV IVA
		LEFT JOIN	[DFCZE_NAV100CZ_PRD_TEMP].[dbo].[Deufol Česká republika a_ s_$Sales Invoice Line] AS DFCZIVA_SIL		ON DFCZIVA_SIL.[LB BoxCAD Code] COLLATE DATABASE_DEFAULT = BX_BO.Code COLLATE DATABASE_DEFAULT
		LEFT JOIN	[DFCZE_NAV100CZ_PRD_TEMP].[dbo].[Deufol Česká republika a_ s_$Sales Invoice Header] AS DFCZIVA_SIH	ON DFCZIVA_SIH.[No_] = DFCZIVA_SIL.[Document No_]

	WHERE
		BX_BO.OrderCreated >= '2018-12-01' AND BX_BO.OrderCreated < '2019-03-01' 
		AND BX_BO.IDOrderState IN (32,50)
		AND OL.StockPicked = 0
		--AND	SUBSTRING(BX_BO.Code,1,5) = '00066' 
		
		--AND BX_BO.Code IN ('0006610181005061','0002218111600001')

	/*	BX_BO.Code IN (
			'0000400001094004', -- IVA
			'0002218102603006', -- CHEB
			'0002200018907913',
			'0081555500000001',
			'0081546546550001',
			'0081556456402001',
			'0081556465000001',
			'0081565746546001'
		)		
		*/


) AS TEMP
INNER JOIN  [BoxCAD_TEMP].[dbo].[Mandants]	AS BX_M		ON BX_M.Name = TEMP.[Mandant Code]


GROUP BY
	TEMP.[Mandant Code]
	,BX_M.Descript
	,TEMP.[Periode Year]
	,TEMP.[Periode Month]
	,TEMP.UserName


ORDER BY 
	TEMP.[Mandant Code]
	,BX_M.Descript
	,TEMP.[Periode Year]
	,TEMP.[Periode Month]
	,TEMP.UserName





