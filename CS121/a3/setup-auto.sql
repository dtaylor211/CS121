-- [Problem 1]

DROP TABLE IF EXISTS owns;

DROP TABLE IF EXISTS person;
DROP TABLE IF EXISTS car;
DROP TABLE IF EXISTS accident;

-- person: table containing information about an individual driver
CREATE TABLE person (
    -- person's driver id, set length of 10 characters
    driver_id CHAR(10) NOT NULL,
    -- name of the person, varying length up to 30 characters
    name VARCHAR(30) NOT NULL,
    -- address of the person, varying length up to 300 characters
    address VARCHAR(300) NOT NULL,
    -- the primary key of person is the driver id
    PRIMARY KEY (driver_id)
);

-- car: table containing information about an individual car,
-- the car must be licensed
CREATE TABLE car (
    -- car's license number, set length of 7 characters
    license CHAR(7) NOT NULL,
    -- model of the car (such as Toyota), can be NULL,
    -- varying length up to 15 characters
    model VARCHAR(15),
    -- year of the car, can be NULL, stored as YEAR datatype
    year YEAR,
    -- the primary key of car is the license
    PRIMARY KEY (license)
);

-- accident: table containing information about an accident that has occurred
CREATE TABLE accident (
    -- report number of the accident, auto incrementing int
    report_number INT NOT NULL AUTO_INCREMENT,
    -- the date/time of the accident, stored as TIMESTAMP datatype
    date_occurred TIMESTAMP NOT NULL,
    -- the location of the accident, varying length up to 300 characters
    location VARCHAR(300) NOT NULL,
    -- summary of the accident, can be NULL, varying length up to
    -- 2000 characters
    summary VARCHAR(2000),
    -- the primary key of accident is the report number
    PRIMARY KEY (report_number)
);

-- owns: table containing information about who owns which licensed car
CREATE TABLE owns (
    -- person's driver id, set length of 10 characters
    driver_id CHAR(10) NOT NULL,
    -- car's license number, set length of 7 characters
    license CHAR(7) NOT NULL,
    -- the primary keys of owns are the driver id and license
    PRIMARY KEY (driver_id, license),
    FOREIGN KEY (driver_id) 
        REFERENCES person(driver_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (license)
        REFERENCES car(license)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- participated: table containing information about which driver and 
-- licensed car participated in a recorded accident
CREATE TABLE participated (
    -- person's driver id, set length of 10 characters
    driver_id CHAR(10) NOT NULL,
     -- car's license number, set length of 7 characters
    license CHAR(7) NOT NULL,
    -- report number of the accident, auto incrementing int
    report_number INT NOT NULL AUTO_INCREMENT,
    -- monetary amount of damages, can be NULL, stored as a numeric
    -- value less than $1,000,000
    damage_amount NUMERIC(8,2),
    -- the primary keys of participated are 
    PRIMARY KEY (driver_id, license, report_number),
    FOREIGN KEY (driver_id)
        REFERENCES person(driver_id)
        ON UPDATE CASCADE,
    FOREIGN KEY (license)
        REFERENCES car(license)
        ON UPDATE CASCADE,
    FOREIGN KEY (report_number)
        REFERENCES accident(report_number)
        ON UPDATE CASCADE
);