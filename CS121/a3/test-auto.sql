-- [Problem 2a]
INSERT INTO person
VALUES
    ('1111111111', 'Kate Thompson', '1234 E Nunya Business Rd'),
    ('1111111112', 'Dallas Taylor', '1200 E California Blvd'),
    ('1111111113', 'Kit Fido', '1 W Road St');
    
INSERT INTO car
VALUES
    ('SUB UWU', 'Toyota', 2015),
    ('69420BS', 'Yamborghini', 1930);
    
INSERT INTO car(license, model)
VALUES
    ('JUICYBB', 'carriage'),
    ('BEPBOOP', 'cow');
    
INSERT INTO accident
VALUES
    (1, '2001-07-21 11:11:11', 'your moms house', 
        'black car was rear-ended by blue car');

INSERT INTO accident(date_occurred, location)
VALUES
    ('2002-07-27 11:11:11', 'inside the pasadena Total Wine'),
    ('2000-12-20 04:20:00', 'to the left of Disneyland');
    
INSERT INTO owns
VALUES
    ('1111111111', 'SUB UWU'),
    ('1111111112', '69420BS'),
    ('1111111113', 'JUICYBB');
    
INSERT INTO participated
VALUES
    ('1111111111', 'SUB UWU', 2, 666.00),
    ('1111111112', '69420BS', 1, 0.01);

INSERT INTO participated(driver_id, license, report_number)
VALUES
    ('1111111113', 'JUICYBB', 3);
    
-- [Problem 2b]
UPDATE person
SET driver_id = '9999999999'
WHERE driver_id = '1111111111';

UPDATE car
SET license = 'SOBER<3'
WHERE license = 'JUICYBB';

-- [Problem 2c]
-- DELETE FROM car WHERE license = '69420BS';