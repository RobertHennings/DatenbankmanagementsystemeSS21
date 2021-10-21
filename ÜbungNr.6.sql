#Modul Datenbankmanagementsysteme SS21
#Übung Nr.6)
#Aufgabe Nr.1)

#Datenbasis anlegen
#Alle alten Tabellen löschen
DROP TABLE IF EXISTS Person,Student, Mitarbeiter, Lehrveranstaltung, Leistung, Semesterbeitrag, Zahlung;

create table Person(personID serial primary key, vorname varchar, nachname varchar);

DROP TABLE IF EXISTS Student;
create table Student(personID integer primary key references Person(personID),
							matrNo varchar unique,
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
create table Leistung(matrNo varchar references Student(matrNo),
					 lv_nr integer,
					 note numeric,
					 datum date);
					 
					  
DROP TABLE IF EXISTS Semesterbeitrag;
create table Semesterbeitrag(matrNo varchar,
							datum date,
							geforderterBetrag numeric);
							
DROP TABLE IF EXISTS Zahlung;
create table Zahlung(matrNo varchar,
					datum date,
					betrag numeric);
					

					  
					  
					  
#Beispieldatensätze einfügen

INSERT INTO Person VALUES (1, 'Max', 'Mustermann'), (2, 'Klaus', NULL), (3, 'Mia', 'Klopodaczyk'), (4, 'Naka', 'Baka'), (5, 'Torpy', 'Torp'), (6, 'Meaty', 'Mitsu');
INSERT INTO Student VALUES (1, 'ES03030301', 5, 'Mathe', 1, 1), (2, 'ES03030302', 5, 'Mathe', 1, 1), (3, 'ES03030303', 4, 'Informatik', 2, 2), (4, 'ES03030304', 4, 'Informatik', 4, 5);
INSERT INTO Mitarbeiter VALUES (5, 10, 400, 'S05R05E05'), (6, 20, 900, 'S05R06E05'), (4, 10, 450, 'S05R04E04');
INSERT INTO Lehrveranstaltung VALUES (1, 'R01S01E03', DATE '2018-04-01', 'HS'), (2, 'R01S01E03', DATE '2019-04-15', 'HS'), (3, 'S02S01G04', DATE '2020-01-14', 'NS');

INSERT INTO Leistung VALUES ('ES03030301',1,2.3,'2020-03-03'),('ES03030302',2,1.0,'2020-04-04'),('ES03030303',3,1.0,'2020-02-02');
INSERT INTO Semesterbeitrag VALUES ('ES03030301','2020-06-06',318.20),('ES03030302','2020-06-06',318.20),('ES03030303','2020-06-06',318.20),('ES03030304','2020-06-06',318.20);
INSERT INTO Zahlung VALUES ('ES03030301','2020-05-05',318.20),('ES03030302','2020-05-04',318.20);


#Überprüfen der Werte 
select * FROM Semesterbeitrag;
select COUNT(matrikelnummer) FROM Student;
#Richtige Anzahl von 4 Studenten eingetragen

#Annahme dass nur von 2 Studenten bereits Zahlungen eingegangen sind
select * FROM Zahlung;

#Unteraufgaben
#a) Differenz aus geforderten und erhalten Beiträgen ausgeben (mit Aggregatsfunktionen)
#Es wird die Höhe des Betrags also numerischer Wert gefordert


