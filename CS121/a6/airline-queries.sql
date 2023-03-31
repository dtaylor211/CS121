-- [Problem 6a]
-- Get all relevant ticket purchase information from cust 54321
SELECT purchase_date, flight_date, last_name AS traveler_last_name, first_name AS traveler_first_name
FROM (
    SELECT pur_id, pur_time AS purchase_date 
    FROM purchase 
    WHERE cust_id = 54321
) AS purchase_54321 NATURAL LEFT JOIN ticket 
NATURAL LEFT JOIN (
    SELECT ticket_id, cust_id, flight_date
    FROM travel_info
) AS traveler_travel_info NATURAL LEFT JOIN customer
ORDER BY purchase_date DESC, flight_date, traveler_last_name, traveler_first_name;


-- [Problem 6b]
-- Get all types of planes and the revenue they have generated
-- over the past two weeks
SELECT iata_code, IFNULL(temp_revenue, 0) AS revenue
FROM aircraft NATURAL LEFT JOIN (
    SELECT iata_code, SUM(sale_price) AS temp_revenue
    FROM ticket NATURAL LEFT JOIN travel_info
    WHERE TIMESTAMP(flight_date) 
        BETWEEN (NOW() - INTERVAL 2 WEEK) AND NOW()
    GROUP BY iata_code
) AS revenue_info;


-- [Problem 6c]
-- Get all travelers on international flights who haven't
-- turned in their travel documents
SELECT cust_id, last_name, first_name
FROM travel_info NATURAL LEFT JOIN traveler 
NATURAL LEFT JOIN customer NATURAL LEFT JOIN flight
WHERE flight_type = 'I' AND (ISNULL(passport_number))
OR (ISNULL(passport_country))
OR (ISNULL(econtact_name))
OR (ISNULL(econtact_phone))
ORDER BY last_name, first_name, cust_id;



