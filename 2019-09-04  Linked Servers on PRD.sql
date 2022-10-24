    --select * from DCNLPWSQL02.KRO_VV.dbo.DAT_KISTEN
    
    select CF.*,PRD.name, PRD.Entity
    from DCNLTWSQL02.DFCZ_OSLET_TST.dbo.Customfield CF


    left join (

    select name,Entity from DFCZ_OSLET.dbo.CustomField PRDCF 
 where PRDCF.ClientBusinessUnitId = (Select id from BusinessUnit where name = 'Krones AG')) PRD on CF.name = PRD.NAME and CF.entity = PRD.Entity


      where CF.ClientBusinessUnitId = (Select BU.id from DCNLTWSQL02.DFCZ_OSLET_TST.dbo.BusinessUnit BU where name = 'Krones AG VV')
      and prd.name is null