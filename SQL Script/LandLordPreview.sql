-- Предоставление прав на выполнение процедур добавления недвижимости и фотографий
GRANT EXECUTE ON add_property TO landlord;
GRANT EXECUTE ON add_photos_to_property TO landlord;
GRANT EXECUTE ON add_property_amenity TO landlord;

-- Предоставление прав на выполнение процедуры обновления статуса бронирования
GRANT EXECUTE ON update_booking_status TO landlord;

-- Предоставление прав на выполнение процедуры просмотра недвижимостей владельца
GRANT EXECUTE ON view_landlord_properties TO landlord;

select * from hr.users;
SELECT * FROM hr.properties;
SELECT * FROM hr.ADDRESSES;
BEGIN
  -- Вставка данных с помощью процедуры add_property
  hr.add_property(5, 'Центральная', '20', 'New-York', 'Самарская область', '654321', 'Россия', 45, 'Уютная квартира рядом с парком', 'flat', 'Описание 6', 3, 1, 17000);
  END;

  hr.add_property(2, 'Лесная', '7', 'Владивосток', 'Приморский край', '246801', 'Россия', 23, 'Дом на берегу озера', 'house', 'Описание 7', 4, 1, 45000);

DECLARE
  photos1 url_varray := url_varray('https://example.com/photo1_1.jpg', 'https://example.com/photo1_2.jpg');
  photos2 url_varray := url_varray('https://example.com/photo2_1.jpg', 'https://example.com/photo2_2.jpg', 'https://example.com/photo2_3.jpg');
  photos3 url_varray := url_varray('https://example.com/photo3_1.jpg');
  photos4 url_varray := url_varray('https://example.com/photo4_1.jpg', 'https://example.com/photo4_2.jpg');
  photos5 url_varray := url_varray('https://example.com/photo5_1.jpg', 'https://example.com/photo5_2.jpg', 'https://example.com/photo5_3.jpg', 'https://example.com/photo5_4.jpg');
BEGIN
  hr.add_photos_to_property(1, photos1);
  hr.add_photos_to_property(2, photos2);
  hr.add_photos_to_property(3, photos3);
  hr.add_photos_to_property(4, photos4);
  hr.add_photos_to_property(5, photos5);
END;


BEGIN
  hr.add_property_amenity(1, 1); -- Wi-Fi
END;

CREATE OR REPLACE PROCEDURE toggle_trigger(
    p_trigger_name IN VARCHAR2,
    p_enable IN BOOLEAN
)
IS
BEGIN
    IF p_enable THEN
        EXECUTE IMMEDIATE 'ALTER TRIGGER ' || p_trigger_name || ' ENABLE';
    ELSE
        EXECUTE IMMEDIATE 'ALTER TRIGGER ' || p_trigger_name || ' DISABLE';
    END IF;
END toggle_trigger;

SELECT * FROM USERS;
CREATE OR REPLACE PROCEDURE update_booking_status (
    user_id IN NUMBER,
    booking_id IN NUMBER,
    new_status IN VARCHAR2
)
IS
    v_property_user_id NUMBER(20);
BEGIN
    hr.toggle_trigger('HR.TRG_CHECK_LANDLORD_STATUS', FALSE);
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
select * from hr.bookings;
SELECT * from hr.properties;
SELECT * FROM hr.USERS
BEGIN
    hr.update_booking_status(2, 28, 'approwed'); 
END;


CREATE OR REPLACE PROCEDURE view_landlord_properties (
    p_user_id IN users.id%TYPE,
    p_properties_cursor OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN p_properties_cursor FOR
    SELECT 
        p.id, 
        p.title, 
        p.type, 
        p.description, 
        p.rooms, 
        p.is_available, 
        p.price,
        a.street_title || ', ' || a.street_address || ', ' || a.city || ', ' || a.state || ', ' || a.country AS address
    FROM 
        properties p
    JOIN 
        addresses a ON p.address_id = a.id
    WHERE 
        p.user_id = p_user_id;
END view_landlord_properties;

SELECT *
FROM users u
INNER JOIN properties p ON u.id = p.user_id;

DECLARE
  v_properties_cursor SYS_REFCURSOR;
  v_property_id NUMBER;
  v_property_title VARCHAR2(250);
  v_property_type VARCHAR2(50);
  v_property_description VARCHAR2(4000);
  v_property_rooms NUMBER;
  v_property_is_available NUMBER;
  v_property_price NUMBER(10,2);
  v_property_address VARCHAR2(1000);
BEGIN
  -- Вызов процедуры для получения курсора с данными о недвижимости
  hr.view_landlord_properties(2, v_properties_cursor); 

  -- Перебор результатов курсора
  LOOP
    FETCH v_properties_cursor INTO 
      v_property_id, v_property_title, v_property_type, v_property_description, 
      v_property_rooms, v_property_is_available, v_property_price, v_property_address;

    EXIT WHEN v_properties_cursor%NOTFOUND;

    -- Вывод информации о недвижимости
    DBMS_OUTPUT.PUT_LINE('ID: ' || v_property_id);
    DBMS_OUTPUT.PUT_LINE('Title: ' || v_property_title);
    DBMS_OUTPUT.PUT_LINE('Type: ' || v_property_type);
    DBMS_OUTPUT.PUT_LINE('Description: ' || v_property_description);
    DBMS_OUTPUT.PUT_LINE('Rooms: ' || v_property_rooms);
    DBMS_OUTPUT.PUT_LINE('Available: ' || v_property_is_available);
    DBMS_OUTPUT.PUT_LINE('Price: ' || v_property_price);
    DBMS_OUTPUT.PUT_LINE('Address: ' || v_property_address);
    DBMS_OUTPUT.PUT_LINE('--------------------------');
  END LOOP;

  -- Закрытие курсора
  CLOSE v_properties_cursor;
END;


SET SERVEROUTPUT ON;



