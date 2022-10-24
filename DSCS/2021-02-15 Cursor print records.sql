

/* (1) Deklarujeme proměnné, které budeme chtít zobrazovat (ID zaměstnance a jeho jméno a příjmení */
DECLARE @Zamestnanec_ID UNIQUEIDENTIFIER ,@Zamestnanec_JmenoPrijmeni VARCHAR(255);

PRINT '===> SEZNAM ZAMESTNANCU <===';

/* (2) Deklarujeme kurzor a přiřadíme jej */
DECLARE muj_cursor CURSOR FOR
SELECT Id,CONCAT(U.FirstName,' ', U.[LastName])
FROM [User] U
ORDER BY [ClusteredId];

/* (3) Otevřeme kurzor */
OPEN muj_cursor

/* (4) Přiřadíme zpracovávaným proměnným hodnoty z kurzoru */
FETCH NEXT FROM muj_cursor
INTO @Zamestnanec_ID,@Zamestnanec_JmenoPrijmeni

PRINT 'Zamestnanec_ID Zamestnanec_JmenoPrijmeni'

/* (5) Zpracujeme SQL příkaz. V našem případě necháme přes přes PRINT vypsat hodnoty. Přes WHILE necháme cyklus proběhnout tolikrát, kolikrát ještě existuje další řádek v tabulce [AdventureworksDW2016CTP3].[dbo].[DimEmployee]. To zjišťujeme přes funkci @@FETCH_STATUS. Jak můžete vidět, tak loop proběhne pouze tehdy, pokud je hodnota funkce @@FETCH_STATUS = 0. Hodnota 0 znamená, že  “FETCH NEXT FROM muj_cursor” proběhlo úspěšně => je co zpracovat. Pokud kurzor dorazí na poslední řádek v tabulce a pokusíme se přiřadit další hodnotu, tak @@FETCH_STATUS by byla -1 a cyklus tím končí.*/

WHILE @@FETCH_STATUS = 0
BEGIN
PRINT ' ''' + CAST(@Zamestnanec_ID as VARCHAR(40)) +''', '+ CAST(@Zamestnanec_JmenoPrijmeni as VARCHAR(20))
FETCH NEXT FROM muj_cursor
INTO @Zamestnanec_ID,@Zamestnanec_JmenoPrijmeni

END

/* (6) Zavření kurzoru */
CLOSE muj_cursor;

/* (7) Vymazání kurzoru */
DEALLOCATE muj_cursor;

