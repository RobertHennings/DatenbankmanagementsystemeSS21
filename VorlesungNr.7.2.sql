#Skript zur Veranstaltung DBMS SS21
#Vorlesung Nr. 7.2) Nachträgliches Ändern und Anpassen von Datenbanken

#Relation ändern mit ALTER table
#Wertebereiche ändern mit ALTER domain

#Beispielhaft an einem Datensatz

create table test (PersonID integer primary key,
				  Vorname text,
				  Nachname text);
#Beispielhaft Werte einsetzen:
insert into test values (1,'Robert','Hennings'),(2,'Lennart','Hennings'),(3,'Sebastian','Perez');

#Anzeigen lassen:
select * from test;

#Tabelle ändern mit ALTER
#Spalte Nachname soll weg

ALTER table test drop column Nachname;

#Anzeigen lassen:
select * from test;
#Spalte Nachname ist weg

#Neue Spalte hinzufügen

ALTER table test add column Nachname text;
#Anzeigen lassen:
select * from test;

#Enthält natürlich jetzt noch NULL Angaben
#Dort Einträge nachtragen

#Tabelle ändern
ALTER table test add column Ergebnis text;

drop table test;
create table test (PersonID integer primary key,
				  Vorname char(9),
				  Nachname char(8),
				  ergebnis char(8));
#Beispielhaft Werte einsetzen:
insert into test values (1,'Robert','Hennings','gut'),(2,'Lennart','Hennings','sehr gut'),(3,'Sebastian','Perez','mittel');

#Überprüfen ob alle Einträge einer Spalte einem bestimmten Wertebereich entsprechen
alter table test alter column ergebnis char(9)
check (value in('sehr gut','gut','mittel'));


#Generelles Löschen von Tabellen oder Unterobjekten:
#Drop oder delete
#Weiteres anhängen von cascade oder restrict ist möglich

#Beispiele für Wahrung von Integritätsbedingungen
#Hier Wertebereichseinschränkungen bzw Spaltenvorbelegungen

create table ProduktLagertIn(
produktNr integer not null
	check(value between 1000 and 1200),
lagerNr integer not null
	check(value between 100 and 999),
istBestand integer not null
	check(value>=0) default 0,
qualität char(8)
	check(value in ('sehr gut','gut','mittel','schlecht')));
	
	
create table Abteilung(
abteilungsNr integer not null primary key,
abteilungsName varchar(25) unique not null,
budget real check(value between 100 and 1000));

