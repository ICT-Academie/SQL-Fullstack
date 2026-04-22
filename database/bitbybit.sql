-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Gegenereerd op: 22 apr 2026 om 10:31
-- Serverversie: 10.4.32-MariaDB
-- PHP-versie: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `bitbybit`
--

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `betalingen`
--

CREATE TABLE `betalingen` (
  `betalingnr` int(11) NOT NULL,
  `factuurnr` int(11) NOT NULL,
  `betaaldat` date NOT NULL,
  `klantnr` int(11) NOT NULL,
  `bedrag` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Gegevens worden geëxporteerd voor tabel `betalingen`
--

INSERT INTO `betalingen` (`betalingnr`, `factuurnr`, `betaaldat`, `klantnr`, `bedrag`) VALUES
(1, 2, '2025-02-07', 4, 1424.94),
(2, 4, '2025-03-10', 7, 364.49),
(3, 5, '2025-03-20', 6, 1037.99);

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `facturen`
--

CREATE TABLE `facturen` (
  `factuurnr` int(11) NOT NULL,
  `ordernr` int(11) NOT NULL,
  `factuurdat` date NOT NULL,
  `productsoort` char(1) NOT NULL,
  `bedrag` decimal(10,2) NOT NULL,
  `betaald` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Gegevens worden geëxporteerd voor tabel `facturen`
--

INSERT INTO `facturen` (`factuurnr`, `ordernr`, `factuurdat`, `productsoort`, `bedrag`, `betaald`) VALUES
(1, 1, '2026-02-21', 'A', 638.90, 0),
(2, 2, '2025-02-04', 'G', 1424.94, 1),
(3, 3, '2025-02-12', 'G', 574.93, 0),
(4, 4, '2025-03-06', 'G', 728.98, 0),
(5, 5, '2025-03-19', 'G', 1037.99, 1);

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `klanten`
--

CREATE TABLE `klanten` (
  `klantnr` int(11) NOT NULL,
  `naam` varchar(100) NOT NULL,
  `adres` varchar(100) DEFAULT NULL,
  `postcode` varchar(10) DEFAULT NULL,
  `plaats` varchar(100) DEFAULT NULL,
  `telnr` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Gegevens worden geëxporteerd voor tabel `klanten`
--

INSERT INTO `klanten` (`klantnr`, `naam`, `adres`, `postcode`, `plaats`, `telnr`) VALUES
(1, 'Jan Jansen', 'Dorpsstraat 1', '1234AB', 'Sappemeer', '0612345678'),
(2, 'Fatma Kaya', 'Markt 12', '5678CD', 'Landsmeer', '0687654321'),
(3, 'Piet de Vries', 'Havenweg 5', '1111AA', 'Haarlem', '0600000000'),
(4, 'Y. Topal', 'Zijlweg 10', '2011AB', 'Haarlem', '0612345678'),
(5, 'A. de Vries', 'Kerkstraat 2', '1012WX', 'Amsterdam', '0622334455'),
(6, 'M. Jansen', 'Dorpsweg 19', '1121AA', 'Landsmeer', '0611122233'),
(7, 'S. Bakker', 'Stationsstraat 8', '9611BB', 'Sappemeer', '0655566677'),
(8, 'T. Kaya', 'Hoofdstraat 99', '3511CD', 'Utrecht', '0688877766'),
(9, 'L. van Dijk', 'Parklaan 3', '9711EE', 'Groningen', '0619191919'),
(10, 'N. Özdemir', 'Molenweg 7', '3061FF', 'Rotterdam', '0630303030'),
(11, 'K. Visser', 'Havenstraat 12', '1811GG', 'Alkmaar', '0620202020'),
(12, 'P. Smits', 'Burgemeesterweg 1', '1217HH', 'Hilversum', '0670707070'),
(13, 'E. Meijer', 'Lindelaan 45', '5611JJ', 'Eindhoven', '0640404040');

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `medewerkers`
--

CREATE TABLE `medewerkers` (
  `mednr` int(11) NOT NULL,
  `naam` varchar(100) NOT NULL,
  `adres` varchar(100) DEFAULT NULL,
  `plaats` varchar(100) DEFAULT NULL,
  `afdeling` varchar(50) DEFAULT NULL,
  `functie` varchar(50) DEFAULT NULL,
  `datumin` date DEFAULT NULL,
  `basissalaris` decimal(10,2) DEFAULT NULL,
  `provisiep` decimal(5,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Gegevens worden geëxporteerd voor tabel `medewerkers`
--

INSERT INTO `medewerkers` (`mednr`, `naam`, `adres`, `plaats`, `afdeling`, `functie`, `datumin`, `basissalaris`, `provisiep`) VALUES
(1, 'Sanne Smit', 'Kerklaan 3', 'Haarlem', 'Sales', 'Verkoper', '2022-01-10', 2800.00, 2.50),
(2, 'Ali Demir', 'Parkweg 9', 'Amsterdam', 'Sales', 'Vertegenwoordiger', '2020-06-01', 3200.00, 5.00),
(3, 'S. Verkoop', 'Kantoorweg 1', 'Haarlem', 'Sales', 'vertegenwoordiger', '2019-03-01', 3200.00, 5.00),
(4, 'I. Manager', 'Kantoorweg 2', 'Amsterdam', 'Sales', 'verkoper', '2016-09-15', 4200.00, 2.50),
(5, 'R. Support', 'Helpdesk 3', 'Utrecht', 'Support', 'medewerker', '2021-01-10', 2800.00, 0.00),
(6, 'F. Finance', 'Boekhoud 4', 'Rotterdam', 'Finance', 'medewerker', '2018-06-20', 3500.00, 0.00),
(7, 'D. Developer', 'IT 5', 'Groningen', 'IT', 'developer', '2022-11-01', 3900.00, 0.00);

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `orderregels`
--

CREATE TABLE `orderregels` (
  `ordernr` int(11) NOT NULL,
  `productnr` int(11) NOT NULL,
  `aantal` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Gegevens worden geëxporteerd voor tabel `orderregels`
--

INSERT INTO `orderregels` (`ordernr`, `productnr`, `aantal`) VALUES
(1, 1, 1),
(1, 3, 2),
(2, 6, 1),
(2, 10, 2),
(2, 12, 3),
(3, 8, 2),
(3, 12, 5),
(4, 12, 2),
(4, 14, 1),
(5, 10, 1),
(5, 15, 2),
(6, 1, 1);

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `producten`
--

CREATE TABLE `producten` (
  `productnr` int(11) NOT NULL,
  `omschrijving` varchar(100) NOT NULL,
  `prijs` decimal(10,2) NOT NULL,
  `voorraad` int(11) NOT NULL,
  `productsoort` char(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Gegevens worden geëxporteerd voor tabel `producten`
--

INSERT INTO `producten` (`productnr`, `omschrijving`, `prijs`, `voorraad`, `productsoort`) VALUES
(1, 'Laptop Basic', 599.00, 24, 'A'),
(2, 'Laptop Pro', 1299.00, 10, 'A'),
(3, 'Muis Wireless', 19.95, 100, 'B'),
(4, 'Toetsenbord', 39.95, 50, 'B'),
(5, 'Monitor 27\"', 249.00, 15, 'C'),
(6, 'Laptop Pro 14', 1299.99, 15, 'E'),
(7, 'Laptop Air 13', 999.99, 20, 'E'),
(8, 'Monitor 27 inch', 249.99, 40, 'E'),
(9, 'Toetsenbord Mechanisch', 89.99, 60, 'E'),
(10, 'Muis Draadloos', 39.99, 80, 'E'),
(11, 'Docking Station', 179.99, 25, 'E'),
(12, 'USB-C Kabel', 14.99, 150, 'A'),
(13, 'Headset Office', 69.99, 50, 'E'),
(14, 'Smartphone X1', 699.00, 18, 'S'),
(15, 'Smartphone Z5', 499.00, 22, 'S'),
(16, 'Tablet 10 inch', 329.00, 30, 'S'),
(17, 'Powerbank 20000mAh', 34.95, 90, 'A');

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `verkooporders`
--

CREATE TABLE `verkooporders` (
  `ordernr` int(11) NOT NULL,
  `klantnr` int(11) NOT NULL,
  `mednr` int(11) NOT NULL,
  `orderdat` date NOT NULL,
  `weeknr` int(11) NOT NULL,
  `orderbedrag` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Gegevens worden geëxporteerd voor tabel `verkooporders`
--

INSERT INTO `verkooporders` (`ordernr`, `klantnr`, `mednr`, `orderdat`, `weeknr`, `orderbedrag`) VALUES
(1, 1, 2, '2026-02-20', 8, 638.90),
(2, 4, 3, '2025-02-03', 6, 1424.94),
(3, 5, 4, '2025-02-10', 7, 574.93),
(4, 7, 3, '2025-03-05', 10, 728.98),
(5, 6, 4, '2025-03-18', 12, 1037.99),
(6, 1, 1, '2026-04-08', 15, 599.00);

-- --------------------------------------------------------

--
-- Stand-in structuur voor view `view_klanten_orders_samenvatting`
-- (Zie onder voor de actuele view)
--
CREATE TABLE `view_klanten_orders_samenvatting` (
`klantnr` int(11)
,`naam` varchar(100)
,`plaats` varchar(100)
,`aantal_orders` bigint(21)
,`totaal_besteld` decimal(32,2)
,`laatste_orderdatum` date
);

-- --------------------------------------------------------

--
-- Structuur voor de view `view_klanten_orders_samenvatting`
--
DROP TABLE IF EXISTS `view_klanten_orders_samenvatting`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_klanten_orders_samenvatting`  AS SELECT `k`.`klantnr` AS `klantnr`, `k`.`naam` AS `naam`, `k`.`plaats` AS `plaats`, count(`v`.`ordernr`) AS `aantal_orders`, coalesce(sum(`v`.`orderbedrag`),0) AS `totaal_besteld`, max(`v`.`orderdat`) AS `laatste_orderdatum` FROM (`klanten` `k` left join `verkooporders` `v` on(`v`.`klantnr` = `k`.`klantnr`)) GROUP BY `k`.`klantnr`, `k`.`naam`, `k`.`plaats` ;

--
-- Indexen voor geëxporteerde tabellen
--

--
-- Indexen voor tabel `betalingen`
--
ALTER TABLE `betalingen`
  ADD PRIMARY KEY (`betalingnr`),
  ADD KEY `ix_betalingen_factuurnr` (`factuurnr`),
  ADD KEY `ix_betalingen_klantnr` (`klantnr`);

--
-- Indexen voor tabel `facturen`
--
ALTER TABLE `facturen`
  ADD PRIMARY KEY (`factuurnr`),
  ADD KEY `ix_facturen_ordernr` (`ordernr`);

--
-- Indexen voor tabel `klanten`
--
ALTER TABLE `klanten`
  ADD PRIMARY KEY (`klantnr`);

--
-- Indexen voor tabel `medewerkers`
--
ALTER TABLE `medewerkers`
  ADD PRIMARY KEY (`mednr`);

--
-- Indexen voor tabel `orderregels`
--
ALTER TABLE `orderregels`
  ADD PRIMARY KEY (`ordernr`,`productnr`),
  ADD KEY `ix_orderregels_productnr` (`productnr`);

--
-- Indexen voor tabel `producten`
--
ALTER TABLE `producten`
  ADD PRIMARY KEY (`productnr`);

--
-- Indexen voor tabel `verkooporders`
--
ALTER TABLE `verkooporders`
  ADD PRIMARY KEY (`ordernr`),
  ADD KEY `ix_verkooporders_klantnr` (`klantnr`),
  ADD KEY `ix_verkooporders_mednr` (`mednr`);

--
-- AUTO_INCREMENT voor geëxporteerde tabellen
--

--
-- AUTO_INCREMENT voor een tabel `betalingen`
--
ALTER TABLE `betalingen`
  MODIFY `betalingnr` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT voor een tabel `facturen`
--
ALTER TABLE `facturen`
  MODIFY `factuurnr` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT voor een tabel `klanten`
--
ALTER TABLE `klanten`
  MODIFY `klantnr` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT voor een tabel `medewerkers`
--
ALTER TABLE `medewerkers`
  MODIFY `mednr` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT voor een tabel `producten`
--
ALTER TABLE `producten`
  MODIFY `productnr` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT voor een tabel `verkooporders`
--
ALTER TABLE `verkooporders`
  MODIFY `ordernr` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Beperkingen voor geëxporteerde tabellen
--

--
-- Beperkingen voor tabel `betalingen`
--
ALTER TABLE `betalingen`
  ADD CONSTRAINT `fk_betalingen_facturen` FOREIGN KEY (`factuurnr`) REFERENCES `facturen` (`factuurnr`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_betalingen_klanten` FOREIGN KEY (`klantnr`) REFERENCES `klanten` (`klantnr`) ON UPDATE CASCADE;

--
-- Beperkingen voor tabel `facturen`
--
ALTER TABLE `facturen`
  ADD CONSTRAINT `fk_facturen_verkooporders` FOREIGN KEY (`ordernr`) REFERENCES `verkooporders` (`ordernr`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Beperkingen voor tabel `orderregels`
--
ALTER TABLE `orderregels`
  ADD CONSTRAINT `fk_orderregels_producten` FOREIGN KEY (`productnr`) REFERENCES `producten` (`productnr`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_orderregels_verkooporders` FOREIGN KEY (`ordernr`) REFERENCES `verkooporders` (`ordernr`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Beperkingen voor tabel `verkooporders`
--
ALTER TABLE `verkooporders`
  ADD CONSTRAINT `fk_verkooporders_klanten` FOREIGN KEY (`klantnr`) REFERENCES `klanten` (`klantnr`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_verkooporders_medewerkers` FOREIGN KEY (`mednr`) REFERENCES `medewerkers` (`mednr`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
