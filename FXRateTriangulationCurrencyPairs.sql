#Beispielhafte Anwendung von SQL Im Zusammenhang mit FX Paaren
#Hier als Beispiel der Triangulation von Exchange Rates 

#Zunächst wird die Basistabelle angelegt mit Basiswährung, Qutewährung und dem Datum
create table fxrate(dt date not null,
				   baseccy char(3) not null,
				   quoteccy char(3) not null,
				   price float not null,
				   Primary key (dt, baseccy,quoteccy));
#Probehalber anzeigen lassen
select*from fxrate;

#Nun einsetzen von Beispieldaten 
#Dollar Rate von 8 Hauptwährungen

INSERT INTO fxrate (dt,baseccy,quoteccy,price)
VALUES
('2016-08-04', 'AUD', 'USD', 0.762486),
('2016-08-04', 'CAD', 'USD', 0.766930),
('2016-08-04', 'CNY', 'USD', 0.150616),
('2016-08-04', 'EUR', 'USD', 1.113961),
('2016-08-04', 'GBP', 'USD', 1.312852),
('2016-08-04', 'HKD', 'USD', 0.128922),
('2016-08-04', 'JPY', 'USD', 0.00989218),
('2016-08-04', 'USD', 'USD', 1);

#Tabelle anzeigen lassen
select * from fxrate;

#Triangulation in SQL
INSERT INTO fxrate (dt, baseccy, quoteccy, price)
SELECT pair.dt, pair.baseccy, pair.quoteccy, pair.price
FROM
  (
     SELECT f.dt, f.baseccy, t.baseccy quoteccy, (f.price/t.price) price
     FROM fxrate f, fxrate t
     WHERE f.dt = t.dt
     AND f.quoteccy = t.quoteccy
     AND f.quoteccy = 'USD'
  ) pair
LEFT OUTER JOIN fxrate
ON pair.dt = fxrate.dt
AND pair.baseccy = fxrate.baseccy
AND pair.quoteccy = fxrate.quoteccy
WHERE fxrate.baseccy IS NULL;

SELECT f.dt, f.baseccy, t.baseccy quoteccy, (f.price/t.price) price
     FROM fxrate f, fxrate t
     WHERE f.dt = t.dt
     AND f.quoteccy = t.quoteccy
     AND f.quoteccy = 'USD'
	 
	 
select * from fxrate;

