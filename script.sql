-- lage og bruke database
create schema if not exists automatNettverk;
use automatNettverk;

-- dropping av tabeller dersom de allered eksisterer

-- NB: rekkefølge
drop table if exists VareInkludering;
drop table if exists Sjekk;
drop table if exists Vare;
drop table if exists Kategori;
drop table if exists Automat;
drop table if exists Lokasjon;
drop table if exists Vakt;

-- legge inn tabeller

drop table if exists Lokasjon;
create table Lokasjon(
	lokasjonID int auto_increment,
	navn varchar(45) unique,
	x decimal(9,7) unique, -- samme som Google Maps -> også med negative verdier
	y decimal(9,7) unique,
	primary key (lokasjonID)
);

create table Vakt(
	vaktID int auto_increment,
	navn varchar(40),
	lonnPerSjekk int, -- lønn i hele kroner
	primary key (vaktID)
);

create table Kategori(
	kategoriID int auto_increment,
	navn varchar(40) unique,
	beskrivelse varchar(140),
	primary key (kategoriID)
);

-- Vare og Automat -> fremmednøkler er etablert

create table Vare(
	vareID int auto_increment,
	kategoriID int,
	pris decimal(6,2), -- maks pris 9999.99
	navn varchar(40) unique,
	beskrivelse varchar(140),
	primary key (vareID),
	foreign key (kategoriID) references Kategori(kategoriID)
);

create table Automat(
	automatID int auto_increment,
	lokasjonID int,
	kapasitet int,
	primary key (automatID),
	foreign key (lokasjonID) references Lokasjon(lokasjonID)
);

-- koblingsentiteter

create table VareInkludering(
	automatID int,
	vareID int,
	antall int,
	primary key (automatID, vareID),
	foreign key (automatID) references Automat(automatID),
	foreign key (vareID) references Vare(vareID)
);

create table Sjekk(
	sjekkID int auto_increment, -- automatID/vaktID holder ikke fordi samme vakt kan sjekke en automat flere ganger
	automatID int,
	vaktID int,
	primary key (sjekkID),
	foreign key (automatID) references Automat(automatID),
	foreign key (vaktID) references Vakt(vaktID)
);

-- legge til sjekk for varer kontra kapasitet
alter table Automat add check(
	(
		select sum(antall)
		from Automat natural join VareInkludering
		group by automatID
	) <= kapasitet
);

-- legge inn data:

insert into Kategori(navn, beskrivelse) values -- PK kunne vært "navn"
	("drikke", "drikkevarer som brus, kaffe, te, saft og vann"),
	("snacks", "tørre produkter som popcorn, potetgull, nøtter og kjeks"),
	("middag", "et fullverdig måltid. Krever som regel oppvarming og/eller utblanding i vann"),
	("lunsj", "mindre måltidsprodukter. Sandwich, Yogurt o.l."),
	("godteri", "søtsaker som sjokolade, gelegodteri, lakris og lignende");
insert into Vare (pris, navn, beskrivelse, kategoriID) values
	(10.00, "sjokolade - liten", "en sjokolade for den som er litt glad i sjokolade", 5),
	(22.50, "sjokolade - medium", "en sjokolade for den som er noe glad i sjokolade", 5),
	(30.00, "sjokolade - stor", "en sjokolade for den som er veldig glad i sjokolade", 5),
	(25.00, "seigmenn", "gode gelegodterier i fruktige smaker, formet som mennesker", 5),

	(34.50, "smørbrød, grønnsaker", "et forfriskende måltid for den som er glad i grønnsaker", 4),
	(26.5, "smørbrød, skinke og ost", "deilig smørbrød med skinke og ost", 4),
	(22.00, "smørbrød, standard", "den gode gamle oppskriften på automatens eldste produkt", 4),

	(20.00, "tomatsuppe, pose", "en god tomatsuppe til en travel hverdag", 3),
	(45.50, "lasagne, original", "automatens originale lasagne. Varmes i mikro i 2 minutter", 3),
	(50.00, "lasagne, vegetar", "en lasagne stappet med grønnsaker. Varmes i mikro i 2.5 minutter", 3),

	(35.90, "potetgull, original", "det salte, originale potetgullet fra automaten", 2),
	(35.90, "potetgull, paprika", "potetgull fra automaten, med paprikasmak. Bestselger!", 2),
	(40.00, "potetgull, salt og pepper", "potetgull fra automaten, med smak av salt og pepper. Prisvinner!", 2),

	(17.50, "automatens kosedrikk", "den klassiske brusen. Til lange og korte dager så vel som hverdager og helg", 1),
	(14.00, "kaffe, sort", "kaffe fra automaten gir deg akkurat det du trenger i løpet av arbeidsdagen", 1),
	(10.00, "te, frukt", "gir deg en fin start på morgenen, med smak av tropiske frukter", 1),
	(10.50, "te, sove", "gir den perfekte avslutning på en lang dag", 1);
insert into Lokasjon(navn, x, y) values
	("Westerdals", 30.4231231, 1.5341232),
	("Oslo S", 30.4231311, 0.9941232),
	("UiO", 29.4995384, 1.2341232),
	("Stortinget", 30.9394857, 0.8399932),
	("Bogstadveien", 28.3345342, 1.8341232),
	("Forskningsparken", 29.4857384, 1.8341992);
-- etter lokasjon -> nøkler
insert into Automat(kapasitet) values
	(500),(500),(250),(750),(900),(500),(250),(250); -- 8 automater
insert into Vakt(navn, lonnPerSjekk) values
	("Per Petersen", 110),
	("Ola Bokleser", 90),
	("Live Simensen", 110),
	("Linus Gran", 90),
	("Hans Olsen", 100),
	("Hans Olsen", 110); -- like!?
-- legge inn i koblingsentitetene
insert into Sjekk(automatID, vaktID) values
	(1,4),(1,2),(2,4),(2,4),(5,4),(2,1),
	(1,2),(2,2),(6,6),(6,5),
	(5,3),(3,2),(1,4);
insert into VareInkludering(automatID, vareID, antall) values
	(1,14,10),(1,15,23),(1,16,44),(1,17,10), -- automat 1 har bare drikke

	(2,14,10),(2,15,12),(2,16,42),(2,17,23), -- automat 2 har drikke og snacks
	(2,11,3),(2,12,20),(2,13,11),

	(3,5,20),(3,6, 30),(3,7,34),(3,8,11),(3,9,23),(3,10,33); -- automat 3 fokuserer på lunsj og middag
