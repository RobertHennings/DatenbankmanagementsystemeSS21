#Testweise ein paar Eingaben für den Übungsserver
#Dafür im Übungsserver auf den Reiter 'Testarea' gehen
select characterid, firtsname, lastname, kind
from character natural join kind;

#Kind meint hier die Art der Kreatur, zB Mensch

#Anzeigen lassen wie viele unterschiedliche Kreaturen es gibt bzw. je nach Art wie viele
select kind
from character natural join kind
group by kindid,kind;