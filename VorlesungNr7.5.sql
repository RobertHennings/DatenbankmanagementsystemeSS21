#Modul Datenbankmanagementsysteme für Betriebswirte SS21
#Vorlesung Nr. 7.5 Group By, order by und Untertabellen

#Beispielhaft neue Tabelle anlegen
drop table a;
create table a(
	x integer,
	y text);
	
select * from a;

#Beispielhaft mit Werten befüllen
insert into a values(1, 'Stefan'), (2, 'Stefan'), (3, 'Stefan'), (4, 'Volker'), (5, 'Volker'), (6, 'Stefanie');

#Die Frage: Wie oft kommt ein einzelner Vorname vor?
#Mit Hilfe Group By und Aggregatsfunktion Count

select y as vorname, COUNT(y)
FROM a
Group By vorname;

#Jetzt nur die Vornamen ausgeben die maximal zwei mal vorkommen: <2
#Nicht wie intuitiv mit WHERE sondern aufgrund der Abarbeitungsreihenfolge der Befehle mit HAVING
select y as vorname, COUNT(y)
FROM a
Group By vorname
HAVING COUNT(y) <=2;
#In HAVING wird sich auf gesamte Untertabellen bezogen!

#Unterschied Group By und ORDER By
#Nach x sortieren
select x,y
from a
order by x;

#Nach y sortieren
select x,y
from a
order by y;

#Nur eine Spalte geordnet ausgeben lassen:

select y as vorname
from a
order by y;

#Wenn nur alle einzigartigen ausgegeben werden sollen mit distinct verwenden

select distinct y as vorname
from a
order by y;

#Nochmal den Unterschied von HAVING und WHERE verdeutlichen:

#Funktioniert so nicht, es bedarf der Anpassung mit HAVING
select y, count(*)
from a
WHERE count(*)>2
group by y;
#Anpassung mit HAVING

select y, count(*)
from a
group by y
HAVING count(*)>=2;

#Oder Anpassung auch möglich mit der Zwischenspeicherung der Abfrage und der dann folgenden Auswertung

select * 
from (select y, count(*) c
	 from a 
	 group by y) q
	 WHERE c >=2;
	 
#Liefert selbes Ergebnis

 
