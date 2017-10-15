-- lage og bruke database
create schema if not exists automatNettverk;
use automatNettverk;

-- dropping av tabeller dersom de allered eksisterer
-- NB: rekkefølge
drop table if exists vareInkludering;
drop table if exists sjekking;
drop table if exists Vakt;
drop table if exists Automat;
drop table if exists Lokasjon;
drop table if exists Vare;
drop table if exists Kategori;
-- legge inn tabeller
drop table if exists Lokasjon;
create table Lokasjon(
	lokasjonID int auto_increment,
	navn varchar(45),
	x decimal(9,7), -- samme som Google Maps -> også med negative verdier
	y decimal(9,7),
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
	navn varchar(40),
	beskrivelse varchar(140),
	primary key (kategoriID)
);

-- Vare og Automat -> fremmednøkler er etablert
create table Vare(
	vareID int auto_increment,
	kategoriID int,
	pris decimal(6,2), -- maks pris 9999.99
	navn varchar(40),
	beksrivelse varchar(140),
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

create table vareInkludering( -- kobling -> lower case
	automatID int,
	vareID int,
	primary key (automatID, vareID),
	foreign key (automatID) references Automat(automatID),
	foreign key (vareID) references Vare(vareID)
);
create table sjekking(
	automatID int,
	vaktID int,
	primary key (automatID, vaktID),
	foreign key (automatID) references Automat(automatID),
	foreign key (vaktID) references Vakt(vaktID)
);
