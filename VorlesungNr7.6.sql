#Modul Datenbankmanagementsysteme für Betriebswirte SS21
#Vorlesung Nr. 7.6 SQL Goodies und Fallstricke: Datensichten, Strored Procedures 
#Vorlesung Nr. 7.6.1 
#Anlegen von verschiednen Datensichten auf di SQL Basistabellen

#Beispieltabellen anlegen
create table Mitarbeiter1 (Name text,
						  Vorname text,
						  PLZ varchar,
						  Ort text,
						  Straße text,
						  HausNr varchar);
#Anzeigen lassen
select * from mitarbeiter1;

#Beisielhafte Werte einfügen
insert into mitarbeiter1 values('Hecker','Lennart',24211,'Preetz','Beispielstarße',3);
insert into mitarbeiter1 values('Hallmann','Sebastian',24230,'Essen','Am Wall',10);

#Jetzt neue Datensicht anlegen

CREATE VIEW MitarbeiterAnschrift (nameMitarbeiter, vornameMitarbeiter,plz,ort,straße,hausnr)
AS SELECT Name,Vorname,Plz,Ort,Straße,HausNr
FROM Mitarbeiter1;

#Jetzt die View anzeigen lassen
select * from MitarbeiterAnschrift;

#Jedoch merke: Es wurde keine neue Tabelle oder neue Daten erzeugt, es wurden lediglich die vorhandenen DAten anders abgerufen

#Neue View anlegen
CREATE VIEW MitarbeiterDaten (NachnameMitarbeiter,VornameMitarbeiter,OrtMitarbeiter)
AS SELECT Name,Vorname,Ort
FROM Mitarbeiter1;

#Basistabelle aus der neuen Datensicht anzeigen lassen:
select * FROM MitarbeiterDaten;


#Einführung von Stored Procedures (In Postgres sind dies Functions)
#Wenn Programme über Views auf Daten zugreifen müssen und diese Ändern müssen verwendet man Stored Procedures 

#Beispiel des Anlegens einer Stored Procedure
#Anlegen der Datenbasis:
create table kunde(knr integer primary key,
				  name text);
				  
create table bestellung(bnr integer primary key,
					   knr integer not null references kunde,
					   betrag numeric);

insert into kunde values(1,'Stefan');
insert into bestellung values(1000,1,123.45);
#Überprüfen der Angaben
select * from kunde;
select * from bestellung;


#Anlegen des Stored Procedure
#Ziel: Es soll der Betrag der Bestellung in der Tabelle Bestellung geändert werden
#Name des Stored Procedure: ChangeBestellungBetrag

create function ChangeBestellungBetrag(in_bnr integer, neuerBetrag numeric) returns void as $$
	update bestellung set betrag = neuerBetrag where bnr=in_bnr;
$$ Language SQL;

#Stored Procedure wurde zunächst angelegt aber noch nicht gebraucht
#In Gebrauch wird die Funktion dann mit Select:

#Der Betrag 1000 wird geändert in 4711.00:
select ChangeBestellungBetrag(1000,4711.00);

#Überprüfung zeigt, dass Procedure funktioniert hat:
select * from bestellung;

#Nun soll der Name des Kunden in der Tabelle kunde geändert werden:
#Die Identifikation läuft über die knr in der Tabelle Kunde
create function NameÄndern(nknr integer,neuername text) returns void as $$
	update kunde set name = neuername where nknr=knr;
$$ Language SQL;

#Ansprechen des Stored Procedure mit dem select:

select NameÄndern(1,'Sebastian');

#Überprüfen der Angabe:
select * from kunde;


#Vorlseung Nr. 7.6.2 SQL Goodies: WITH,CASE,LIMIT,Fensterfunktionen

#WITH Befehl ermöglicht es Redundanzen in Befehlen in eigenen kleinen Subbefehl mit Namen abzuspeichern und dann zu verwenden
#Anlegen der Datenbasis:
create table kauft(id integer, ProduktNr integer, KundenNr integer);
insert into kauft values(1,1,1),(2,1,2),(3,1,3),(4,1,4),(5,2,1);

#Anagben überprüfen
select * from kauft;

#Ziel: Ausgabe des am häufigsten gekauften Produktes und dessen Anzahl
#Variante Nr.1)
select produktnr, count(produktnr) anzahl
from kauft
group by produktnr
having count(produktnr) >=ALL(
	select count(produktnr) anzahl from kauft
	group by produktnr);
#Problem bei Variante Nr.1): Viele Redundanzen
#Daher Auslagerung von Teilen des gesamten Befehls der Variante Nr.1) mit WITH

WITH AnzahlProdutk AS(
	select produktnr, count(produktnr) anzahl
	from kauft
	group by produktnr);

select * from AnzahlProdukt 
	WHERE anzahl>= ALL(select anzahl from Anzahlprodukt);
	
#CASE ermöglicht bedingte Anweisungen in Abfragen, wenn z.B das Resultat einer Abfrage ein bestimmter Wert ist, kann dieser in der Ausgabe in einen anderen geändert werden
#Anlegen der Datenbasis
create table kunde1 (knr integer primary key);

create table bestellung(bnr integer primary key,
					   knr integer not null references kunde1, betrag numeric);

insert into kunde1 values(1),(2),(4711);
insert into bestellung values(1001,2,2000);
insert into bestellung values(1002,2,1500);
insert into bestellung values(1003,1,100);

#Ziel der Ausgabe: Für jeden Kunden den Gesamtbetrag dessen Bestellung ausgeben
select knr, sum(betrag)
from kunde1 natural left outer join bestellung
group by knr;
#Problem: Es kann sein das Kunden teilweise noch gar nichts bestellt haben daher der null Wert in der Ausgabe
#Diese Ausgabe des Wertes null soll in die Zahl 0 geändert werden

#Komplizierte Variante zur Lösung:
select knr, sum(betrag) 
from 
	(select*from
		kunde1 natural left outer join bestellung union
	 select knr, null,0 from kunde) aQuery
group by knr;

#Einfachere Möglichkeit mit CASE:
select knr,
	case when sum(betrag) is null then 0 else sum(betrag) end summe
from kunde1 natural left outer join bestellung
group by knr;

#Null wurde ersetzt durch die Zahl 0

#LIMIT reduziert die Ausagbe der Anzahl der Zeilen
#Einfaches Beispiel

select count(knr) from kunde1;
#Kunde 1 hat drei Zeilen
#Es sollen aber nur zwei Zeilen ausgegeben werden
select * from kunde1 limit 2;
#In bestimmter geordneter Reihenfolge:
select * from kunde1
order by knr desc limit 2;

#Weiteres Beispiel zu limit:
#Anlegen der Datenbasis:
create table score(egamer integer primary key, score integer unique);
insert into score values(1,100),(2,400),(3,50),(4,80),(5,200);
#Ausgabe der ganzen Tabelle, geordnet nach den Werten der Spalte score absteigend und maximal 3 Zeilen in der Ausgabe
select *from score
order by score desc limit 3;

#Ausgabe der ganzen Tabelle geordnet nach den Werten der Spalte egamer aufsteigend und maximal 2 Zeilen in der Ausgabe
select * from score
order by egamer asc limit 2;

#Fensterfunktionen
#Fensterfunktionen ähneln Aggregatsfunktionen jedoch werden Berechnungen zeilenweise abgearbeitet und brauchen eine over angabe
#Beispiel
insert into score values(1,100),(2,400),(3,50),
						(4,80),(5,200),(6,400),(7,200);
#Wichtig, da hier z.B. der Rang mit vorhanden ist, was ja noch ein Problem in der LIMIT Sektion war wenn zb mehrere den genau gleichen Score haben aufgrund der Limitierung nicht mit ausgegebn werden
select score, row_number() over (order by score desc), rank() over (order by score desc)
from score;

#Jetzt Ziel: Ausgabe der drei besten Gamer nach Score:
select egamer, rang
from (select egamer, rank() over (order by score desc)rang from score)q1
where rang<=3;


#Meta Abfragen auf der gesamten Systemebene
#z.B. Ausgabe aller derzeitig verfügbaren Tabellen im System:
select * from information_schema.tables where table_schema = 'public';


