select vaktID, automatID
from Sjekk; 

select count(automatID)
from Sjekk; 

select count(automatID)
from Sjekk
group by vaktID
order by count(automatID) desc; 

select vaktID, count(automatID)
from Sjekk
group by VaktID; 

select Vakt.navn, count(automatID)
from Sjekk natural join Vakt
group by Vakt.navn; 