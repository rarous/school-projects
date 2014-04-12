/*
Created		12.11.2004
Modified		25.11.2004
Project		Progran Projektor
Model			
Company		PB software
Author		Aleš Roubíèek
Version		0.3
Database		MS SQL 2000 
*/
Create table [Projekt]
(
	[id_projektu] Integer Identity(1,1) NOT NULL, UNIQUE ([id_projektu]),
	[id_uzivatele] Integer NOT NULL,
	[nazev] Nvarchar(255) NOT NULL,
	[zadavatel] Nvarchar(255) NOT NULL,
	[datum_zalozeni] Datetime NOT NULL,
	[faze] Integer NOT NULL,
	[test_uri] Nvarchar(255) NULL,
	[uri] Nvarchar(255) NULL,
	[poznamka] Ntext NULL,
	[aktivni] Bit NOT NULL,
Primary Key ([id_projektu])
) 
go

Create table [Prispevek]
(
	[id_prispevku] Integer Identity(1,1) NOT NULL, UNIQUE ([id_prispevku]),
	[id_projektu] Integer NOT NULL,
	[zprava] Ntext NOT NULL,
	[datum_vlozeni] Datetime NOT NULL,
	[datum_upravy] Datetime NOT NULL,
	[id_uzivatele] Integer NOT NULL,
Primary Key ([id_prispevku],[id_projektu])
) 
go

Create table [Soubor]
(
	[id_souboru] Integer Identity(1,1) NOT NULL, UNIQUE ([id_souboru]),
	[id_prispevku] Integer NOT NULL,
	[id_projektu] Integer NOT NULL,
	[nazev] Nvarchar(255) NOT NULL,
	[cesta] Nvarchar(255) NOT NULL,
Primary Key ([id_souboru],[id_prispevku],[id_projektu])
) 
go

Create table [Admin]
(
	[id_uzivatele] Integer NOT NULL,
Primary Key ([id_uzivatele])
) 
go

Create table [Spravce_projektu]
(
	[id_uzivatele] Integer NOT NULL,
Primary Key ([id_uzivatele])
) 
go

Create table [Programator]
(
	[id_uzivatele] Integer NOT NULL,
	[programovaci_jazyky] Nvarchar(255) NULL,
	[funkce_v_tymu] Nvarchar(255) NULL,
Primary Key ([id_uzivatele])
) 
go

Create table [Zakaznik]
(
	[firma] Nvarchar(255) NULL,
	[ic] Nvarchar(30) NULL,
	[dic] Integer NULL,
	[bankovni_spojeni] Nvarchar(100) NULL,
	[id_uzivatele] Integer NOT NULL,
Primary Key ([id_uzivatele])
) 
go

Create table [Uzivatel]
(
	[id_uzivatele] Integer Identity(1,1) NOT NULL, UNIQUE ([id_uzivatele]),
	[jmeno] Nvarchar(255) NOT NULL,
	[prijmeni] Nvarchar(255) NOT NULL,
	[ulice] Nvarchar(255) NULL,
	[email] Nvarchar(255) NOT NULL,
	[msn] Bit NOT NULL,
	[telefon] Nvarchar(13) NULL,
	[icq] Nvarchar(15) NULL,
	[login] Nvarchar(80) NULL,
	[password] Ntext NULL,
Primary Key ([id_uzivatele])
) 
go

Create table [Projekty_zakaznika]
(
	[id_uzivatele] Integer NOT NULL,
	[id_projektu] Integer NOT NULL,
Primary Key ([id_uzivatele],[id_projektu])
) 
go

Create table [Smerovane_prispevky]
(
	[id_prispevku] Integer NOT NULL,
	[id_projektu] Integer NOT NULL,
	[id_uzivatele] Integer NOT NULL,
	[precetl] Bit NULL,
Primary Key ([id_prispevku],[id_projektu],[id_uzivatele])
) 
go