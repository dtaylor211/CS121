-- [Problem 5]

-- DROP TABLE commands:

DROP TABLE IF EXISTS travel_info;
DROP TABLE IF EXISTS flight, seat, ticket;
DROP TABLE IF EXISTS purchase, customer_phone;
DROP TABLE IF EXISTS traveler, purchaser;
DROP TABLE IF EXISTS aircraft, customer;


-- CREATE TABLE commands:

-- aircraft: table containing information about an individual aircraft
CREATE TABLE aircraft (
    -- IATA aircraft type code (i.e. 737), set length 3 characters
    iata_code CHAR(3),
    -- model of the aircraft (i.e. 747-400), varying length up to 10 
    -- characters
    model VARCHAR(10) NOT NULL,
    -- manufacturer of the aircraft (i.e. Airbus), varying length up to 30
    -- characters
    manufacturer VARCHAR(30) NOT NULL,
    
    PRIMARY KEY (iata_code)
);

-- flight: table containing information about an individual flight
CREATE TABLE flight (
    -- identifying flight number, varying length up to 10 characters
    flight_number VARCHAR(10),
    -- date of the flight, DATE type
    flight_date DATE,
    -- time of the flight, TIME type
    flight_time TIME NOT NULL,
    -- source location airport code (i.e. LAX), set length 3 characters
    source_loc CHAR(3) NOT NULL,
    -- destination location airport code (i.e. LAX), set length 3 characters
    dest_loc CHAR(3) NOT NULL,
    -- type of flight, either 'D' (domestic) or 'I' (international), set
    -- length 1 character
    flight_type CHAR(1) NOT NULL,
    -- IATA aircraft type code (i.e. 737), set length 3 characters
    iata_code CHAR(3) NOT NULL,
    
    PRIMARY KEY (flight_number, flight_date),
    -- foreign key to aircraft.iata_code
    FOREIGN KEY (iata_code)
        REFERENCES aircraft(iata_code)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
        
    CHECK (flight_type IN ('D', 'I'))
);

-- seat: table containing information about an individual seat
CREATE TABLE seat (
    -- IATA aircraft type code (i.e. 737), set length 3 characters
    iata_code CHAR(3),
    -- identifying number of the seat (i.e. 34A), varying length up to
    -- 5 characters
    seat_number VARCHAR(5),
    -- seat class (i.e. 'F' (first), 'B' (business), set length 1 character
    class CHAR(1) NOT NULL,
    -- type of the seat ('W' (window), 'A' (aisle), 'M' (middle)), set
    -- length 1 character
    seat_type CHAR(1) NOT NULL,
    -- marker for whether a seat is in the exit row, 1 for true and 0 
    -- for false, can be NULL - interpeted as false
    exit_row TINYINT,
    
    PRIMARY KEY (iata_code, seat_number),
    -- foreign key to aircraft.iata_code
    FOREIGN KEY (iata_code)
        REFERENCES aircraft(iata_code)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
        
    CHECK (seat_type IN ('W', 'A', 'M')),
    CHECK (class IN ('F', 'B', 'C', 'E')),
    CHECK (exit_row IN (1, 0))
);

-- customer: table containing information about an individual customer
CREATE TABLE customer (
    -- identifying number of the customer, SERIAL type
    cust_id SERIAL,
    -- customer's first name, varying length up to 30 characters
    first_name VARCHAR(30) NOT NULL,
    -- customer's last name, varying length up to 30 characters
    last_name VARCHAR(30) NOT NULL,
    -- customer's email, varying length up to 50 characters
    email VARCHAR(50) NOT NULL,
    
    PRIMARY KEY (cust_id)
);

-- customer_phone: table containing all of a customer's given phone
-- numbers
CREATE TABLE customer_phone (
    -- identifying number of the customer, BIGINT UNSIGNED type
    cust_id BIGINT UNSIGNED,
    -- phone number, BIGINT UNSIGNED type
    phone_number BIGINT UNSIGNED NOT NULL,
    
    PRIMARY KEY (cust_id),
    -- foreign key to customer.cust_id
    FOREIGN KEY (cust_id)
        REFERENCES customer(cust_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- traveler: table containing information about a customer who 
-- participated in traveling
CREATE TABLE traveler (
    -- identifying number of the customer, BIGINT UNSIGNED type
    cust_id BIGINT UNSIGNED,
    -- traveler's frequent flyer number, set length 7 characters, 
    -- can be NULL if ffn is not given 
    frequent_flyer_number CHAR(7),
    -- traveler's passport number, varying length up to 20 characters,
    -- can be NULL if passport information is not given
    passport_number VARCHAR(20),
    -- traveler's passport country, varying length up to 56 characters
    -- (max country name length), can be NULL if passport information is
    -- not given
    passport_country VARCHAR(56),
    -- traveler's emergency contact name (first and last), varying length
    -- up to 100 characters, can be NULL if passport information is not
    -- given
    econtact_name VARCHAR(100),
    -- traveler's emergency contact phone number, BIGINT UNSIGNED type,
    -- can be NULL if passport information is not given
    econtact_phone BIGINT UNSIGNED,
    
    PRIMARY KEY (cust_id),
    -- foreign key to customer.cust_id
    FOREIGN KEY (cust_id)
        REFERENCES customer(cust_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- purchaser: table containing further information about a customer who
-- participated in a purchase
CREATE TABLE purchaser (
    -- identifying number of the customer, BIGINT UNSIGNED type
    cust_id BIGINT UNSIGNED,
    -- purchaser's credit card number, NUMERIC with 16 digits, can be NULL
    -- if purchaser chooses not to store data
    cc_number BIGINT UNSIGNED,
    -- purchaser's credit card expiry date, DATE, can be NULL if purchaser 
    -- chooses not to store data
    exp_date DATE,
    -- purchaser's credit card verification code, INT with 3 digits, 
    -- can be NULL if purchaser chooses not to store data
    verification TINYINT,
    
    PRIMARY KEY (cust_id),
    -- foreign key to customer.cust_id
    FOREIGN KEY (cust_id)
        REFERENCES customer(cust_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- purchase: table containing information about a completed transaction
CREATE TABLE purchase (
    -- identifier for the purchase, SERIAL type
    pur_id SERIAL,
    -- identifying number of the customer, BIGINT UNSIGNED type
    cust_id BIGINT UNSIGNED NOT NULL,
    -- time of the transaction, TIMESTAMP type
    pur_time TIMESTAMP NOT NULL,
    -- confirmation number of purchase (i.e. A1BC23), set length 
    -- 6 characters
    confirmation_number CHAR(6) NOT NULL,
    
    PRIMARY KEY (pur_id),
    -- foreign key to customer.cust_id
    FOREIGN KEY (cust_id)
        REFERENCES purchaser(cust_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- ticket: table containing information about an individual ticket
CREATE TABLE ticket (
    -- identifier for the ticket, SERIAL type
    ticket_id SERIAL,
    -- identifier for the purchase, BIGINT UNSIGNED type
    pur_id BIGINT UNSIGNED NOT NULL,
    -- sale price of the ticket, NUMERIC type
    sale_price NUMERIC (7, 2) NOT NULL,
    
    PRIMARY KEY (ticket_id),
    -- foreign key to customer.cust_id
    FOREIGN KEY (pur_id)
        REFERENCES purchase(pur_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- travel_info: table containing all relevant information a single ticket
CREATE TABLE travel_info (
    -- identifier for the ticket, BIGINT UNSIGNED type
    ticket_id BIGINT UNSIGNED,
    -- identifying number of the traveler, BIGINT UNSIGNED type
    traveler_id BIGINT UNSIGNED NOT NULL,
    -- identifying flight number, varying length up to 10 characters
    flight_number VARCHAR(10) NOT NULL,
    -- date of the flight, DATE type
    flight_date DATE,
    -- IATA aircraft type code (i.e. 737), set length 3 characters
    iata_code CHAR(3) NOT NULL,
    -- identifying number of the seat (i.e. 34A), varying length up to
    -- 5 characters
    seat_number VARCHAR(5) NOT NULL,
    
    PRIMARY KEY (ticket_id),
    -- foreign key to ticket.ticket_id
    FOREIGN KEY (ticket_id)
        REFERENCES ticket(ticket_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    -- foreign key to traveler.cust_id
    FOREIGN KEY (cust_id)
        REFERENCES traveler(cust_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    -- foreign key to flight.flight_number and flight.flight_date
    FOREIGN KEY (flight_number, flight_date)
        REFERENCES flight(flight_number, flight_date)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    -- foreign key to seat.iata_code and seat.seat_number
    FOREIGN KEY (iata_code, seat_number)
        REFERENCES seat(iata_code, seat_number)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);