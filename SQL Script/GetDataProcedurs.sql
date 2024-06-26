CREATE OR REPLACE PROCEDURE get_user_details (
    p_user_id IN NUMBER,
    p_first_name OUT VARCHAR2,
    p_last_name OUT VARCHAR2,
    p_email OUT VARCHAR2,
    p_password OUT NUMBER,
    p_age OUT NUMBER,
    p_role OUT VARCHAR2
) AS
BEGIN
    SELECT first_name, last_name, email, password, age, role
    INTO p_first_name, p_last_name, p_email, p_password, p_age, p_role
    FROM users
    WHERE id = p_user_id;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_first_name := NULL;
        p_last_name := NULL;
        p_email := NULL;
        p_password := NULL;
        p_age := NULL;
        p_role := NULL;
END get_user_details;

CREATE OR REPLACE PROCEDURE get_payment_details(
    p_payment_id IN NUMBER,
    p_user_id OUT NUMBER,
    p_card_number OUT VARCHAR2,
    p_card_owner OUT VARCHAR2,
    p_expiration_date OUT DATE,
    p_cvv_code OUT NUMBER
) AS
BEGIN
    SELECT user_id, card_number, card_owner, expiration_date, cvv_code
    INTO p_user_id, p_card_number, p_card_owner, p_expiration_date, p_cvv_code
    FROM payments
    WHERE id = p_payment_id;
END;

CREATE OR REPLACE PROCEDURE get_address_details(
  p_address_id IN addresses.id%TYPE,
  p_street_title OUT addresses.street_title%TYPE,
  p_street_address OUT addresses.street_address%TYPE,
  p_city OUT addresses.city%TYPE,
  p_state OUT addresses.state%TYPE,
  p_postal_code OUT addresses.postal_code%TYPE,
  p_country OUT addresses.country%TYPE,
  p_apartment_number OUT addresses.apartment_number%TYPE
)
AS
BEGIN
  SELECT street_title, street_address, city, state, postal_code, country, apartment_number
  INTO p_street_title, p_street_address, p_city, p_state, p_postal_code, p_country, p_apartment_number
  FROM addresses
  WHERE id = p_address_id;
END;
    
create or replace procedure get_property_details(
    p_property_id IN properties.id%TYPE,
    p_address_id out properties.address_id%TYPE,
    p_user_id OUT properties.user_id%TYPE,
    p_title OUT properties.title%TYPE,
    p_type OUT properties.type%TYPE,
    p_description OUT properties.description%TYPE,
    p_rooms OUT properties.rooms%TYPE,
    p_is_available OUT properties.is_available%TYPE,
    p_price OUT properties.price%TYPE
)
AS
BEGIN 
    SELECT user_id, address_id, title, type, description, rooms, is_available, price
    INTO p_user_id,p_address_id,  p_title, p_type, p_description, p_rooms, p_is_available, p_price
    FROM properties
    WHERE id = p_property_id;
END;


CREATE OR REPLACE PROCEDURE get_booking_by_id (
    p_booking_id IN NUMBER,
    p_user_id OUT NUMBER,
    p_property_id OUT NUMBER,
    p_payment_id OUT NUMBER,
    p_check_in OUT DATE,
    p_check_out OUT DATE,
    p_guests OUT NUMBER,
    p_total_price OUT NUMBER,
    p_status OUT VARCHAR2
) AS
BEGIN
    SELECT user_id, property_id, payment_id, check_in, check_out, guests, total_price, status
    INTO p_user_id, p_property_id, p_payment_id, p_check_in, p_check_out, p_guests, p_total_price, p_status
    FROM bookings
    WHERE id = p_booking_id;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_user_id := NULL;
        p_property_id := NULL;
        p_payment_id := NULL;
        p_check_in := NULL;
        p_check_out := NULL;
        p_guests := NULL;
        p_total_price := NULL;
        p_status := NULL;
END get_booking_by_id;


CREATE OR REPLACE PROCEDURE get_bookings_by_user_id (
    p_user_id IN NUMBER,
    p_bookings OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_bookings FOR
    SELECT *
    FROM bookings
    WHERE user_id = p_user_id;
END get_bookings_by_user_id;

SET SERVEROUTPUT ON;


DECLARE
    v_user_id NUMBER := 1;
    v_first_name VARCHAR2(100);
    v_last_name VARCHAR2(100);
    v_email VARCHAR2(100);
    v_password NUMBER;
    v_age NUMBER;
    v_role VARCHAR2(100);
BEGIN
    get_user_details(
        p_user_id => v_user_id,
        p_first_name => v_first_name,
        p_last_name => v_last_name,
        p_email => v_email,
        p_password => v_password,
        p_age => v_age,
        p_role => v_role
    );

    DBMS_OUTPUT.PUT_LINE('First Name: ' || v_first_name);
    DBMS_OUTPUT.PUT_LINE('Last Name: ' || v_last_name);
    DBMS_OUTPUT.PUT_LINE('Email: ' || v_email);
    DBMS_OUTPUT.PUT_LINE('Password: ' || v_password);
    DBMS_OUTPUT.PUT_LINE('Age: ' || v_age);
    DBMS_OUTPUT.PUT_LINE('Role: ' || v_role);
END;


DECLARE
    v_payment_id NUMBER := 1;
    v_user_id NUMBER;
    v_card_number VARCHAR2(100);
    v_card_owner VARCHAR2(100);
    v_expiration_date DATE;
    v_cvv_code NUMBER;
BEGIN
    get_payment_details(
        p_payment_id => v_payment_id,
        p_user_id => v_user_id,
        p_card_number => v_card_number,
        p_card_owner => v_card_owner,
        p_expiration_date => v_expiration_date,
        p_cvv_code => v_cvv_code
    );

    DBMS_OUTPUT.PUT_LINE('User ID: ' || v_user_id);
    DBMS_OUTPUT.PUT_LINE('Card Number: ' || v_card_number);
    DBMS_OUTPUT.PUT_LINE('Card Owner: ' || v_card_owner);
    DBMS_OUTPUT.PUT_LINE('Expiration Date: ' || v_expiration_date);
    DBMS_OUTPUT.PUT_LINE('CVV Code: ' || v_cvv_code);
END;


DECLARE
    v_address_id NUMBER := 1;
    v_street_title VARCHAR2(100);
    v_street_address VARCHAR2(100);
    v_city VARCHAR2(100);
    v_state VARCHAR2(100);
    v_postal_code VARCHAR2(20);
    v_country VARCHAR2(100);
    v_apartment_number VARCHAR2(10);
BEGIN
    get_address_details(
        p_address_id => v_address_id,
        p_street_title => v_street_title,
        p_street_address => v_street_address,
        p_city => v_city,
        p_state => v_state,
        p_postal_code => v_postal_code,
        p_country => v_country,
        p_apartment_number => v_apartment_number
    );

    DBMS_OUTPUT.PUT_LINE('Street Title: ' || v_street_title);
    DBMS_OUTPUT.PUT_LINE('Street Address: ' || v_street_address);
    DBMS_OUTPUT.PUT_LINE('City: ' || v_city);
    DBMS_OUTPUT.PUT_LINE('State: ' || v_state);
    DBMS_OUTPUT.PUT_LINE('Postal Code: ' || v_postal_code);
    DBMS_OUTPUT.PUT_LINE('Country: ' || v_country);
    DBMS_OUTPUT.PUT_LINE('Apartment Number: ' || v_apartment_number);
END;



DECLARE
    v_property_id NUMBER := 1;
    v_user_id NUMBER;
    v_address_id NUMBER;
    v_title VARCHAR2(100);
    v_type VARCHAR2(50);
    v_description VARCHAR2(4000);
    v_rooms NUMBER;
    v_is_available NUMBER;
    v_price NUMBER;
BEGIN
    get_property_details(
        p_property_id => v_property_id,
        p_address_id => v_address_id,
        p_user_id => v_user_id,
        p_title => v_title,
        p_type => v_type,
        p_description => v_description,
        p_rooms => v_rooms,
        p_is_available => v_is_available,
        p_price => v_price
    );

    DBMS_OUTPUT.PUT_LINE('User ID: ' || v_user_id);
    DBMS_OUTPUT.PUT_LINE('Address ID: ' || v_address_id);
    DBMS_OUTPUT.PUT_LINE('Title: ' || v_title);
    DBMS_OUTPUT.PUT_LINE('Type: ' || v_type);
    DBMS_OUTPUT.PUT_LINE('Description: ' || v_description);
    DBMS_OUTPUT.PUT_LINE('Rooms: ' || v_rooms);
    DBMS_OUTPUT.PUT_LINE('Is Available: ' || v_is_available);
    DBMS_OUTPUT.PUT_LINE('Price: ' || v_price);
END;

DECLARE
    v_booking_id NUMBER := 1;
    v_user_id NUMBER;
    v_property_id NUMBER;
    v_payment_id NUMBER;
    v_check_in DATE;
    v_check_out DATE;
    v_guests NUMBER;
    v_total_price NUMBER;
    v_status VARCHAR2(50);
BEGIN
    get_booking_by_id(
        p_booking_id => v_booking_id,
        p_user_id => v_user_id,
        p_property_id => v_property_id,
        p_payment_id => v_payment_id,
        p_check_in => v_check_in,
        p_check_out => v_check_out,
        p_guests => v_guests,
        p_total_price => v_total_price,
        p_status => v_status
    );

    DBMS_OUTPUT.PUT_LINE('User ID: ' || v_user_id);
    DBMS_OUTPUT.PUT_LINE('Property ID: ' || v_property_id);
    DBMS_OUTPUT.PUT_LINE('Payment ID: ' || v_payment_id);
    DBMS_OUTPUT.PUT_LINE('Check-in: ' || v_check_in);
    DBMS_OUTPUT.PUT_LINE('Check-out: ' || v_check_out);
    DBMS_OUTPUT.PUT_LINE('Guests: ' || v_guests);
    DBMS_OUTPUT.PUT_LINE('Total Price: ' || v_total_price);
    DBMS_OUTPUT.PUT_LINE('Status: ' || v_status);
END;


DECLARE
    v_user_id NUMBER := 1;
    v_bookings SYS_REFCURSOR;
    v_user_id_cursor NUMBER;
    v_property_id_cursor NUMBER;
    v_payment_id_cursor NUMBER;
    v_check_in_cursor DATE;
    v_check_out_cursor DATE;
    v_guests_cursor NUMBER;
    v_total_price_cursor NUMBER;
    v_status_cursor VARCHAR2(50);
BEGIN
    get_bookings_by_user_id(
        p_user_id => v_user_id,
        p_bookings => v_bookings
    );

    LOOP
        FETCH v_bookings INTO v_user_id_cursor, v_property_id_cursor, v_payment_id_cursor, v_check_in_cursor, v_check_out_cursor, v_guests_cursor, v_total_price_cursor, v_status_cursor;
        EXIT WHEN v_bookings%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('User ID: ' || v_user_id_cursor);
        DBMS_OUTPUT.PUT_LINE('Property ID: ' || v_property_id_cursor);
        DBMS_OUTPUT.PUT_LINE('Payment ID: ' || v_payment_id_cursor);
        DBMS_OUTPUT.PUT_LINE('Check-in: ' || v_check_in_cursor);
        DBMS_OUTPUT.PUT_LINE('Check-out: ' || v_check_out_cursor);
        DBMS_OUTPUT.PUT_LINE('Guests: ' || v_guests_cursor);
        DBMS_OUTPUT.PUT_LINE('Total Price: ' || v_total_price_cursor);
        DBMS_OUTPUT.PUT_LINE('Status: ' || v_status_cursor);
    END LOOP;
    CLOSE v_bookings;
END;



