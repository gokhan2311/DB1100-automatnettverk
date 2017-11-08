use automatNettverk;

-- -----------------------------------------

DELIMITER ; 



-- -----------------------------------------
drop table if exists PrisLogg;
create table PrisLogg (
   vareID int,
   gammelPris int
);


-- -----------------------------------------


create trigger NAVN
NÅR 
HVOR 



-- -----------------------------------------



DELIMITER $$
create trigger prisLoggTrigger
	after update on Vare
	for each row
		begin
			if(OLD.pris <> NEW.pris) then
				insert into PrisLogg (vareID, gammelPris)
				values (OLD.vareID, OLD.pris);
			end if;
		end$$
DELIMITER ;


-- -----------------------------------------


update Vare 
set pris = 19
where vareID = 18; 


update Vare 
set pris = 30
where vareID = 18; 
