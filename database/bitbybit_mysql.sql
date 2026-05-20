-- bitbybit_mysql.sql
-- Importeer dit in phpMyAdmin (Database: bitbybit)

CREATE DATABASE IF NOT EXISTS bitbybit
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_general_ci;

USE bitbybit;

-- -----------------------------
-- Tables
-- -----------------------------
DROP VIEW IF EXISTS view_klanten_orders_samenvatting;

DROP TABLE IF EXISTS Betalingen;
DROP TABLE IF EXISTS Facturen;
DROP TABLE IF EXISTS Orderregels;
DROP TABLE IF EXISTS Verkooporders;
DROP TABLE IF EXISTS Medewerkers;
DROP TABLE IF EXISTS Producten;
DROP TABLE IF EXISTS Klanten;

CREATE TABLE Klanten (
  klantnr INT NOT NULL AUTO_INCREMENT,
  naam VARCHAR(100) NOT NULL,
  adres VARCHAR(100) NULL,
  postcode VARCHAR(10) NULL,
  plaats VARCHAR(100) NULL,
  telnr VARCHAR(20) NULL,
  PRIMARY KEY (klantnr)
) ENGINE=InnoDB;

CREATE TABLE Producten (
  productnr INT NOT NULL AUTO_INCREMENT,
  omschrijving VARCHAR(100) NOT NULL,
  prijs DECIMAL(10,2) NOT NULL,
  voorraad INT NOT NULL,
  productsoort CHAR(1) NOT NULL,
  PRIMARY KEY (productnr)
) ENGINE=InnoDB;

CREATE TABLE Medewerkers (
  mednr INT NOT NULL AUTO_INCREMENT,
  naam VARCHAR(100) NOT NULL,
  adres VARCHAR(100) NULL,
  plaats VARCHAR(100) NULL,
  afdeling VARCHAR(50) NULL,
  functie VARCHAR(50) NULL,
  datumin DATE NULL,
  basissalaris DECIMAL(10,2) NULL,
  provisiep DECIMAL(5,2) NULL,
  PRIMARY KEY (mednr)
) ENGINE=InnoDB;

CREATE TABLE Verkooporders (
  ordernr INT NOT NULL AUTO_INCREMENT,
  klantnr INT NOT NULL,
  mednr INT NOT NULL,
  orderdat DATE NOT NULL,
  weeknr INT NOT NULL,
  orderbedrag DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (ordernr),
  KEY ix_verkooporders_klantnr (klantnr),
  KEY ix_verkooporders_mednr (mednr),
  CONSTRAINT fk_verkooporders_klanten
    FOREIGN KEY (klantnr) REFERENCES Klanten(klantnr)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_verkooporders_medewerkers
    FOREIGN KEY (mednr) REFERENCES Medewerkers(mednr)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE Orderregels (
  ordernr INT NOT NULL,
  productnr INT NOT NULL,
  aantal INT NOT NULL,
  PRIMARY KEY (ordernr, productnr),
  KEY ix_orderregels_productnr (productnr),
  CONSTRAINT fk_orderregels_verkooporders
    FOREIGN KEY (ordernr) REFERENCES Verkooporders(ordernr)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_orderregels_producten
    FOREIGN KEY (productnr) REFERENCES Producten(productnr)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE Facturen (
  factuurnr INT NOT NULL AUTO_INCREMENT,
  ordernr INT NOT NULL,
  factuurdat DATE NOT NULL,
  productsoort CHAR(1) NOT NULL,
  bedrag DECIMAL(10,2) NOT NULL,
  betaald TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (factuurnr),
  KEY ix_facturen_ordernr (ordernr),
  CONSTRAINT fk_facturen_verkooporders
    FOREIGN KEY (ordernr) REFERENCES Verkooporders(ordernr)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE Betalingen (
  betalingnr INT NOT NULL AUTO_INCREMENT,
  factuurnr INT NOT NULL,
  betaaldat DATE NOT NULL,
  klantnr INT NOT NULL,
  bedrag DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (betalingnr),
  KEY ix_betalingen_factuurnr (factuurnr),
  KEY ix_betalingen_klantnr (klantnr),
  CONSTRAINT fk_betalingen_facturen
    FOREIGN KEY (factuurnr) REFERENCES Facturen(factuurnr)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_betalingen_klanten
    FOREIGN KEY (klantnr) REFERENCES Klanten(klantnr)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- -----------------------------
-- Seed data (klein maar bruikbaar)
-- -----------------------------
INSERT INTO Klanten (naam, adres, postcode, plaats, telnr) VALUES
('Jan Jansen', 'Dorpsstraat 1', '1234AB', 'Sappemeer', '0612345678'),
('Fatma Kaya', 'Markt 12', '5678CD', 'Landsmeer', '0687654321'),
('Piet de Vries', 'Havenweg 5', '1111AA', 'Haarlem', '0600000000');

INSERT INTO Producten (omschrijving, prijs, voorraad, productsoort) VALUES
('Laptop Basic', 599.00, 25, 'A'),
('Laptop Pro', 1299.00, 10, 'A'),
('Muis Wireless', 19.95, 100, 'B'),
('Toetsenbord', 39.95, 50, 'B'),
('Monitor 27"', 249.00, 15, 'C');

INSERT INTO Medewerkers (naam, adres, plaats, afdeling, functie, datumin, basissalaris, provisiep) VALUES
('Sanne Smit', 'Kerklaan 3', 'Haarlem', 'Sales', 'Verkoper', '2022-01-10', 2800.00, 2.50),
('Ali Demir', 'Parkweg 9', 'Amsterdam', 'Sales', 'Vertegenwoordiger', '2020-06-01', 3200.00, 5.00);

-- 1 order + regels + factuur + (nog) geen betaling
INSERT INTO Verkooporders (klantnr, mednr, orderdat, weeknr, orderbedrag) VALUES
(1, 2, '2026-02-20', 8, 0.00);

SET @ordernr := LAST_INSERT_ID();

INSERT INTO Orderregels (ordernr, productnr, aantal) VALUES
(@ordernr, 1, 1),
(@ordernr, 3, 2);

-- orderbedrag berekenen (simpel)
UPDATE Verkooporders v
JOIN (
  SELECT r.ordernr, SUM(p.prijs * r.aantal) AS totaal
  FROM Orderregels r
  JOIN Producten p ON p.productnr = r.productnr
  GROUP BY r.ordernr
) x ON x.ordernr = v.ordernr
SET v.orderbedrag = x.totaal;

INSERT INTO Facturen (ordernr, factuurdat, productsoort, bedrag, betaald) VALUES
(@ordernr, '2026-02-21', 'A', (SELECT orderbedrag FROM Verkooporders WHERE ordernr=@ordernr), 0);

-- -----------------------------
-- View: rapport klanten + orders
-- -----------------------------
CREATE VIEW view_klanten_orders_samenvatting AS
SELECT
  k.klantnr,
  k.naam,
  k.plaats,
  COUNT(v.ordernr) AS aantal_orders,
  COALESCE(SUM(v.orderbedrag), 0) AS totaal_besteld,
  MAX(v.orderdat) AS laatste_orderdatum
FROM Klanten k
LEFT JOIN Verkooporders v ON v.klantnr = k.klantnr
GROUP BY k.klantnr, k.naam, k.plaats;
