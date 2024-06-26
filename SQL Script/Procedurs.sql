----Процедура добавления ПОЛЬЗОВАТЕЛЯ 
CREATE OR REPLACE PROCEDURE add_user(
  p_first_name IN users.first_name%TYPE,
  p_last_name IN users.last_name%TYPE,
  p_email IN users.email%TYPE,
  p_password IN users.password%TYPE,
  p_age IN users.age%TYPE,
  p_role IN users.role%TYPE
)
AS
BEGIN
  INSERT INTO users (first_name, last_name, email, password, age, role)
  VALUES (p_first_name, p_last_name, p_email, p_password, p_age, p_role);

  COMMIT;
END;

----Процедура добавление ИМУЩЕСТВА и к нему же АДРЕСА 
CREATE OR REPLACE PROCEDURE add_property(
  p_user_id IN properties.user_id%TYPE,
  p_street_title IN addresses.street_title%TYPE,
  p_street_address IN addresses.street_address%TYPE,
  p_city IN addresses.city%TYPE,
  p_state IN addresses.state%TYPE,
  p_postal_code IN addresses.postal_code%TYPE,
  p_country IN addresses.country%TYPE,
  p_apartment_number IN addresses.apartment_number%TYPE,
  p_title IN properties.title%TYPE,
  p_type IN properties.type%TYPE,
  p_description IN properties.description%TYPE,
  p_rooms IN properties.rooms%TYPE,
  p_is_available IN properties.is_available%TYPE,
  p_price IN properties.price%TYPE
)
AS
  v_address_id addresses.id%TYPE;
BEGIN
  -- Добавить адрес
  INSERT INTO addresses (street_title, street_address, city, state, postal_code, country, apartment_number)
  VALUES (p_street_title, p_street_address, p_city, p_state, p_postal_code, p_country, p_apartment_number)
  RETURNING id INTO v_address_id;

  -- Добавить недвижимость
  INSERT INTO properties (user_id, address_id, title, type, description, rooms, is_available, price)
  VALUES (p_user_id, v_address_id, p_title, p_type, p_description, p_rooms, p_is_available, p_price);

  COMMIT;
END;

----Добавление КАРТЫ 
CREATE OR REPLACE PROCEDURE add_payment (
  p_user_id IN payments.user_id%TYPE,
  p_card_number IN payments.card_number%TYPE,
  p_card_owner IN payments.card_owner%TYPE,
  p_expiration_date IN payments.expiration_date%TYPE,
  p_cvv_code IN payments.cvv_code%TYPE
)
AS
BEGIN
  INSERT INTO payments (user_id, card_number, card_owner, expiration_date, cvv_code)
  VALUES (p_user_id, p_card_number, p_card_owner, p_expiration_date, p_cvv_code);

  COMMIT;
END;

----Создание БРОНИРОВАНИЯ 
CREATE OR REPLACE PROCEDURE add_booking (
  p_user_id IN bookings.user_id%TYPE,
  p_property_id IN bookings.property_id%TYPE,
  p_payment_id IN bookings.payment_id%TYPE,
  p_check_in IN bookings.check_in%TYPE,
  p_check_out IN bookings.check_out%TYPE,
  p_guests IN bookings.guests%TYPE,
  p_total_price IN bookings.total_price%TYPE,
  p_status IN bookings.status%TYPE DEFAULT 'waiting'
)
AS
BEGIN
  -- Добавить бронирование
  INSERT INTO bookings (user_id, property_id, payment_id, check_in, check_out, guests, total_price, status)
  VALUES (p_user_id, p_property_id, p_payment_id, p_check_in, p_check_out, p_guests, p_total_price, p_status);

  COMMIT;
END;

----Добавление УДОБСТВА
CREATE OR REPLACE PROCEDURE add_property_amenity (
  p_property_id IN property_amenities.property_id%TYPE,
  p_amenity_id IN property_amenities.amenity_id%TYPE
)
AS
BEGIN
  INSERT INTO property_amenities (property_id, amenity_id)
  VALUES (p_property_id, p_amenity_id);

  COMMIT;
  
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN
    RAISE_APPLICATION_ERROR(-20004, 'Это удобство уже присвоено данному жилью.');
END;

----Переменная для хранения массивов URL
CREATE OR REPLACE TYPE url_varray AS VARRAY(6) OF VARCHAR2(255);

----Процедура добаления ФОТОГРАФИЙ
CREATE OR REPLACE PROCEDURE add_photos_to_property (
  p_property_id IN photoes.property_id%TYPE,
  p_photo_urls IN url_varray
)
AS
BEGIN
  -- Добавить фотографии
  FOR i IN 1 .. p_photo_urls.COUNT LOOP
    INSERT INTO photoes (property_id, url, "order")
    VALUES (p_property_id, p_photo_urls(i), i);
  END LOOP;

  COMMIT;
END;

----Процедура добавления ОТЗЫВА
CREATE OR REPLACE PROCEDURE add_rating (
  p_user_id IN ratings.user_id%TYPE,
  p_property_id IN ratings.property_id%TYPE,
  p_rating IN ratings.rating%TYPE,
  p_comment IN ratings."comment"%TYPE DEFAULT NULL
)
AS
BEGIN
  INSERT INTO ratings (user_id, property_id, rating, "comment")
  VALUES (p_user_id, p_property_id, p_rating, p_comment);

  COMMIT;
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN
    RAISE_APPLICATION_ERROR(-20005, 'Пользователь уже оставил отзыв к этому жилью.');
END;
BEGIN 
add_rating(1, 1, 5, '');
----ПОДТВЕРЖДЕНИЕ БРОНИРОВАНИЯ
CREATE OR REPLACE PROCEDURE update_booking_status (
    user_id IN NUMBER,
    booking_id IN NUMBER,
    new_status IN VARCHAR2
)
IS
    v_property_user_id NUMBER(20);
BEGIN
    -- Получаем user_id landlord'а, которому принадлежит недвижимость, связанная с бронированием
    SELECT user_id
    INTO v_property_user_id
    FROM properties
    WHERE id = (
        SELECT property_id
        FROM bookings
        WHERE id = booking_id
    );

    -- Проверяем, является ли переданный user_id landlord'ом свойства
    IF v_property_user_id != user_id THEN
        RAISE_APPLICATION_ERROR(-20001, 'You are not authorized to change status for this booking.');
    END IF;

    -- Обновляем статус бронирования
    UPDATE bookings
    SET status = new_status
    WHERE id = booking_id;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Booking status updated successfully.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20002, 'Booking ID not found.');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20003, 'Error updating booking status: ' || SQLERRM);
END update_booking_status;


CREATE OR REPLACE PROCEDURE count_bookings_in_period (
  p_property_id IN bookings.property_id%TYPE,
  p_start_date IN DATE,
  p_end_date IN DATE,
  p_bookings_count OUT NUMBER
)
AS
BEGIN
  SELECT COUNT(*)
  INTO p_bookings_count
  FROM bookings
  WHERE property_id = p_property_id
  AND check_in >= p_start_date
  AND check_out <= p_end_date;
END;

DECLARE
  v_property_id bookings.property_id%TYPE := 1; -- Замените на соответствующий ID объекта
  v_start_date DATE := TO_DATE('2023-01-01', 'YYYY-MM-DD'); -- Замените на нужную дату начала периода
  v_end_date DATE := TO_DATE('2024-12-31', 'YYYY-MM-DD'); -- Замените на нужную дату конца периода
  v_bookings_count NUMBER;
BEGIN
  count_bookings_in_period(
    p_property_id => v_property_id,
    p_start_date => v_start_date,
    p_end_date => v_end_date,
    p_bookings_count => v_bookings_count
  );

  DBMS_OUTPUT.PUT_LINE('Number of bookings: ' || v_bookings_count);
END;
/

BEGIN
    update_booking_status(2, 3, 'approved');
END;


