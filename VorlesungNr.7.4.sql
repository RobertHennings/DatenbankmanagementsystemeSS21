#Modul Datenbankmanagementsysteme für Betriebswirte SS21
#Vorlesung Nr. 7.4 Verbünde, Unterabfragen und WHERE Klauseln

#Beispielhaftes Anlegen der Datenbasis für die Verbünde

create table A (a integer,
			   b integer);
create table B (b integer,
			   c integer);
create table C (c integer,
			   d integer);
			   
#Werte in die angelegten Tabellen einsetzen

insert into A values(1,10),(2,20),(3,30),(4,40);
insert into B values(10,100),(10,200),(20,100),(20,200),(30,300),(30,400),(40,400);
insert into C values(100,1000),(200,2000),(300,3000),(400,4000);

#Überprüfung der Befüllung der Datensätze

select * from A;
select * from B;
select * from C;
################################################Verbünde anwenden################################################
#1) Kartesisches Produkt, also alle möglichen Kombinationsmöglichkeiten der Zeilen der zwei verwendeten Tabellen
#Zwei Möglichkeiten der Syntax dafür
#Erste Möglichkeit
select * from A,C;
#Dimension ist Zeilen A mal Zeilen B
#Zweite Möglichkeit
select * from A CROSS JOIN C;

#Aufpassen bei gleichnamigen Attributen (Spalten)
#Wird zB gefragt:
select b from A,B;
#resultiert eine Fehlermeldung da nicht klar ist welches von den zwei bs gemeint ist
#Genauere Angabe des gebrauchten Attributs durch z.B Tabellenname.Attributname
select A.b from A,B;
select B.b from A,B;

#Filtern nacch den unique Values in einem Attribut mit dem vorschalten von distinct 

select distinct A.b from A,B;

#2) Natürlicher Verbund
#Verbindung aller Zeilen die eine Entsprechung in beiden Tabellen haben, dann Ausgabe als Projektion auf das gemeinsame Attribut

select * from A NATURAL JOIN B;
#Keine Doppelungen an Attributen (Spalten) in dieser Variante
#Beispiel natürlicher Verbund von allen drei Tabellen die vorliegen

select * from A NATURAL JOIN B NATURAL JOIN C;
#Es wird auf die gemeinsamen Spalten projeziert, keine Doppelungen an Attributen
#Nur auf den Zeilen in denen es gemeinsame Entsprechungen gibt

#3) Gleichverbund, Inner Join USING
#so lässt soch auch ein Gleichverbund erzeigen bei Verwendung der gemeinsame Spalten
select * from A INNER JOIN B USING(b);
#es wird das Attribut b als gemeinsame Verbindung vorgegeben
#Ergebnis ist das gleiche wie im natürlichen Verbund
select * from A INNER JOIN B USING(a);
#Es muss immer die gemeinsame Spalte mitgegegben werden

#Es resultiert eine Projektion auf die gemeinsamen Attribute also wieder keine Doppelungen vorhanden

4) Thetaverbund, Möglichkeit der eigenen Angabe von Verbundbedingungen 
#Verbindet alle Zeilen für die die Verbundbedingung erfüllt ist

select * from A JOIN B ON (A.b=B.b);
#es werden alle Zeilen verbunden in denen die Werte aus A und B sich entsprechen
#Es finden bei ON jedoch Doppelungen von Spalten statt, es findet per default keine Projektion auf die gemeinsamen Splaten statt
#Dafür ist ja die Verbundbedingung vorgegeben

#Es können auch ausgefallenere Bedingungen vorgegeben werden
#Muss sich bei der Beziehung jedoch immer um die gemeinsamen Attribute handeln
select * from A JOIN B ON (A.b>B.b);
select * from A JOIN B ON (A.b<B.b);


#Anwendung der äußeren Verbünde auf die drei Tabellen
#Äußere Verbünde funktionieren auch als natural join oder inner join

#Dafür ist aber zunächst eine Modifikation der Datenbasis nötig
select * from A;
select * from B;
select * from C;

#Werte hinzufügen für die gemeinsamen Attribute die jedoch keine richtige Entsprechung haben
insert into A values(5,50);
insert into B values(60,600);
insert into C values(500,5000);

#Beispielhaft mit der linken äußeren Seite, alles gilt analog für die rechte Seite
#Natürlicher linker äußerer Verbund
select* from A NATURAL LEFT OUTER JOIN B;
#In letzter Zeile wurde in Attribut c mit der Null Marke aufgefüllt da es in Tabelle B keine Entsprechung für b=50 gab

#Linker äußerer Verbund mit USING 
select*from A LEFT OUTER JOIN B USING(b);
#Hier ein ähnlicher Fall

#Bei der Variante mit ON kommt wieder die Doppelung des Attributs vor
select*from A LEFT OUTER JOIN B ON(A.B=B.b);
#Dementsprechend in letzter Zeile diesmal zweimal mit der Null Marke aufegüllt da die ganze b Spalte aus B übernommen wurde


#Vollständiger äußerer Verbund
select * from A FULL OUTER JOIN B ON(A.b=B.b);

#########################################Unterabfragen in From##################################################
#Neuaufsetzen der Datenbasis für diesen Teil
#Alle bestehenden Löschen
drop table A;
drop table B;
drop table C;

#Neue aufsetzen
create table A(a integer, b integer);
create table B(b integer, c integer);
create table C(c integer, d integer);
#Mit Werten befüllen

insert into A values(1,10),(20,20),(30,30);
insert into B values(20,100),(30,300),(40,400);

#An jeder Stelle einer Abfrage an der eine Tabelle erwartet wird kann acuh eine beannte Abfrage gesetzt werden

#Beispiel:
select * 
from (select b myb from A) aQuery 
NATURAL JOIN 
(select c myc from B) bQuery;
#Alle mit allen verbunden demnach
select A.b from A;
select B.c from B;

##########################################Filterangaben in WHERE Klauseln########################################

#Beispiel für Filterangeb in WHERE Klausel
select * 
from A myA NATURAL LEFT OUTER JOIN B
WHERE myA.a>2;

#Alle Zeilen werden ausgegegebn, WHERE bezieht sich damit immer auf die Anzahl der Zeilen der Tabelle


select *
from A myB NATURAL RIGHT OUTER JOIN B
WHERE myB.a<2;
#Keine sind kleiner als 2


#Filetrungen im WHERE Teil könne sich jedoch nur auf Angaben beziehen die bereits im FROM Teil bestehen
#Beispiel
select A, a+b as result
from A
WHERE A>2 AND result>10;
#Es resultiert eine Fehldermeldung da "result" nicht im FROM Teil besteht

#Zwei mögliche Lösungen für diesen Fall
#Erste Möglichkeit
select A,a+b as result
from A
WHERE A>2 AND a+b>10;

#Zweite Möglichkeit
select a, result
from (select a, a+b as result from A) ergebnis
WHERE A>2 AND result>10;

#########################Achtung beim Zeilenfiltern durch die dreiwertige Logik mit null Werten in SQL###########
#Es werden zwei Operationen ausgeführt die an sich den selben Output haben sollten jedoch unterschiedlich null Werte handhaben
#WHERE Bedingung muss zu TRUE evaluieren


#Dafür anlegene einer neuen Tabelle
create table test(a text);
#Werte einsetzen
insert into test values('Stefan'), ('Klaus'),(null);

#Erster Befehl
select * 
from test
WHERE a!='Stefan';
#Null Werte nicht entahlten

#Zweiter Befehl
select * from test
except 
select * from test WHERE a='Stefan';

#Null Marke jedoch hier enthalten, demanch unterschiedliche Handhabung der Null Marke


#########Kategorisierung von Unterabfragen in Wertliefernde und Mengenleifernde Unterabfragen#####################
#Teil 1)
#Einführung der Aggregatfunktionen, sind im Prinzip die normalen deskriptiven In Built Funktionen von SQL

select * from A;
#########################################Aggregatsfunktionen in SQL###############################################
select max(a) from A;
select max(b) from A;
#Es gehen auch mehrere Aggregatfunktionen für verschiedene Attribute gleichzeitig
#Sie müssen jedoch alle Einzeiler liefern als Voraussetzung
select max (a), max(b) from A;

#Deskriptive Maße für Spalte a von Tabelle A
select min(a), max(a), avg(a), sum(a) from A;
#Deskriptive Maße für Spalte b von Tabelle A
select min(b), max(b),avg(b),sum(b) from A;

#Allerdings geht es nicht dass zusätzlich zu den Aggregatfunktionen noch Spalten ausgegeben werden
#Beispiel
select b, max(b) from A;


#Handhabung des Wertes null in Aggregatsfunktionen
create table D(a integer);

insert into D values(1),(2),(3),(4),(null);

select min(a), avg(a) from D;

#Durchschnitt beachtet null nicht


#Zwei Möglichkeiten wie eine Aggregatsfunktion null als Ergebnis liefern kann
#Erstens: Wenn ganze Tabelle nur aus null besteht 
#Zweitens: Wenn Tabelle leer ist

#Erste Variante:
create table E(a integer);
insert into E values(null);

select min(a), max(a), avg(a) from E;

#Zweite Variante: Leere Tabelle
create table F(a integer);
select min(a), max(a), avg(a) from F;

#Sollen nur unique values ausgegeben werden so muss distinct verwendet werden:
create table G(a integer);
insert into G values(1),(2),(3),(4),(5),(5),(5);

select avg(a) from G;
#Nun mit distinct

select avg(distinct a) from G;

############################################COUNT Funktion in SQL################################################
#Drei Varianten COUNT zu verwenden

select * from G;
insert into G values(null);

select COUNT(*), COUNT(a), COUNT(distinct a) from G;
#COUNT(Attributname) zählt alle von null verschiedenen
#distinct dann alle unique values


###################################Einbindung der Aggreagtfunktionen in den WHERE Teil############################
select * from G;

select avg(a) from G;

select * from G
WHERE a < (select avg(a) from G);


#Achtung es kann kein Vergleich in WHERE mit einer ganzen Tabelle geliefert werden bzw. wo gleichzeitig eine ganze Spalte einbezogen wird
drop table F;

create table F(a integer);
insert into F values(1),(2),(4),(6);


select * from G
WHERE a >(select a from F);

############################################Unteranfragen und äußere Werte#######################################

select * from A;

select *
from A
WHERE a>(select (a-1));


####################################Teil 2) Mengenorientierte Unterabfragen#######################################
#Löschen der Tabellen
drop table A;
drop table B;
#Neuaufsetzen der Tabellen

create table A(x integer, y integer);
create table B(r integer, s integer);

insert into A values(1,2),(2,3),(3,4),(4,5),(5,6);
insert into B values(1,2),(1,3),(2,2),(2,3);


select * from A WHERE x IN (select r from B);

select * from A WHERE (x,y) IN (select r,s from B);


#Null Werte werden nicht berücksichtigt in Vergleichen
#Beispiel:

insert into A values (null,null);
insert into B values(null,null);
select * from A WHERE (x,y) IN (select r,s from B);
#Null wird in der Ausgabe nicht berücksichtigt


#Nun soll eine gesamte Tabelle verglichen werden und damit miteinbezogen werden

select * from A WHERE x < ALL (select * from B);
select * from A;







