#Modul Datenbankmanagementsysteme SS21
#Übung Nr.5)
#Aufgabe Nr.1)

#c) Erzeugen von Wahrheitstabellen in SQL für alle drei Logikfälle True, False und NULL
#AND Tabelle
select True "AND", True "True",False "False",Null "Null" 
UNION ALL
select False, False, False, False 
UNION ALL
select Null, Null, False, Null;

#OR Tabelle
select True "OR", True "True", True "False", True "Null"
UNION ALL
select False, True, False, Null
UNION ALL
select Null, True, Null, Null;

#Not Tabelle
select '' "Not", False "True", True "False", Null "Null";

#d) anhand einer Typkonvertierung aufzeigen wie sich Eregbnis ändern kann
#Einfache Typkonvertierung in SQL
#1.2 als integer oder dezimalzahl
select 1.2::integer "IntegerZahl";
select 1.2::decimal "DezimalZahl";

#e) Unterscheidliche Handhabung des Dateformats

select Date '2020-03-03' -Date '2020-02-02' "Unterschied";

select '2020-03-03' - '2020-02-02' "Unterschied2";

select '2020-03-03' - Date '2020-02-02' "Unterschied3";

select '2020-03-03' > Date '2020-03-03';

#g) Handhabung von null Werten in Nachnamen und deren richtige Ausgabe

drop table if exists person;

create table person (personID integer unique primary key,
					nachname varchar)
					
#Werte einsetzen

insert into person values (1,'Hecker'), (2,'Nowak'),(3,'Wanning');

insert into Person values(4 ,null);
select * from Person;

#Jetzt Überprüfen
#Es sollen alle ausgegeben werden deren Nachname ungleich Hecker ist
#Variante 1) null soll mit ausgegeben werden
select * FROM Person WHERE (nachname ='Hecker') is not true;

#Variante 2)
#Null wird nicht mit ausgegeben
select * from Person WHERE (nachname !='Hecker');

#Variante 3)

#i) Drei verschiedene Varianten der Aggregatfunktion COUNT()
select * FROM Person;

#Variante 1)
select COUNT(*) FROM Person;

#Variante 2)
select COUNT(nachname) FROM Person;

#Variante 3)
select COUNT(distinct nachname) FROM Person;

#Aufgabe Nr.2)
#Anlegen der Datenbasis mit allen Tabellen
DROP TABLE IF EXISTS Person;
create table Person(personID serial primary key, vorname varchar, nachname varchar);

DROP TABLE IF EXISTS Student;
create table Student(personID integer primary key references Person(personID),
							matrikelnummer varchar unique,
							fachbereich integer,
							studienfach varchar,
							semester integer,
							fachsemester integer);
							
DROP TABLE IF EXISTS Mitarbeiter;
create table Mitarbeiter(personID integer primary key references Person(personID),
						wochenstunden integer,
						gehalt numeric,
						raum varchar);
						
						
DROP TABLE IF EXISTS Lehrveranstaltung;
create table Lehrveranstaltung(lv_nr serial primary key,
							  raum varchar,
							  gehalten_seit date,
							  status varchar);
							  
							  
DROP TABLE IF EXISTS Leistung;
create table Leistung(personID integer references Student(personID),
					 lv_nr integer,
					 note numeric);
					 
DROP TABLE IF EXISTS Betreuung;
create table Betreuung(personID integer references Mitarbeiter(PersonID),
					  lv_nr integer);
					  
#Beispieldatensätze einfügen

INSERT INTO Person VALUES (1, 'Max', 'Mustermann'), (2, 'Klaus', NULL), (3, 'Mia', 'Klopodaczyk'), (4, 'Naka', 'Baka'), (5, 'Torpy', 'Torp'), (6, 'Meaty', 'Mitsu');
INSERT INTO Student VALUES (1, 'ES03030301', 5, 'Mathe', 1, 1), (2, 'ES03030302', 5, 'Mathe', 1, 1), (3, 'ES03030303', 4, 'Informatik', 2, 2), (4, 'ES03030304', 4, 'Informatik', 4, 5);
INSERT INTO Mitarbeiter VALUES (5, 10, 400, 'S05R05E05'), (6, 20, 900, 'S05R06E05'), (4, 10, 450, 'S05R04E04');
INSERT INTO Lehrveranstaltung VALUES (1, 'R01S01E03', DATE '2018-04-01', 'HS'), (2, 'R01S01E03', DATE '2019-04-15', 'HS'), (3, 'S02S01G04', DATE '2020-01-14', 'NS');
INSERT INTO Leistung VALUES (1, 1, 5.0), (1, 2, 4.0), (1, 3, 1.7), (2, 1, 2.7), (2, 2, 2.3), (3, 2, 3.3);
INSERT INTO Betreuung VALUES (5, 1), (6, 2), (4, 3);


#Unteraufgaben
#a) Ausgabe der Vor- und Nachnamen aller Studenten
#Übersicht der Tabelle Student
select * FROM Student;

select vorname, nachname FROM Student JOIN Person USING (personID);

#b) PersonID und Matrikelnummer aller Studenten des Fachbereichs 5 ausgegeben die im ersten Semester sind
select personID, Matrikelnummer FROM Student WHERE Fachbereich = 5 AND Semester = 1;

#c) Name, Matrikelnummer und Gehalt ausgeben von allen Mitarbeitern die gleichzeitig Studenten sind

select vorname, nachname, Matrikelnummer, Gehalt FROM Student JOIN Mitarbeiter USING(PersonID) JOIN Person USING(PersonID);

#d) Name und Gehalt aller Mitarbeiter ausgeben und sofern sie auch Studenten sind auch die Matrikelnummer
#Achtung es müssen automatisch Nullmarken eingefügt werden für ein paar Mitarbeiter 
select vorname, nachname, gehalt, matrikelnummer FROM Mitarbeiter JOIN Person USING(PersonID) LEFT JOIN Student USING(PersonID);

#e) Alle Mitarbeiter ausgeben die eine Lehrveranstaltung im Status 'HS' betreuen zu denene bereits Leistungen von Studenten abgelegt wurden

select distinct m.PersonID FROM Mitarbeiter m JOIN Betreuung b ON b.PersonID=m.PersonID JOIN Leistung l ON 
	l.lv_nr=b.lv_nr JOIN Lehrveranstaltung lv ON lv.lv_nr=l.lv_nr WHERE lv.status='HS';
	
#f) Alle Lehrveranstaltungen des Hauptstudiums ausgeben in denen kein Student durchgefallen ist (Alle müssen also <5.0 sein)
select lv_nr FROM Lehrveranstaltung JOIN Leistung USING(lv_nr) WHERE status ='HS' EXCEPT (select distinct lv_nr FROM Leistung WHERE note =5.0);
#Nur eine Lehrveranstaltung