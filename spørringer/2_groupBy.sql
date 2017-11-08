select vaktID, automatID
from Sjekk;


select vaktID, automatID
from Sjekk
group by vaktID;



select vaktID, count(automatID)
from Sjekk
group by vaktID;



select Vakt.navn, count(Sjekk.automatID)
from Sjekk inner join Vakt
group by Vakt.navn; 
