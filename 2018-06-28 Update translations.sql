/*
update translation set text = 'SpEntladet'
where 
language = 'de' and 
text in ('SpAbgeladen','SpEntladen','SpAugeladet')
*/

update translation set text = 'DmOrder Processing'
--select * 
from translation
inner join status on translation.entityid = status.id
 where 
language = 'de' and 
text in ('xxx') and status.name in ('DmOrder Processing')

select * from Translation
where 
language = 'de' and 
text in ('SpEntladet')

/*
insert into dbo.Translation (id,Language,Entity,[Column],Text,CreatedById,UpdatedById,Created,Updated,EntityId) 
values 
(newid(),'de','27','Name','Aktiv','eba86d7e-e20e-40f0-8e6e-1831fe48e45a','eba86d7e-e20e-40f0-8e6e-1831fe48e45a',43280.3789032407,43280.3789032407,'0ecb7bc7-0e36-4615-a606-49f674c8d1d7')
*/

update translation set text = 'HuTeilEingepackt'
 where 
language = 'de' and 
text in ('HuTeilEingefügt','HuTeilverpackt','HuVerpackt')

update translation set text = 'HuVersandbereit'
 where 
language = 'de' and 
text in ('HuAusg. Bereit','HuVersand bereit','HuAusg. Fert.')

update translation set text = 'HuVersendet'
 where 
language = 'de' and 
text in ('HuGesendet','HuVerschifft','HuVerladung')

update translation set text = 'HuAusgepackt2'
 where 
language = 'de' and 
text in ('HuUnpacked2')

update translation set text = 'HuAuspacken'
 where 
language = 'de' and 
text in ('HuAusgepackt','HuUnpacking')

update translation set text = 'LpVersendet'
 where 
language = 'de' and 
text in ('LpLadebereit','lpExpediert','LosteilVerladen','LpAbschicken','LpAbgeschickt')

update translation set text = 'LpVersandbereit'
 where 
language = 'de' and 
text in ('LpVersendet','LpVerladet','LpAusg. Bereit','lpLieferbereit','LpBereit')

update translation set text = 'HuWareneingang'
 where 
language = 'de' and 
text in ('HuEingang','HuWE')

update translation set text = 'LpVorabVorort'
 where 
language = 'de' and 
text in ('LpVorläufig Baustelle')


update translation set text = 'SpAusgeliefert'
 where 
language = 'de' and 
text in ('VerladungVerladen','SpVersendet','SpGeliefert','SpAusliefert')

update translation set text = 'SpLKWZugeordnet'
 where 
language = 'de' and 
text in ('SpLKWBestellt','SpLKW Angefordert')

update translation set text = 'SpVerladung'
 where 
language = 'de' and 
text in ('SpGeladet','SpBeladen')

update translation set text = 'LpVerladung'
 where 
language = 'de' and 
text in ('LpGeladet')

update translation set text = 'LpWarenausgang'
 where 
language = 'de' and 
text in ('LpOutOfWarenausgang')

update translation set text = 'LpVerpackt'
 where 
language = 'de' and 
text in ('lpGepackt','LosteilVerpackt')

update translation set text = 'LpErledigt'
 where 
language = 'de' and 
text in ('LpFertig','lpBeendet')

update translation set text = 'HuKonstruiert'
 where 
language = 'de' and 
text in ('HuEntworfen')

update translation set text = 'HuWeitergegeben'
 where 
language = 'de' and 
text in ('HuÜberreicht')

update translation set text = 'Abgeschlossen'
 where 
language = 'de' and 
text in ('Geschlossen')

update translation set text = 'Fertig'
 where 
language = 'de' and 
text in ('Erledigt')

update translation set text = 'HuKonstruiert'
 where 
language = 'de' and 
text in ('HuGebaut','HuKonstuiert')

update translation set text = 'HuBeendet'
 where 
language = 'de' and 
text in ('HuKompletiert')

update translation set text = 'HuVerladen'
 where 
language = 'de' and 
text in ('HuLadung','HuVersendet')

update translation set text = 'LpWeitergegeben'
 where 
language = 'de' and 
text in ('LpÜbergeben')

update translation set text = 'LpAusgedruckt'
 where 
language = 'de' and 
text in ('LpGedruckt')

update translation set text = 'LpWareneingang'
 where 
language = 'de' and 
text in ('LpEingegangen')

update translation set text = 'LpAusgepackt'
 where 
language = 'de' and 
text in ('LpAuspacken')

update translation set text = 'PoHuZugeordnet'
 where 
language = 'de' and 
text in ('PoHuAssigned')

update translation set text = 'PoProduziert'
 where 
language = 'de' and 
text in ('PoGebaut')


update translation set text = 'LpAufLager'
 where 
language = 'de' and 
text in ('LosteilAufLager')


