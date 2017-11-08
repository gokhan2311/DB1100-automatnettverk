use automatNettverk;


select Lokasjon.navn, automat.automatID -- hver gang!?
from Lokasjon natural join Automat
order by Lokasjon.navn;

-- --------------------------------------

-- view -> hvordan bygget opp?

create ....



-- --------------------------------------



create view automatLokasjoner as
	select Lokasjon.navn, automat.automatID
	from Lokasjon natural join Automat
	order by Lokasjon.navn;

select * from automatLokasjoner;

-- --------------------------------------

create or replace view automatLokasjoner as
	select Lokasjon.navn, automat.automatID
	from Lokasjon natural join Automat
	order by Lokasjon.navn;

select * from automatLokasjoner;
