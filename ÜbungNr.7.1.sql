#Skript zur Veranstaltung DBMS SS21
#Basisbefehle DDL zum Anlegen, Ändern, Löschen 
#Anlegen und zuweisen der Attribute
create table CD(cdNr integer,
			   cdBezeich text, 
			   cdPreis integer,
			   cdtitel text,
			   cdband text);
#Alles auswählen und F5 drücken
#Löschen 

drop table CD;

#Hinzufügen spezifischer Attribute

create table CD(cdNr integer,
			   cdBezeich char(100), 
			   cdPreis decimal(5,2),
			   cdtitel text,
			   cdband char(100));
			   
#Anzeigen lassen der Relation
select * from CD;

#Eintragen einzelner Tupel in die Relation
insert into CD values(12, 'Hier die Bezeichnung',199.23,'Highway to HEll', 'AC/DC');
insert into CD values(22, 'Hier die Bezeichnung',176.23,'Highway to Route 66', 'AC/DC');
insert into CD values(32, 'Hier die Bezeichnung',138.23,'Highway to Higway', 'AC/DC');

#Anzeigen lassen
select * from CD;

delete from CD where cdNr=12;

#Benutzerdefinierte Wertebereiche anlegen:
create domain fünfstelligeZahl as decimal(5,2);

#Neue Relation mit der angelegten Domäne verwenden
create table verkauftCD(cdNr integer, cdVerkauf fünfstelligeZahl);
select*from verkauftCD;

#Weiteres Beispiel zu Wertebeicheinschränkungen
create domain ShortString as char(5);
create domain SmallInt as integer(5);
#In neuen relation einbiden
create table Mitarbeiter(
plz ShortString,
ort varchar(20),
strasse varchar(20),
hausNr SmallInt);

#Anzeigen lassen
select*from Mitarbeiter;
#Aber Achtung keine UNterverlinkungen  zwischen eigenen Custom Domänen möglich

#Ändern eines Tupels oder einzelner Einträge des Datensatzes

select * from CD;

#Mit uodate und set
update CD set cdnr=01 where cdnr=22;
select * from CD;

#Bedingtes Löschen eines Tupels
delete from CD where cdnr=01;
select * from CD;


#Festlegen von Schlüsseln verschiedener Arten
#Festlegen des Primärschlüssels

#Schlüsselkandidaten über unique
#Primäschlüssel über primary key

create table produkt2(produrktnr fünfstelligeZahl primary key,
					 produktBez char(100) unique);
select*from produkt2;


#Zwei weitere Möglichkeiten für Zuweisung von Primärschlüsseln
#Sollen mehrere Attribute als Primärschlüssel gelten

create table KFZZeichen(
stadt varchar(7),
infix varchar(2),
postfix decimal(5,2),
bezeichnung text,
constraint pk primary key (stadt, infix, postfix));

select*from KFZZeichen;
#Alternative
create table KFZZeichen2(
stadt varchar(7),
infix varchar(2),
postfix decimal(5,2),
bezeichnung text,
primary key (stadt, infix, postfix));
select*from KFZZeichen2;


#Ähnlich mit Fremdschlüsseln
#Diese können am Ende als Constraint angegebn werden oder auch ohne 

create table Liefert(zuliefererNr fünfstelligeZahl,
					teilNr fünfstelligeZahl,
					produktNr fünfstelligeZahl,
					constraint LiefertPS
									primary Key (zuliefererNr, teilNr),
					 constraint LiefertFS1
									foreign key (zuliefererNr) references Zulieferer
									on delete cascade
									on update cascade,
		 
					constraint LiefertFS2
									foreign key (teilNr) references Teil
									on delete cascade
									on update cascade,
					
					 constraint LiefertFS3
									foreign key (produktNr) references Produkt
									on delete cascade set NULL
									on update cascade);
									
									
#Kurzschreibweise
create table Liefert2(
zuliefererNr fünfstelligeZahl,
teilNr fünfstelligeZahl,
produktNr fünfstelligeZahl,
primary key (zuliefererNr, teilNr),
foreign key (zuliefererNr) references Zulieferer 
on delete cascade,
foreign key (teilNr) references Teil
on delete cascade
on update cascade,
foreign key (produktNr) references Produkt
on delete cascade SET NULL
on update cascade);


#Weiteres Beispiel zur Ausweisung von mehreren Fremdschlüsseln
create table produktbez2(
	produktbezNr integer,
	bezeichnung text,
	bezeichnung2 text,
	primary key (produktbezNr));
	
drop table produkt;

create table produkt(
	produktNr integer primary key,
	produktbez integer,
	constraint fk foreign key (produktbez) references produktbez2(produktbezNr)
);

#Anzeigen lassen
select * from produkt;

#Jetz das ganze testen indem ein Tupel in die Relation produktbez eingefügt wird da das Attribut produktbezNr ja als Fremdschlüssel in Verwendung

insert into produktbez2 values(20, 'Hier');

#Anzeigen lassen in Ursprungsrelation
select*from produktbez2;

#Ein Tupel nun in produkt einfügen

insert into produkt values (1,20);
#und gucken ob richtig referenziert wurde:
select *from produkt;

#die nummern hier 20 stimmen in beiden überein das muss auch gelten sonst ist die referentielle Integrität nicht gewährleistet

#Nochmal nun aber mit Unterschieden
insert into produktbez2 values(22, 'Hier');
select*from produktbez2;

#Einfügen eines wertes der nicht 22 entspricht

insert into produkt values (2, 21);
#Es resultiert eine Fehlermeldung!
