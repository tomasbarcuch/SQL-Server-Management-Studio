begin transaction
DECLARE @DATEFROM AS DATETIME
DECLARE @DATETO AS DATETIME
DECLARE @CALENDAR TABLE(DATE DATETIME)

SET @DATEFROM = '2008-01-01'
SET @DATETO = '2028-12-31'

INSERT INTO
    @CALENDAR
        (DATE)
VALUES
    (@DATEFROM)

WHILE @DATEFROM < @DATETO
BEGIN

    SELECT @DATEFROM = DATEADD(D, 1, @DATEFROM)
    INSERT 
    INTO
        @CALENDAR
            (DATE)
    VALUES
        (@DATEFROM)
END

insert into dbo.Calendar (
[date]
/*,[day],
[month],
FirstOfMonth,
[MonthName],
[week],
[ISOweek],
[DayOfWeek],
[quarter],
[year],
FirstOfYear,
Style112,
Style101
*/
)




SELECT 

CALENDAR.Date as 'Date'
/*,datepart(Day,CALENDAR.Date) as 'Day',
DATEPART(MONTH, CALENDAR.Date) as 'Month',
CONVERT(DATE, DATEADD(MONTH, DATEDIFF(MONTH, 0, CALENDAR.Date), 0)) as 'FirstOfMonth',
DATENAME(MONTH,CALENDAR.Date) as 'MonthName',
 DATEPART(WEEK,CALENDAR.Date) as 'week',
 DATEPART(ISO_WEEK,CALENDAR.Date) as 'ISOweek',
DATEPART(WEEKDAY,CALENDAR.Date) as 'DayOfWeek',
DATEPART(QUARTER,CALENDAR.Date) as 'quarter',
DATEPART(YEAR,CALENDAR.Date) as 'year',
CONVERT(DATE, DATEADD(YEAR, DATEDIFF(YEAR, 0, CALENDAR.Date), 0)) as 'FirstOfYear',
CONVERT(CHAR(8),CALENDAR.Date, 112) as 'Style112',
CONVERT(CHAR(10),CALENDAR.Date, 101) as 'Style101'*/


FROM
    @CALENDAR as CALENDAR

	


commit