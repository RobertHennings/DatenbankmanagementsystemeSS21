#Modul Datenbankmanagementsysteme für Betriebswirte SS21
#Probeklausur VT 2019

#Aufgabe Nr.1: SQL Teil 
#Replikation der Datenbasis und Überprüfung der Operationen
create table Gender(gID integer primary key,
				   gender text);
				   
create table character(cID integer primary key,
					  name text,
					  gID integer,
					  Foreign key(gID) references gender(gID) on delete cascade);
					  
   
create table Crew(crID integer primary key,
				 name text);
				 
create table CrewMember(mID integer primary key,
					   cID integer, foreign key(cID) references character(cID),
					   crID integer, foreign key(crID) references crew(crID));
					  
#Beispielhaft Daten einfügen
insert into gender values(1,'male'),(2,'female'),(3,'divers');
insert into character values(1,'Robert',1),(2,'Sebastian',1),(3,'Lynn',2),(4,'Göckler',3);
insert into crew values(1,'Student'),(2,'Arbeiter'),(3,'Lehrer');
insert into crewmember values(1,1,1),(2,2,1),(3,3,3);

#a) Anzahl der Geschlechter der Tabelle Gender
select * from gender;
select count(distinct gID) anzahl from gender; 

#Was wenn ein Null Wert drin wäre?
insert into gender values(4,Null);
#Nochmal überprüfen
select count(distinct gID) anzahl from gender; 
#Null wird als eigener Wert mitgezählt daher muss not null mitgegegeben werden

#b) Paarweise Charaktere die den gleichen Namen haben
select * from character;
insert into character values(5,'Sebastian',2);

select a.cID as cID1, b.cID as cID2
from character a natural join character b
where a.name=b.name;

#c) Für jede Crew die IDs und Namen der teilnehmenden Charaktere
#auch für die Crews die keine Teilnehmer haben

select crew.name as crewname,
character.cid,
character.name as cname
from crew natural left outer join crewmember left outer join character on(crewmember.cid=character.cid);


#d) Häufigkeit jedes Geschlechts in character

select giD, count(*) anzahl
from character 
group by (gID) order by(gID);

#e) Crews die keine Charaktere mit der GenderID =2 haben

select crew.crid from 
character natural join crewmember join crew on(crewmember.crid=crew.crid) where gid!=2;

#f) Für jede Crew die anzahl an Teilnehmern

select crID, count(*) anzahl from
crew natural join crewmember
group by (crid);


#g) Für Crews die Frauen und Männer enthalten das Männer-Frauen Verhältnis


#h) Charaktere die maximal in einer Crew sind (ansonsten wird als crid null ausgegeben werden)
#cID,name,crID

select distinct cID, name, crID from
character natural left join crewmember where crid is not null
group by ciD,name,crid
having count(mid)<2;









