-- Aanvulling op bitbybit database
-- Voer dit script uit NADAT de bestaande dump is geïmporteerd.

START TRANSACTION;

--
-- Extra klanten
--
INSERT INTO `klanten` (`klantnr`, `naam`, `adres`, `postcode`, `plaats`, `telnr`) VALUES
(14, 'Pikachu Ketchum', 'Thunderstraat 25', '1011AA', 'Amsterdam', '0614000001'),
(15, 'Misty Waterflower', 'Kanaalweg 8', '2012BC', 'Haarlem', '0615000002'),
(16, 'Brock Harrison', 'Berglaan 14', '3512CD', 'Utrecht', '0616000003'),
(17, 'Spider-Man Parker', 'Webstraat 9', '3011DE', 'Rotterdam', '0617000004'),
(18, 'Tony Stark', 'Arc Avenue 1', '1071EF', 'Amsterdam', '0618000005'),
(19, 'Steve Rogers', 'Shieldplein 7', '2511GH', 'Den Haag', '0619000006'),
(20, 'Natasha Romanoff', 'Redroomhof 12', '9711JK', 'Groningen', '0620000007'),
(21, 'Miles Morales', 'Brooklynkade 4', '5611LM', 'Eindhoven', '0621000008'),
(22, 'Loki Laufeyson', 'Asgardstraat 3', '3511NP', 'Utrecht', '0622000009'),
(23, 'Goku Son', 'Kameweg 18', '6821QR', 'Arnhem', '0623000010'),
(24, 'Naruto Uzumaki', 'Leafdreef 6', '4811ST', 'Breda', '0624000011'),
(25, 'Sasuke Uchiha', 'Shadowlaan 2', '6521UV', 'Nijmegen', '0625000012'),
(26, 'Gojo Satoru', 'Infinityhof 11', '2311WX', 'Leiden', '0626000013'),
(27, 'Levi Ackerman', 'Wallstraat 5', '7511YZ', 'Enschede', '0627000014'),
(28, 'Wednesday Addams', 'Nevermorelaan 13', '8911ZA', 'Leeuwarden', '0628000015'),
(29, 'Grogu Djarin', 'Galaxyweg 20', '5041AB', 'Tilburg', '0629000016'),
(30, 'Wanda Maximoff', 'Chaosplein 16', '6211CD', 'Maastricht', '0630000017');

--
-- Extra producten
--
INSERT INTO `producten` (`productnr`, `omschrijving`, `prijs`, `voorraad`, `productsoort`) VALUES
(18, 'Gaming Laptop RTX', 1899.00, 8, 'G'),
(19, 'Streaming Microfoon USB', 129.95, 35, 'G'),
(20, 'RGB Gaming Mousepad', 29.95, 75, 'G'),
(21, 'Mechanical Keyboard RGB', 119.95, 42, 'G'),
(22, '4K Webcam Pro', 159.95, 18, 'G'),
(23, 'Marvel Wireless Earbuds', 79.95, 60, 'A'),
(24, 'Pokemon Powerbank 10000mAh', 39.95, 55, 'A'),
(25, 'Gaming Chair X', 249.00, 12, 'G'),
(26, 'Curved Monitor 34 inch', 499.00, 9, 'C'),
(27, 'USB Hub 7-poorts', 34.50, 65, 'B'),
(28, 'Tablet Pro 12 inch', 699.00, 14, 'S'),
(29, 'Smartphone Ultra Max', 999.00, 11, 'S'),
(30, 'Studio Headset Premium', 149.95, 28, 'A');

--
-- Extra verkooporders
--
INSERT INTO `verkooporders` (`ordernr`, `klantnr`, `mednr`, `orderdat`, `weeknr`, `orderbedrag`) VALUES
(7, 14, 2, '2026-04-10', 15, 1918.95),
(8, 15, 1, '2026-04-11', 15, 198.95),
(9, 17, 3, '2026-04-12', 15, 1158.95),
(10, 18, 4, '2026-04-12', 15, 2018.90),
(11, 19, 2, '2026-04-13', 16, 533.50),
(12, 20, 3, '2026-04-14', 16, 1078.90),
(13, 21, 1, '2026-04-14', 16, 159.90),
(14, 22, 4, '2026-04-15', 16, 249.00),
(15, 23, 2, '2026-04-15', 16, 1338.95),
(16, 24, 5, '2026-04-16', 16, 79.95),
(17, 25, 3, '2026-04-16', 16, 768.00),
(18, 26, 6, '2026-04-17', 16, 268.95),
(19, 27, 2, '2026-04-18', 16, 628.95),
(20, 28, 1, '2026-04-18', 16, 1328.89),
(21, 29, 7, '2026-04-19', 16, 34.50),
(22, 30, 4, '2026-04-20', 17, 1148.85);

--
-- Extra orderregels
--
INSERT INTO `orderregels` (`ordernr`, `productnr`, `aantal`) VALUES
(7, 18, 1),
(7, 20, 1),
(8, 19, 1),
(8, 27, 2),
(9, 29, 1),
(9, 23, 2),
(10, 18, 1),
(10, 23, 1),
(10, 24, 1),
(11, 26, 1),
(11, 27, 1),
(12, 29, 1),
(12, 24, 2),
(13, 23, 2),
(14, 25, 1),
(15, 2, 1),
(15, 24, 1),
(16, 23, 1),
(17, 28, 1),
(17, 27, 2),
(18, 25, 1),
(18, 3, 1),
(19, 26, 1),
(19, 19, 1),
(20, 29, 1),
(20, 12, 2),
(20, 30, 2),
(21, 27, 1),
(22, 28, 1),
(22, 30, 3);

--
-- Extra facturen
--
INSERT INTO `facturen` (`factuurnr`, `ordernr`, `factuurdat`, `productsoort`, `bedrag`, `betaald`) VALUES
(6, 7, '2026-04-10', 'G', 1918.95, 1),
(7, 8, '2026-04-11', 'G', 198.95, 1),
(8, 9, '2026-04-12', 'S', 1158.95, 0),
(9, 10, '2026-04-12', 'G', 2018.90, 0),
(10, 11, '2026-04-13', 'C', 533.50, 1),
(11, 12, '2026-04-14', 'S', 1078.90, 0),
(12, 13, '2026-04-14', 'A', 159.90, 0),
(13, 14, '2026-04-15', 'G', 249.00, 1),
(14, 15, '2026-04-15', 'A', 1338.95, 0),
(15, 16, '2026-04-16', 'A', 79.95, 1),
(16, 17, '2026-04-16', 'S', 768.00, 0),
(17, 18, '2026-04-17', 'G', 268.95, 0),
(18, 19, '2026-04-18', 'C', 628.95, 1),
(19, 20, '2026-04-18', 'S', 1328.89, 0),
(20, 21, '2026-04-19', 'B', 34.50, 0),
(21, 22, '2026-04-20', 'S', 1148.85, 0);

--
-- Extra betalingen
--
INSERT INTO `betalingen` (`betalingnr`, `factuurnr`, `betaaldat`, `klantnr`, `bedrag`) VALUES
(4, 6, '2026-04-11', 14, 1918.95),
(5, 7, '2026-04-12', 15, 198.95),
(6, 9, '2026-04-13', 18, 1000.00),
(7, 10, '2026-04-14', 19, 533.50),
(8, 11, '2026-04-15', 20, 500.00),
(9, 13, '2026-04-16', 22, 249.00),
(10, 15, '2026-04-17', 24, 79.95),
(11, 18, '2026-04-19', 27, 628.95),
(12, 19, '2026-04-20', 28, 528.89),
(13, 21, '2026-04-21', 30, 148.85);

--
-- Auto increment waarden verhogen
--
ALTER TABLE `betalingen`
  MODIFY `betalingnr` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

ALTER TABLE `facturen`
  MODIFY `factuurnr` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

ALTER TABLE `klanten`
  MODIFY `klantnr` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

ALTER TABLE `producten`
  MODIFY `productnr` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

ALTER TABLE `verkooporders`
  MODIFY `ordernr` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

COMMIT;
