USE bitbybit;

-- ============================================================
-- 1) EXTRA KLANTEN (geen duplicaten op naam+plaats)
-- ============================================================
INSERT INTO Klanten (naam, adres, postcode, plaats, telnr)
SELECT * FROM (
    SELECT 'Y. Topal'     AS naam, 'Zijlweg 10'        AS adres, '2011AB' AS postcode, 'Haarlem'     AS plaats, '0612345678' AS telnr
    UNION ALL SELECT 'A. de Vries', 'Kerkstraat 2',       '1012WX', 'Amsterdam',  '0622334455'
    UNION ALL SELECT 'M. Jansen',   'Dorpsweg 19',        '1121AA', 'Landsmeer',  '0611122233'
    UNION ALL SELECT 'S. Bakker',   'Stationsstraat 8',   '9611BB', 'Sappemeer',  '0655566677'
    UNION ALL SELECT 'T. Kaya',     'Hoofdstraat 99',     '3511CD', 'Utrecht',    '0688877766'
    UNION ALL SELECT 'L. van Dijk', 'Parklaan 3',         '9711EE', 'Groningen',  '0619191919'
    UNION ALL SELECT 'N. Özdemir',  'Molenweg 7',         '3061FF', 'Rotterdam',  '0630303030'
    UNION ALL SELECT 'K. Visser',   'Havenstraat 12',     '1811GG', 'Alkmaar',    '0620202020'
    UNION ALL SELECT 'P. Smits',    'Burgemeesterweg 1',  '1217HH', 'Hilversum',  '0670707070'
    UNION ALL SELECT 'E. Meijer',   'Lindelaan 45',       '5611JJ', 'Eindhoven',  '0640404040'
) AS x
WHERE NOT EXISTS (
    SELECT 1 FROM Klanten k
    WHERE k.naam = x.naam AND k.plaats = x.plaats
);

-- ============================================================
-- 2) EXTRA MEDEWERKERS (geen duplicaten op naam)
-- ============================================================
INSERT INTO Medewerkers (naam, adres, plaats, afdeling, functie, datumin, basissalaris, provisiep)
SELECT * FROM (
    SELECT 'S. Verkoop' AS naam, 'Kantoorweg 1' AS adres, 'Haarlem' AS plaats, 'Sales' AS afdeling, 'vertegenwoordiger' AS functie,
           '2019-03-01' AS datumin, 3200.00 AS basissalaris, 5.00 AS provisiep
    UNION ALL
    SELECT 'I. Manager', 'Kantoorweg 2', 'Amsterdam', 'Sales', 'verkoper', '2016-09-15', 4200.00, 2.50
    UNION ALL
    SELECT 'R. Support', 'Helpdesk 3', 'Utrecht', 'Support', 'medewerker', '2021-01-10', 2800.00, 0.00
    UNION ALL
    SELECT 'F. Finance', 'Boekhoud 4', 'Rotterdam', 'Finance', 'medewerker', '2018-06-20', 3500.00, 0.00
    UNION ALL
    SELECT 'D. Developer', 'IT 5', 'Groningen', 'IT', 'developer', '2022-11-01', 3900.00, 0.00
) AS x
WHERE NOT EXISTS (
    SELECT 1 FROM Medewerkers m
    WHERE m.naam = x.naam
);

-- ============================================================
-- 3) EXTRA PRODUCTEN (geen duplicaten op omschrijving)
-- productsoort = 1 letter (pas aan als jouw DB anders is)
-- ============================================================
INSERT INTO Producten (omschrijving, prijs, voorraad, productsoort)
SELECT * FROM (
    SELECT 'Laptop Pro 14'       AS omschrijving, 1299.99 AS prijs, 15 AS voorraad, 'E' AS productsoort
    UNION ALL SELECT 'Laptop Air 13',            999.99,  20, 'E'
    UNION ALL SELECT 'Monitor 27 inch',          249.99,  40, 'E'
    UNION ALL SELECT 'Toetsenbord Mechanisch',    89.99,  60, 'E'
    UNION ALL SELECT 'Muis Draadloos',            39.99,  80, 'E'
    UNION ALL SELECT 'Docking Station',          179.99,  25, 'E'
    UNION ALL SELECT 'USB-C Kabel',               14.99, 150, 'A'
    UNION ALL SELECT 'Headset Office',            69.99,  50, 'E'
    UNION ALL SELECT 'Smartphone X1',            699.00,  18, 'S'
    UNION ALL SELECT 'Smartphone Z5',            499.00,  22, 'S'
    UNION ALL SELECT 'Tablet 10 inch',           329.00,  30, 'S'
    UNION ALL SELECT 'Powerbank 20000mAh',        34.95,  90, 'A'
) AS x
WHERE NOT EXISTS (
    SELECT 1 FROM Producten p
    WHERE p.omschrijving = x.omschrijving
);

-- ============================================================
-- 4) ORDERS + ORDERREGELS (nieuwe orders, geen duplicaten op klant+medewerker+datum)
-- ============================================================

-- Handige variabelen (haal wat bestaande ids op)
SET @k_haarlem = (SELECT klantnr FROM Klanten WHERE naam='Y. Topal' AND plaats='Haarlem' LIMIT 1);
SET @k_amster  = (SELECT klantnr FROM Klanten WHERE naam='A. de Vries' AND plaats='Amsterdam' LIMIT 1);
SET @k_sapp    = (SELECT klantnr FROM Klanten WHERE naam='S. Bakker' AND plaats='Sappemeer' LIMIT 1);
SET @k_land    = (SELECT klantnr FROM Klanten WHERE naam='M. Jansen' AND plaats='Landsmeer' LIMIT 1);

SET @m_sales   = (SELECT mednr FROM Medewerkers WHERE naam='S. Verkoop' LIMIT 1);
SET @m_mgr     = (SELECT mednr FROM Medewerkers WHERE naam='I. Manager' LIMIT 1);

-- Product ids
SET @p_laptop  = (SELECT productnr FROM Producten WHERE omschrijving='Laptop Pro 14' LIMIT 1);
SET @p_monitor = (SELECT productnr FROM Producten WHERE omschrijving='Monitor 27 inch' LIMIT 1);
SET @p_muis    = (SELECT productnr FROM Producten WHERE omschrijving='Muis Draadloos' LIMIT 1);
SET @p_kabel   = (SELECT productnr FROM Producten WHERE omschrijving='USB-C Kabel' LIMIT 1);
SET @p_phone1  = (SELECT productnr FROM Producten WHERE omschrijving='Smartphone X1' LIMIT 1);
SET @p_phone2  = (SELECT productnr FROM Producten WHERE omschrijving='Smartphone Z5' LIMIT 1);

-- Helper: voeg een order toe (als hij nog niet bestaat)
-- Order 1
INSERT INTO Verkooporders (klantnr, mednr, orderdat, weeknr, orderbedrag)
SELECT @k_haarlem, @m_sales, '2025-02-03', WEEK('2025-02-03', 1), 0
WHERE NOT EXISTS (
    SELECT 1 FROM Verkooporders v
    WHERE v.klantnr=@k_haarlem AND v.mednr=@m_sales AND v.orderdat='2025-02-03'
);
SET @o1 = (SELECT ordernr FROM Verkooporders WHERE klantnr=@k_haarlem AND mednr=@m_sales AND orderdat='2025-02-03' ORDER BY ordernr DESC LIMIT 1);

INSERT INTO Orderregels (ordernr, productnr, aantal)
SELECT @o1, @p_laptop, 1 WHERE NOT EXISTS (SELECT 1 FROM Orderregels WHERE ordernr=@o1 AND productnr=@p_laptop);
INSERT INTO Orderregels (ordernr, productnr, aantal)
SELECT @o1, @p_muis, 2 WHERE NOT EXISTS (SELECT 1 FROM Orderregels WHERE ordernr=@o1 AND productnr=@p_muis);
INSERT INTO Orderregels (ordernr, productnr, aantal)
SELECT @o1, @p_kabel, 3 WHERE NOT EXISTS (SELECT 1 FROM Orderregels WHERE ordernr=@o1 AND productnr=@p_kabel);

-- Order 2
INSERT INTO Verkooporders (klantnr, mednr, orderdat, weeknr, orderbedrag)
SELECT @k_amster, @m_mgr, '2025-02-10', WEEK('2025-02-10', 1), 0
WHERE NOT EXISTS (
    SELECT 1 FROM Verkooporders v
    WHERE v.klantnr=@k_amster AND v.mednr=@m_mgr AND v.orderdat='2025-02-10'
);
SET @o2 = (SELECT ordernr FROM Verkooporders WHERE klantnr=@k_amster AND mednr=@m_mgr AND orderdat='2025-02-10' ORDER BY ordernr DESC LIMIT 1);

INSERT INTO Orderregels (ordernr, productnr, aantal)
SELECT @o2, @p_monitor, 2 WHERE NOT EXISTS (SELECT 1 FROM Orderregels WHERE ordernr=@o2 AND productnr=@p_monitor);
INSERT INTO Orderregels (ordernr, productnr, aantal)
SELECT @o2, @p_kabel, 5 WHERE NOT EXISTS (SELECT 1 FROM Orderregels WHERE ordernr=@o2 AND productnr=@p_kabel);

-- Order 3
INSERT INTO Verkooporders (klantnr, mednr, orderdat, weeknr, orderbedrag)
SELECT @k_sapp, @m_sales, '2025-03-05', WEEK('2025-03-05', 1), 0
WHERE NOT EXISTS (
    SELECT 1 FROM Verkooporders v
    WHERE v.klantnr=@k_sapp AND v.mednr=@m_sales AND v.orderdat='2025-03-05'
);
SET @o3 = (SELECT ordernr FROM Verkooporders WHERE klantnr=@k_sapp AND mednr=@m_sales AND orderdat='2025-03-05' ORDER BY ordernr DESC LIMIT 1);

INSERT INTO Orderregels (ordernr, productnr, aantal)
SELECT @o3, @p_phone1, 1 WHERE NOT EXISTS (SELECT 1 FROM Orderregels WHERE ordernr=@o3 AND productnr=@p_phone1);
INSERT INTO Orderregels (ordernr, productnr, aantal)
SELECT @o3, @p_kabel, 2 WHERE NOT EXISTS (SELECT 1 FROM Orderregels WHERE ordernr=@o3 AND productnr=@p_kabel);

-- Order 4
INSERT INTO Verkooporders (klantnr, mednr, orderdat, weeknr, orderbedrag)
SELECT @k_land, @m_mgr, '2025-03-18', WEEK('2025-03-18', 1), 0
WHERE NOT EXISTS (
    SELECT 1 FROM Verkooporders v
    WHERE v.klantnr=@k_land AND v.mednr=@m_mgr AND v.orderdat='2025-03-18'
);
SET @o4 = (SELECT ordernr FROM Verkooporders WHERE klantnr=@k_land AND mednr=@m_mgr AND orderdat='2025-03-18' ORDER BY ordernr DESC LIMIT 1);

INSERT INTO Orderregels (ordernr, productnr, aantal)
SELECT @o4, @p_phone2, 2 WHERE NOT EXISTS (SELECT 1 FROM Orderregels WHERE ordernr=@o4 AND productnr=@p_phone2);
INSERT INTO Orderregels (ordernr, productnr, aantal)
SELECT @o4, @p_muis, 1 WHERE NOT EXISTS (SELECT 1 FROM Orderregels WHERE ordernr=@o4 AND productnr=@p_muis);

-- ============================================================
-- 5) Update orderbedrag op basis van orderregels (bulk)
-- ============================================================
UPDATE Verkooporders v
SET v.orderbedrag = (
    SELECT COALESCE(SUM(p.prijs * r.aantal), 0)
    FROM Orderregels r
    JOIN Producten p ON p.productnr = r.productnr
    WHERE r.ordernr = v.ordernr
)
WHERE v.orderdat IN ('2025-02-03','2025-02-10','2025-03-05','2025-03-18');

-- ============================================================
-- 6) FACTUREN (1 factuur per order) + BETALINGEN (soms betaald)
-- aangenomen: Facturen(betaald = 0/1)
-- ============================================================

-- Factuur voor o1
INSERT INTO Facturen (ordernr, factuurdat, productsoort, bedrag, betaald)
SELECT @o1, '2025-02-04', 'G',
       (SELECT orderbedrag FROM Verkooporders WHERE ordernr=@o1), 1
WHERE NOT EXISTS (SELECT 1 FROM Facturen f WHERE f.ordernr=@o1);

SET @f1 = (SELECT factuurnr FROM Facturen WHERE ordernr=@o1 ORDER BY factuurnr DESC LIMIT 1);
INSERT INTO Betalingen (factuurnr, betaaldat, klantnr, bedrag)
SELECT @f1, '2025-02-07', @k_haarlem,
       (SELECT bedrag FROM Facturen WHERE factuurnr=@f1)
WHERE NOT EXISTS (SELECT 1 FROM Betalingen b WHERE b.factuurnr=@f1);

-- Factuur voor o2 (openstaand)
INSERT INTO Facturen (ordernr, factuurdat, productsoort, bedrag, betaald)
SELECT @o2, '2025-02-12', 'G',
       (SELECT orderbedrag FROM Verkooporders WHERE ordernr=@o2), 0
WHERE NOT EXISTS (SELECT 1 FROM Facturen f WHERE f.ordernr=@o2);

-- Factuur voor o3 (deels betaald? -> we laten hem open)
INSERT INTO Facturen (ordernr, factuurdat, productsoort, bedrag, betaald)
SELECT @o3, '2025-03-06', 'G',
       (SELECT orderbedrag FROM Verkooporders WHERE ordernr=@o3), 0
WHERE NOT EXISTS (SELECT 1 FROM Facturen f WHERE f.ordernr=@o3);

SET @f3 = (SELECT factuurnr FROM Facturen WHERE ordernr=@o3 ORDER BY factuurnr DESC LIMIT 1);
INSERT INTO Betalingen (factuurnr, betaaldat, klantnr, bedrag)
SELECT @f3, '2025-03-10', @k_sapp,
       ROUND((SELECT bedrag FROM Facturen WHERE factuurnr=@f3) * 0.5, 2)
WHERE NOT EXISTS (SELECT 1 FROM Betalingen b WHERE b.factuurnr=@f3);

-- Factuur voor o4 (betaald)
INSERT INTO Facturen (ordernr, factuurdat, productsoort, bedrag, betaald)
SELECT @o4, '2025-03-19', 'G',
       (SELECT orderbedrag FROM Verkooporders WHERE ordernr=@o4), 1
WHERE NOT EXISTS (SELECT 1 FROM Facturen f WHERE f.ordernr=@o4);

SET @f4 = (SELECT factuurnr FROM Facturen WHERE ordernr=@o4 ORDER BY factuurnr DESC LIMIT 1);
INSERT INTO Betalingen (factuurnr, betaaldat, klantnr, bedrag)
SELECT @f4, '2025-03-20', @k_land,
       (SELECT bedrag FROM Facturen WHERE factuurnr=@f4)
WHERE NOT EXISTS (SELECT 1 FROM Betalingen b WHERE b.factuurnr=@f4);

-- ============================================================
-- Klaar
-- ============================================================