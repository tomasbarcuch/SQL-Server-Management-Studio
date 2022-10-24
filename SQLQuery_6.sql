begin TRANSACTION
declare @DUOMID as UNIQUEIDENTIFIER = (select id from DisplayUOM where code = 'IN x YD x LB x BBL (US)')

update U set DisplayUOMId = @DUOMID from [User] U where U.login in ('patrick.chernesky','yancey.jones','steve.hamilton','john.appel','steve.pecsenye')

COMMIT