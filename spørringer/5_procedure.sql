use Automatnettverk; 




-- ------------------------------------------------------------------




create or replace view automat_lokasjon as 
	select Automat.automatID, Lokasjon.navn
		from Automat natural join Lokasjon 
		-- where Automat.lokasjonID = Lokasjon.lokasjonID
		order by automatID
; 



create or replace view automat_vare as 		
	select vareInkludering.automatID, Vare.navn, vareInkludering.antall
		from Vare left join vareInkludering 
		on Vare.vareID = vareInkludering.vareID
; 
	
 
create or replace view automat_lokasjon_etter_vare as 
	select automat_vare.navn as vare, coalesce(automat_lokasjon.navn, "UTSOLGT") as lokasjon
	from automat_vare left join automat_lokasjon
	on automat_vare.automatID = automat_lokasjon.automatID
	where automat_vare.navn = "te, frukt" -- finne spesifisert vare
	order by automat_vare.navn
;



select * from automat_lokasjon_etter_vare;






-- ------------------------------------------------------------------



DELIMITER $$ 
create procedure NAVN(PARAMETERE)
	begin
		INNHOLD; 
	end$$
DELIMITER ; 
	


-- ------------------------------------------------------------------






drop procedure procedure_test; 

DELIMITER $$ 
create procedure procedure_test()
	begin
		select * 
		from Vakt; 
	end$$
DELIMITER ; 

call procedure_test(); 







-- ------------------------------------------------------------------







drop procedure parameter_test; 

DELIMITER $$ 
create procedure parameter_test(in parameter int)
	begin
		select * 
		from Vakt 
		where lonnPerSjekk >= parameter;
	end$$ 
DELIMITER ;

call parameter_test(90);







-- ------------------------------------------------------------------







drop procedure if exists hent_vare_fra_lokasjon;

DELIMITER $$ 
create procedure hent_vare_fra_lokasjon(in varenavn varchar(40))
   begin
   
   	create or replace view automat_lokasjon as 
	select Automat.automatID, Lokasjon.navn
		from Automat inner join Lokasjon -- natural? 
		where Automat.lokasjonID = Lokasjon.lokasjonID
		order by automatID
	; 

	create or replace view automat_vare as 		
		select vareInkludering.automatID, Vare.navn, vareInkludering.antall
		from Vare left join vareInkludering -- alle varer 
		on Vare.vareID = vareInkludering.vareID
	; 
	

	select automat_vare.navn as vare, coalesce(automat_lokasjon.navn, "UTSOLGT") as lokasjon
	from automat_vare left join automat_lokasjon
	on automat_vare.automatID = automat_lokasjon.automatID
	where automat_vare.navn = varenavn -- finne spesifisert vare
	order by automat_vare.navn
	; 
   
   end$$
   
DELIMITER ; 


call hent_vare_fra_lokasjon("kaffe, sort"); 
call hent_vare_fra_lokasjon("seigmenn");
call hent_vare_fra_lokasjon("sjokolade - medium");



