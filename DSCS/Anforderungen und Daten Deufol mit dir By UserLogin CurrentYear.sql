select

 [DATA].[Cost Center]
,[DATA].[pernr]
,[DATA].[LastName]
,[DATA].[FirstName]
,[DATA].[HolidaysPrevYearRest]
,[DATA].[HolidaysPerYear]
,[DATA].[HolidaysPrevYearRest]+[DATA].[HolidaysPerYear] as [Total]
,sum([DATA].[HoliDays]) as [HolidaysSum]
,[DATA].[HolidaysPrevYearRest]+[DATA].[HolidaysPerYear]-sum([HoliDays]) as [HolidaysRemainig]
,[DATA].[Cost Center Description]

 from
(
    select
      -- [Event].[Id] [EventId]
      --,[Event].[Updated] [EventLastChange]
      --,Event.DateFrom
      --,event.DateTo
      --,event.type

      --,[User].[Login]
      [User].[FirstName]
      ,[User].[LastName]
      ,[User].[HolidaysPrevYearRest]
      ,[G].[Id] [GroupId]
      ,case when [User].[HolidaysPerYear]=0 then [G].[HolidaysPerYear] else [User].[HolidaysPerYear] end as [HolidaysPerYear]       
      ,case when [Event].[Type]=0 then ((datediff(DD,case  year([Event].[DateFrom]) when (Year(GETDATE())-1) then cast(DATEadd(yy, DATEDIFF(yy, 0, GETDATE()), 0)as date) else [Event].[DateFrom] end,case  year([Event].[DateTo]) when Year(GETDATE())+1 then cast(DATEADD(dd,-1, DATEADD(yy, DATEDIFF(yy, 0, GETDATE())+1, 0)) as date) else [Event].[DateTo] end)+1)*0.5)
      else 
      datediff(DD,case  year([Event].[DateFrom]) when (Year(GETDATE())-1) then cast(DATEadd(yy, DATEDIFF(yy, 0, GETDATE()), 0)as date) else [Event].[DateFrom] end,case  year([Event].[DateTo]) when Year(GETDATE())+1 then cast(DATEADD(dd,-1, DATEADD(yy, DATEDIFF(yy, 0, GETDATE())+1, 0)) as date) else [Event].[DateTo] end)+1 end
      --All crossed border of the day(00:00:00) within range. First day is not counted because you did not crossed midnight. You must add +1
      -(DATEDIFF(WK,case  year([Event].[DateFrom]) when (Year(GETDATE())-1) then cast(DATEadd(yy, DATEDIFF(yy, 0, GETDATE()), 0)as date) else [Event].[DateFrom] end,case  year([Event].[DateTo]) when Year(GETDATE())+1 then cast(DATEADD(dd,-1, DATEADD(yy, DATEDIFF(yy, 0, GETDATE())+1, 0)) as date) else [Event].[DateTo] end) * 2)--Border of the week is Saterday/Sunday 00:00:00
      -(CASE WHEN DATEPART(DW,case  year([Event].[DateFrom]) when (Year(GETDATE())-1) then cast(DATEadd(yy, DATEDIFF(yy, 0, GETDATE()), 0)as date) else [Event].[DateFrom] end) = 1 THEN 1 ELSE 0 END) --if holiday starts on Sunday one day is discounted
      -(CASE WHEN DATEPART(DW,case  year([Event].[DateTo]) when (Year(GETDATE())+1) then cast(DATEADD(dd,-1, DATEADD(yy, DATEDIFF(yy, 0, GETDATE())+1, 0)) as date) else [Event].[DateTo] end) = 7 THEN 1 ELSE 0 END)   --if holiday ends up on Saterday one day is discounted
      -isnull((SELECT 
       sum(case when Hours='8' then 1
               when Hours='4' then 0.5 end)
          FROM [Holiday] as [H]
          where year(HolidayDate)= Year(GETDATE()) and [Event].[Type]!=0 and [HolidayDate] BETWEEN [DateFrom] AND [DateTo] AND [H].[CountryId]=[User].CountryId),0) as [HoliDays]--In Germany they have half day bank holiday.....

      ,[CFUser].[Cost Center] as [Cost Center]
      ,[CFUser].[Cost Center Description] as [Cost Center Description]
      ,[CFUser].[PersonalID] [pernr]
      ,[User].[Level]
      ,[User].[Id] [UserId]

    FROM [Event] 
    Inner join [User] on [UserId]=[User].[Id]
    left join (
        SELECT
            [CustomField].[Name] as [CF_Name],
            [CV].[Content] as [CV_Content],
            [CV].[EntityId] as [EntityID]
        FROM [CustomField] 
        inner JOIN [CustomValue] [CV] ON ([CustomField].[Id] = [CV].[CustomFieldId])
        where [Name] in ('Cost Center','Cost Center Description','PersonalID','Not to SAP export') and [CV].[Entity] = 22
    ) [SRC]
    PIVOT (max([SRC].[CV_Content]) for [SRC].[CF_Name]  in ([Cost Center],[Cost Center Description],[PersonalID],[Not to SAP export]))as [CFUser] on [CFUser].[EntityId]=[User].[Id]

    inner join [Country] as [C] on [C].[Id]=[User].[CountryId]
    inner join [Group] as [G] on [G].[Id]=[User].[GroupId]

    Where ([CFUser].[Cost Center]!='' and  [User].[Disabled] = 0 and [Type] in(0,1) 
    and [Status] in (1)
    and (year([Event].[DateFrom])=Year(GETDATE()) or year([Event].[DateTo])=Year(GETDATE()))

    and [User].[Disabled]=0
    and [CFUser].[Not to SAP export]='False')
    --and [User].[Login]='frank.juerke'

) DATA

left join [GroupApprover] as [GApp] on [DATA].GroupId=[GApp].[GroupId]
left join [User] [U1] on [U1].[Id]=[GApp].[UserId]
where [GApp].[Level] <= [DATA].[Level] --  in (1,2,3)
and [U1].[Login]= 'tomas.pesko' --$P{LoggedInUsername}'' 


Group BY
 [DATA].[FirstName]
,[DATA].[LastName]
,[DATA].[HolidaysPrevYearRest]
,[DATA].[HolidaysPerYear]
,[DATA].[Cost Center]
,[DATA].[Cost Center Description]
,[DATA].[pernr]
,[DATA].[UserId]

order by [Cost Center],[LastName]