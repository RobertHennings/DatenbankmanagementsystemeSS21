#Modul Datenabnkmanagementsysteme für Betriebswirte SS2021
#Basis SQL Befehle in der Überischt

#Zunächst Beispieldatensatz anlegen

create table Student(StuID Integer Primary Key,
					StuVorname text,
					StuNachname text,
					StuAlter integer,
					StuWohnort text,
					Fachbereich char(10),
					Fachsemester integer,
					Geburtstag date);





create table Student(StuID Integer Primary Key,
					StuVorname text,
					StuNachname text,
					StuAlter integer,
					StuWohnort text);
					
#Beispielhaft Datensätze in die Relation Student einfügen
insert into Student values (1,'Lennart','Hecker',24,'Essen'),(2,'Sebastian','Perez',22,'Köln'),(3,'Simon','Wanning',22,'Essen');
insert into Student values (4,'Luca','Burgstaller',23,'Essen'),(5,'Niclas','Franchi',24,'Dortmund'),(6,'Gedeon','Vogt',24,'Castrop'),(7,'Niclas','Heller',27,'Essen');
#Beispielhaftes Anzeigen der gesamten Relation Student2:
select * from Student;

#In der Projektion Umbenennung von einzelnen Spalten:
#einfaches dahinter schreiben als erste Option
select Stuvorname Vornamen from student;
#Oder andere auswahlweise
select student.stuvorname vn from student;
#Oder anagbe mit AS
select stuvorname as vn from student;

#Ergebnisspalten können mehrfach vorkommen siehe Beispiel:
select s.*, s.stuvorname as vorname, s.stunachname as Nachname from student s;
#Ohne Umbennenung mit absolut gleichen Attributnamen:
select s.*,s.* from student s;

#Gleiches gilt auch für Umbenennungen von Tabellen auf diese  Weise
select s.stuvorname, s.stunachname from student s;
#Mit Umbenennungen:
select s.stuvorname as Vorname,s.stunachname as Nachname from student s;

#Abrufen auch von Duplikaten mit ALL davor setzen:
#Beispiel Wohnorte:
select stuwohnort from student;
select distinct stuwohnort from student;
#Verschiedene Wohnorte zählen:
select count(distinct stuwohnort) from student;

#Verändern des Tabellenaufbaus mit ALTER:
#Optionen dann Hinzufügen von Spalten: add column Name Datentyp
#oder löschen von Spalten mit drop column Name

Alter table student add column Ergebnis integer;
#Eingefügte spalte ganz am Ende der Tabelle
select * from student;
#Einfügen von Werten
insert into student(ergebnis) values (1),(2),(3),(4),(4),(5);
#wieder löschen der Spalte
Alter table student drop column ergebnis;


#soll ein konstanter Wert für jede Zeile mitausgegeben werden geht dies in der Projektion:
#es wird eine extra Spalte angelegt in der in jeder Zeile die 42 steht
select stuvorname Vorname, 42 Fachbereich from student;


#Nur die ersten paar Zeilen anzeigen lassen mit LIMIT
#ersten zwei Zeilen anzeigen lassen
select * from Student LIMIT 2;

#Spezifische Spalten (Attribute) anzeigen lassen:
#Nur den Vor- und den Nachnamen anzeigen lassen
select StuVorname, StuNachname from Student;

#Nur die der ersten zwei Zeilen anzeigen lassen:
select StuVorname, StuNachname from Student LIMIT 2;

#Jetzt wird unter der Verwendung von WHERE weiter gefiltert:
#Nur alle anzeigen lassen die aus Essen kommen
select * from Student where stuwohnort='Essen';
#Nur alle Anzeigen lassen die aus Köln kommen
select * from Student where stuwohnort='Köln';

#Nur die ersten zwei Zeilen aller Essener ausgeben:
select * from Student where stuwohnort='Essen' LIMIT 2;
#################################################################FROM Teil###############################################################################
#######################################################Alle Arten von Verbünden im FROM Teil##############################################################
#Arten von Verbünden bzw. mengentheoretische Verknüpfungen
#Diese Arten von Verküpfungen brauchen vollständige Typkompatibilität also den exakt selben Aufbau der Relationen mit den exakt selben Anordnungen und Namen der Attribute
#Vereinigung UNION
#Durchschnitt bzw Schnitt INTERSECT
#Differenz EXCEPT
#Division 






#Arten von Verbünden die im FROM Teil ausgeführt werden können:
#Kartesisches Produkt CROSS JOIN
#Natürlicher Verbund NATURAL INNER JOIN
#Verbund mit, Gleichverbund INNER JOIN USING(Tabelle mit Angaben)
#Verbund auf, Thetaverbund JOIN ON(Bedingung die erfüllt sein muss)
#Linker äußerer Verbund LEFT OUTER JOIN
#Rechter äußerer Verbund RIGHT OUTER JOIN
#Totaler äußerer Verbund FULL OUTER JOIN on(Bedingung die erfüllt werden muss)
#Vereinigung UNION JOIN -> Achtung braucht vollstandüge typkompatibilität 



#Für das Testen der Verbünde neue Datenbasis anlegen
create table a (a integer, b integer);
create table b (b integer, c integer);
create table c (c integer, d integer);
#Mit Werten befüllen:
insert into a values(1,10),(2,20),(3,30),(4,40);
insert into b values(10,100),(10,200),(20,100),(20,200),(30,300),(30,400),(40,400);
insert into c values(100,1000),(200,2000),(300,3000),(400,4000);

###########################################################1) Kartesisches Produkt: Alle mit Allen-> Alle möglichen Kombinationsmöglichkeiten
#Gleichnamige Attribute bleiben bestehen
select * from a cross join b;
#Mit allen drei Tabellen
select * from a cross join b cross join c;

#Alternative Syntax:
select * from a,b;
select * from a,c;

#############################################################2) Natürlicher Verbund
#Verknüpfung auf gleiche Zeilenwerte 
#Eliminiert quasi die Attribute die gleich heißen und verknüpft auf deren gleichen Zeilenwerte
#Keine Duplikate
select * from a natural join b;
select * from a natural join c;

select * from a natural join b natural join c;

#############################################################3) Gleichverbund
#Keine Duplikate, beide Tabellen müssen gleiches Attribut haben, auf dessen gleichne Werten wird verknüpft
#Operation geht da a und b beide ein Attribut b haben
select * from a inner join b using(b);
#Dies geht nicht da c kein gleiches Attribut mit a hat
select * from a inner join c using(c);
#Daher ginge nur b und c:
select * from b inner join c using(c);
#############################################################4) Thetaverbund
#Verknüpfung von zwei Tabellen in deren Zeilen eine Bedingungung erfüllt ist die angegeben wird
#Gleiche Attribute werden behalten!
#Verbundung von a und b für die Zeilen, in denen die Werte der zwei Attribute übereinstimmen
select * from a join b on(a.b=b.b);
select * from a join b on(a.b>b.c);
select * from a join c on(a.b<c.c);


################################################################ Äußere Verbünde dann wenn es nicht vollständige Repräsentanzen gibt, also Null Marken links oder rechts eingrfügt werden müssen
#Dafür müssen Werte geändert werden und die Daten neu angelegt werden
drop table a,b,c;

create table a (a integer, b integer);
create table b (b integer,c integer);
create table c (c integer,d integer);
#Mit Werten befüllen:
insert into a values(1,10),(2,20),(3,30),(4,40),(5,50);
insert into b values(10,100),(10,200),(20,100),(20,200),(30,300),(30,400),(40,400),(60,600);
insert into c values(100,1000),(200,2000),(300,3000),(400,4000),(500,5000);

##########################################################5) Natürlicher linker äußerer Verbund
##########################################################Hier am Beispiel der linken Seite, die rechte gilt dementsprechend natürlich analog
#Duplikate werden entfernt, keine gleichen Attribute
select * from a natural left outer join b;
#Da in den Attributen von Tabelle a Werte sind für die es keine Übereinstimmung in Tabelle b gibt wird bei der
#Verknüpfung für diese Zeile im Attribut c von Tabelle b NULL eingesetzt
select * from a;
select * from b;

select * from a natural left outer join c;

#########################################################6)Linker äußerer Gleichverbund
#Es wird auf das gemeinsame Attribut c verbunden, jedoch hat das Attribut leicht divergierende Werte und keine vollständige Entsprechung
select * from a left outer join b using(b);
#Geht zum Beispiel nicht da keine gemeinsamen Attribute entahlten sind
select * from a left outer join c using(a);

##########################################################7)Linker äußerer Thetaverbund (Bedingung selbst zum formulieren)
#Braucht keine Korrespondenz sondern basierend auf eigener angegebener Bedingung
#Dementsprechend kann Duplikate enthalten bzw. doppelte Attribute in Ergebnisrelation
select * from a left outer join b on(a.b=b.b);

##########################################################8) Totaler äußerer Verbund (linkes als auch rechtes Einfügen von NULL Marken)
select * from a full outer join b on(a.b=b.b);



#########################################################################Weitere Unterabfragen im FROM Teil 
#Anstatt eine Tabelle anzugeben kann auch eine eigene Verknüpfung mit Namenszuwesiung stattfinden

select * from
(select b b_aus_a from a) Teilabfrage1 
natural join
(select c c_aus_b from b) Teilabfrage2;



#######################################################################WHERE Teil#########################################################################
#Im where Teil werden alle Ausdrücke zurück gegeben die zu true evaluieren
#Achtung wegen der dreiwertigen Logik in SQL
#Beispiel:
select * from 
a Tabelle_a natural left outer join b Tabelle_b where Tabelle_a.a>2;
#Bei dieser Abfrage wird NULL ebenfalls ausgegeben

#Where Teil kann sich nicht auf in der Select Klausuel umbenannte Attribute/Objekte beziehen
#Beispiel:
select a, a+b as result 
from a 
where a>2 and result >5;

#wie kann also damit umgegangen werden:
############################################1) Möglichkeit
#Wiederholung des Grundausdrucks ohne den zugewiesenen Namen im Where Teil
select a, a+b as result 
from a
where a>2 and a+b>5;
############################################2) Möglichkeit
#Zwischenspeicherung des Ergebnisses in eigener Unterabfrage und Abrufung daraus als Tabelle
select a, result
from
(select a, a+b as result from a) Teilergebnis
where a>2 and result >5;


###############################################################################Achtung mit der dreiwertigen Logik in SQL##################################
#Beispiel:
create table Dreiwertig (a text);

insert into Dreiwertig values('stefan'),('Klaus'),(null);
select * from Dreiwertig;
#Evaluiert zu true daher aufpassen bei dem folgenden wird null nicht mit ausgegeben:
#alle die nicht... sind sollen ausgegeben werden
select * from Dreiwertig where a!='stefan';

#Bei der folgenden Anfrage wird jedoch null ausgegeben:
alle außer .... sollen ausgegeben werden
#Achtung auch wie 'Stefan' geschrieben ist da ist SQL Casesensitive mit Groß- und Kleinschreibung
select * from Dreiwertig except select * from Dreiwertig where a='stefan';





#Weitere Filterungstechniken mit weiteren Operatoren
#Alle die nicht in Köln wohnen

select * from Student where stuwohnort !='Köln';

#Alle die älter als 20 sind ausgeben lassen mit Vor- und Nachname:

select StuVorname, StuNachname from Student where stualter>20;
#Alle mit Vorname und wohnort ausgeben die jünger als 25 sind:
select StuVorname, Stuwohnort from Student where stualter<25;

#Alle ausgeben bei denen der Wohnort den Buchstaben e enthält:
#Sollten alle Essener kommen
select * from Student where stuwohnort LIKE'%e%';

#Alle ausgeben bei denen das Alter eine 2 enthält also alle die in ihren 20ern sind:
#Geht mit Zahlen nicht da Text erwartet wird, geht nur mit Spalten die Textueller Datentyp sind
select *from Student where stualter like '%2%';


#Weitere Filterung mit mehr als einer Bedingung durch den Operator AND im where:
#Alle die in Essen wohnen ausgeben und die jünger als 23 sind:
select StuVorname, StuNachname,StuAlter,StuWohnort from Student where StuWohnort='Essen' AND StuAlter<23;

#Alle die nicht in Essen wohnen und den Nachnamen Hecker haben
select StuVorname,StuNachname,StuID from Student where StuWohnort!='Essen' AND StuNachname='Hecker';
#Richtige Ausgabe, dies ist niemand

#Mehrere Filterkriterien gehen auch statt mit AND mit OR:
#Alle die mit Nachnamen Hecker oder Perez heißen ausgeben:
select * from Student where StuNachname='Hecker' OR StuNachname='Perez';

#Ausgabe aller Angaben für die wo der Wohnort entweder den Buchstaben e oder k enthält:
#Achtung LIKE ist Casesensitive mit Groß und Kleinschreibung
select * from student where StuWohnort LIKE '%e%' OR StuWohnort LIKE '%K%';


#Die Ausgabe soll nun nach einer bestimmten Spalte geordnet werden:
#Geordnet darstellen nach dem Alter
select * from Student ORDER BY StuAlter;

#Alle Vornamen geordnet darstellen:
select StuVorname from Student ORDER BY StuVorname;

#Alle Vornamen und Nachnamen ausgeben aber nach Nachname ordnen:
select StuVorname, StuNachname from Student ORDER BY StuNachname;

#Nach Alter sortieren aber nicht aufsteigend sondern absteigend und nur die erste Zeile ausgeben
#Also älteste Person ausgeben
select StuVorname,StuNachname,StuAlter from Student ORDER BY  StuAlter DESC LIMIT 1;

#Jetzt sollen nur die einzigartigen Werte eines Attributs (Spalte) ausgegeben werden:
#welche Altersabdeckung gibt es im Datensatz?
select distinct(StuAlter) from Student;
#Auf und Absteigende Sortierung
select distinct(StuAlter) from Student ORDER BY StuAlter DESC;

#Welche Wohnorte gibt es im Datensatz?
select distinct(StuWohnort) from Student;

#Generelle Struktur von Befehlen:
select
from 
where
order by
limit

#Einführung der Aggregatsfunktionen
#Generell gibt es count(),sum(),avg(),min(),max()

#Verwendung in SQL
#Zählen wie viele Menschen in Köln wohnen:
select count(*) from Student where StuWohnort='Köln';
#Zählen wie viele verschiedene Wohnorte es gibt:

select count(distinct(StuWohnort)) from Student;
#4 verschiedene Wohnorte insgesamt
#Wie viele sind zwischen 20 und 23 Jahre alt?
select count(*) from Student where StuAlter>20 AND StuAlter<23;
#2 Leute die zwischen 20 und 23 Jahren alt sind
#wie viele Leute wohnen in Essen und Köln zusammen?
select count(*) from Student where StuWohnort='Köln' OR StuWohnort='Essen';
#4 Leute in Summe

#Wie alt sind die Leute im Durchschnitt?
select avg(StuAlter) from Student;
#23.167 Jahre im Schnitt

#Durchschnittsalter aller der in Essen wohnhaften Leute:
select avg(StuAlter) from Student where Stuwohnort='Essen';
#23 Jahre im Schnitt
#Durchschnittsalter aller der in Köln wohnhaften Leuten:
select avg(StuAlter) from Student where StuWohnort='Köln';
#22 Jahre im Schnitt

#Summe der StuID bilden:
select sum(StuID) from Student;
#Summe der Alterspalte bilden:
select sum(StuAlter) from Student;

#Maximales und Minimales Alter der Leute ausgeben
select max(StuAlter) from Student2;

###################################################################Group By Klauseln in SQL##############################################################
#Wenn man die Anzahl des Vorkommens einer bestimmten Kategorie braucht:
#Anlegen der Datenbasis
create table ProduktLagertIn (ProduktNr integer,
							 produktLagerBez varchar(10),
							 istBestand integer);
#Mit Daten befüllen:
insert into ProduktLagertIn values(1234,'Essen',1500),(1234,'Frankfurt',500),(1234,'Hamburg',5000),(1234,'München',2000),(4711,'Berlin',300),(4711,'Essen',150),
(4711,'Frankfurt',750),(5111,'Hamburg',2000),(5111,'München',6000);

select * from ProduktLagertIn;

#Abfrage: Gib pro Lager die Anzahl der dortig gelagerten Produkte an (unterschiedliche Produkt Nummern)
select produktLagerBez as lager, count(produktNr) as produkte
from ProduktLagertIn
group by ProduktLagerBez;

#################################################################Order By Klauseln in SQL################################################################
#Als Kontrast zum Group By Befehl: Gib pro Lager alle dort gelagerten Produkte aus
select * from ProduktLagertIn;
select ProduktlagerBez as Lagerort, ProduktNr 
from ProduktLagertIn 
order by Lagerort;

#Weitere Anpassung der Order By Klausel
#Aufsteigende Sortierung
select ProduktLagerBez as Lager, ProduktNr
from Produktlagertin
order by Lager asc;
#Absteigende Sortierung:
select ProduktLagerBez as Lager, ProduktNr
from Produktlagertin
order by Lager desc;


##############################################################Having und Where Klauseln###################################################################
#Beispiel: Gib für die Lager München und Berlin die Anzahl der dort gelagerten Produkte aus:
#Having ist quais das Where des Group by Befehls
select ProduktLagerBez as Lager, count(ProduktNr) As Produkte
from ProduktlagertIn
group by ProduktLagerBez
Having ProduktLagerBez = 'München' OR ProduktLagerBez = 'Berlin';


#Gib pro Lager die Anzahl der dort gelagerten Produkte mit kleinerem Bestand als 500 aus
select ProduktLagerBez as lager, count(produktNr) as produkte
from ProduktlagertIn
group by produktlagerbez
	having istbestand <500;







#Zählt für jeden einzigartigen Wert der Spalte StuID die Werte
select StuID,count(StuWohnort) from Student group by StuID;

#Wie viele Leute wohnen je Wohnort?
select Stuwohnort,count(StuWohnort) from Student group by StuWohnort;

#SQL Aliases bzw. Umbenennung von Spalten
#Neubenennung in der Ausgabe von Vorname
select StuVorname AS Vorname_Student from Student;
#Neubenennung von Vorname und Nachname
select StuVorname As Vorname_Student, StuNachname As Nachname_Student from Student;
#Ordnen nach Nachname
#Achtung bei Order muss direkt der neue Name des Attributs verwendet werden
select StuVorname As Vorname_Student, StuNachname As Nachname_Student from Student Order by Nachname_student desc;

#SQL JOIN Verküpfungen von mehreren Relationen
#Dafür wird andere, zweite Relation gebraucht
#Anschauen was für Tabellen noch vorliegend sind
select * from Student LIMIT 2;

#Student und Student2 sollen auf den werten von StuID und Personid verbunden werden
select * from Student JOIN Student2 ON Student.personID=Student.StuID;
#Zusammenführung aller Zeilen wo die Werte von PersonID mit denen von StuID übereinstimmen
#Besser zu sehen:
select PersonID, StuID from Student JOIn student2 ON Student.personID=Student.stuID;

#SQL Having Klauseln
#Wird gebraucht da Filterungen mit aggregatsfunktionen im where nicht funktionieren siehe Beispiel:
#Ausgabe aller Daten zu der Person die am ältesten ist
select Max(Stualter) from Student;
select * from Student where Stualter=max(StuAlter);
#Dieser Befehl funktioniert nicht daher mit HAVING

#Korrekte Reihenfolge an Befehlen
select
from 
join
where
group by
having
order by
limit

