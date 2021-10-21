#Vorlesung Nr. 7.2 Abfragesprache und Select
select 'A'
#Müssen auch unbedingt einzelne '' sein mit "" funktioniert es nicht
#Ergebnis liegt vor jedoch mit unbekanntem Spaltennamen

#Spaltennamen dazu definieren
select 'A' Spalte1

#oder mit Keyword as
select 'A' as mya, 'B' myb

#Werte haben bestimmten Datentyp wie hier zweimal text
#andere Beispiele mit integer, boolean und numeric

select 42 answer

select true WahroderFalsch

select 4.5 gleitkommazahl

#Verschiedene Umwandlungen von verschiedenen Datentypen
#mit cast und as

select CAST(1.2 as integer) nummer

#mit ::
select 1.2::integer nummer2
#Mit anderen Datentypen
select '12:00:00'::Time highnoon

select 4.2::decimal(4,2) dezimalzahl

#Besondere Konstanten
select current_date aktuellesDatum
select current_time aktuelleZeit
select current_timestamp aktuellesDatumGanz
select current_user aktuellerUser
#Dementsprechend auch andere Datentypen hier vorhanden bei den Besonderheiten an Konstanten

#Verscheidene arithmetische Ausdrücke die auf verschiedenen Datentypen angewendet werden können
select 'DB' = 'MS' as myresult #Überprüfung auf Gleichheit

select 'DB' || 'MS' myString #Zusammenfügen von einzelnen Bestandteilen
select 'HA' || 'LLO' Hallo

select 'c' > 'etwashier' islarger #Größenüberprüfungen
#Einfache Rechnungen
select 3*2/3 rechnung

#Achtung bei Rechnungen mit Typ integer da hier keine Nachkommastellen ausgegeben werden sondern nur ganzzahlige ergebnisse
select (3/2)*2 test
#ergebnis ist 2 und nicht 3 wie es muss

#Lösung: Konvertieren des Datentyps zu numeric
select (3::numeric)/2*2 test2
#Jetzt drei als Ergebnis

#Oder implizierte Umkonvertierung durch Multiplikation mit 1.0
select 1.0*3/2*2 test3

#Oder direkt 3.0 angeben ist auch möglich
select 3.0/2*2 test4

#Datentyp Date, Time und Timestamp
#gebräuchliche Notation für Date
select Date '2021-07-30' aktuellesdatum
#so sind auch Vergleiche möglich
select Date '2021-07-30' > '2021-07-28' vergleich
#oder Differenzen
select Date '2015-01-02' -  '2015-01-01' differenz
#Addition geht nicht zum Beispiel
select Date '2015-01-02' +  '2015-01-01' addition

#Datentyp Time
select Time '11:05:01' zeit
#Auch hier vergleiche oder differenzen möglich
select Time '11:05:01' > '11:04:03' vergleichzeit

select Time '11:05:01' - '11:04:03' differentzeit

#Datentyp Timestamp
select current_timestamp heute


#Wichtige Funktionen für Zeit Datentypen: extract, womit spezielle Teile der Angabe ausgegeben werden können
#Beispiel
#Jahr aausgeben
select extract(year from date '2021-07-30') jahr
#Tag
select extract(month from date '2021-07-30') tag
#Monat

#Second, Minute, hour
select extract(minute from current_time) aktuelleminute

select extract(hour from current_time) aktuellestunde

#wert NULL kann an jeder stelle verwendet werden außer in Attributen die explizit asl non-null deklariert wurden
select NULL and TRUE

#Alle anderen Opeartionne in denen NULL vorkommt führen zu NULL als Ergebnis
 
select 1+NULL test1
select NULL*23 test2
select 1 = NULL test3
select NULL is NULL test4
select 1 is NULL test5

#Mengenoperationen in SQL
#UNION: Vereinigung
#INTERSECT: Schnitt
#EXCEPT: Differenz

#Beispiele
#Vereinigung von Werten untereinander als Zeilen
select 'A'x UNION select 'B'x
#ist egal wie die Attribute heißen es wird schlicht zeilenweise zusammengeführt da ja UNION mitgegebn wird
select 'A'x UNION select 'B'y
#Ohne UNION natürlich unterschiedliche Spalten bei Angabe
select 'A'x, 'B'y

#Beispiel: Schnitt
(select 'A'x UNION select 'B'x)
INTERSECT
(select 'B' UNION select 'C')
#Schnitt gibt nur den Datensatz zurück der sowohl in der ersten als auch in der zweiten Relation enthalten sind
#Hier also die Zeile B die in beiden Relation enthalten ist

#Beispiel: Differenz
(select 'A'x UNION select 'B'x)
EXCEPT (select 'A')
#A wird abgezogen, es bleibt nur B als Datensatz zurück

#Achtung die Reihenfolge muss eingehalten werden da auch bei Mitgabe der Attributnamen kein richtiges Einfügen folgt
(select 'A'x, 'B'y)
UNION 
(select 'B'y,'C'x)

#Mit richtiger Reihenfolge
(select 'A'x, 'B'y)
UNION 
(select 'C'y,'B'x)

#Nur die Reihenfolge ist wichtig, Attributnamen sind egal
(select 'A'a,'B'b)
UNION
(select 'B'x,'C'y)


#Mengen und Duplikate 
#Mengenausdrücke eliminieren alle Duplikate 
#Sollen diese trotzdem angezeigt werden muss das Keyword ALL mitgegeben werden
#Duplikate enthalten
(select 'A'a,'B'b)
UNION ALL
(select 'A'x, 'B'y)
#Keine Duplikate per default
(select 'A'a,'B'b)
UNION 
(select 'A'x, 'B'y)

#Zweites Beispiel
#Ohne Duplikate 
((select 'A'a,'B'b)UNION ALL (select 'A'x, 'B'y))
INTERSECT ((select 'A','B')UNION ALL (select 'A'x,'B'y))
#Mit Duplikaten
((select 'A'a,'B'b)UNION ALL (select 'A'x, 'B'y))
INTERSECT ALL((select 'A','B')UNION ALL (select 'A'x,'B'y))


#FROM Opeartor im Detail
#Anlegen von Beispieldaten
#Relation Person anlegen

create table Person1 (personNr integer primary key,
					vorname text not null,
					nachname text not null)
					
#Werte einfügen
insert into person1 values (42,'Stefan','Hanneberg');
insert into person1 values (12,'Lennart','Hecker');
insert into person1 values (35,'Lennart', 'Hecker');
#Bisher bekannt: Alles abrufen mit * 			
select*from person1;

#Jetzt Projektion bzw. Anzeigen von nur bestimmten Spalten also Attributen
#Nur Spalte vorname
select vorname from person1;

#Spalten vorname und nachname anzeigen lassen, einfach Verknüpfen mit , die Spaltennamen
select vorname,nachname from person1;
#Jedoch zu sehen: Duplikate hier 
#Anzeigen aber ohne Duplikate mit distinct

select distinct vorname,nachname from person1;
#letzte Zeile jetzt weggelassen

#Alternative Projektion von einzelnen Spalten durch Tabelle.Spaltenname
select 
	person1.vorname,
	person1.nachname
	from person1;

#Gleichzeitiges umbenennen von einzelnen Spalten auch möglich
#Nachname wird umbenannt in nn 
#vorname wird umbenannt in vn
#Aber Achtung: Dann muss auch direkt mit den neuen Namen angesprochen werden

select 
	person1.vorname vn,
	person1.nachname nn
	from person1;
#Splaten heißen jetzt anders aber nur in der Projektion und nicht in der Basistabelle
#Überprüfung zeigt dies:
select*from person1;

#Duplikate entfernen
select distinct
	person1.vorname vn,
	person1.nachname nn
	from person1;
	
#auch Umbenennungen von den Tabellen möglich in Projektion
#Achtung: Hier muss aber bei Attributauswahl dann der neue Tabellenname berücksichtigt werden und direkt angesprochen werden

select distinct
	pep.vorname vn,
	pep.nachname nn
	from person1 pep;
#In Ergebnistabelle können Spalten auch mehrfach vorkommen
#Beispiel
select
	pep.*,
	pep.vorname,
	pep.nachname
	from person1 pep;
#Vorname und Nachname als Splaten sind doppelt enthalten

#Während Projektion sind auch beliebige arithmetische Operationen möglich

drop table person1;

#Neu anlegen mit Datum in Splalte
create table Person1 (personNr integer primary key,
					vorname text not null,
					nachname text not null,
					 geburtstag Date)
select*from person1
#Daten einfügen
insert into person1 values(1,'Lennart','Hecker',date '1998-07-04');
insert into person1 values(2,'Jan','Nowak', date '1998-06-04');
#Neue Spalte anzeigen lassen
select person1.geburtstag from person1;

#Neue Spalte hinzufügen die gleichzeitig definiert wird
select nachname,
	extract(year from geburtstag) geburtsjahr,
	41+1 test1
from person1;
#Ursprungstabelle bleibt nach wie vor unverändert
select * from person1;

