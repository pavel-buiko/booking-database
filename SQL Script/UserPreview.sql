-- Предоставление прав на выполнение пакета и его процедур для роли DefUser
GRANT EXECUTE ON property_search TO DefUser;
GRANT EXECUTE ON property_search.search_by_keyword TO DefUser;
GRANT EXECUTE ON property_search.search_by_type TO DefUser;
GRANT EXECUTE ON property_search.search_by_city TO DefUser;
GRANT EXECUTE ON property_search.search_by_price_range TO DefUser;
GRANT EXECUTE ON property_search.search_by_availability TO DefUser;
GRANT EXECUTE ON view_properties TO DefUser;
GRANT EXECUTE ON view_property_ratings TO DefUser;
GRANT EXECUTE ON add_payment TO DefUser;
GRANT EXECUTE ON add_booking TO DefUser;

CREATE OR REPLACE PROCEDURE view_properties
AS
BEGIN
  FOR rec IN (
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
  ) LOOP
    -- Вывод информации о недвижимости
    DBMS_OUTPUT.PUT_LINE('ID: ' || rec.id);
    DBMS_OUTPUT.PUT_LINE('Title: ' || rec.title);
    DBMS_OUTPUT.PUT_LINE('Type: ' || rec.type);
    DBMS_OUTPUT.PUT_LINE('Description: ' || rec.description);
    DBMS_OUTPUT.PUT_LINE('Rooms: ' || rec.rooms);
    DBMS_OUTPUT.PUT_LINE('Available: ' || rec.is_available);
    DBMS_OUTPUT.PUT_LINE('Price: ' || rec.price);
    DBMS_OUTPUT.PUT_LINE('Address: ' || rec.address);
    DBMS_OUTPUT.PUT_LINE('--------------------------');
  END LOOP;
END view_properties;


BEGIN
  hr.view_properties;
END;



SET SERVEROUTPUT ON





CREATE OR REPLACE PROCEDURE view_property_ratings (
    p_property_id IN ratings.property_id%TYPE
)
AS
BEGIN
  FOR rec IN (
    SELECT
        u.first_name || ' ' || u.last_name AS user_name,
        r.rating,
        r."comment"
    FROM
        ratings r
    JOIN
        users u ON r.user_id = u.id
    WHERE
        r.property_id = p_property_id
  ) LOOP
    -- Вывод информации об отзыве
    DBMS_OUTPUT.PUT_LINE('User: ' || rec.user_name);
    DBMS_OUTPUT.PUT_LINE('Rating: ' || rec.rating);
    DBMS_OUTPUT.PUT_LINE('Comment: ' || rec."comment");
    DBMS_OUTPUT.PUT_LINE('--------------------------');
  END LOOP;
END view_property_ratings;

select * from hr.ratings;
BEGIN
  hr.view_property_ratings(1);
END;



select * from hr.payments;

BEGIN
    hr.add_payment(1, '1234-5678-9012-3456', 'Иван Иванов', TO_DATE('01/25', 'MM/YY'), 123);
END;




select * from hr.bookings;

BEGIN
  hr.add_booking(1, 1, 1, TO_DATE('2024-06-28', 'YYYY-MM-DD'), TO_DATE('2024-06-30', 'YYYY-MM-DD'), 2, 75000);
END;



CREATE OR REPLACE PACKAGE BODY property_search
AS
  PROCEDURE search_by_keyword (
    p_keyword IN VARCHAR2
  )
  AS
    v_results SYS_REFCURSOR;
    v_property_id properties.id%TYPE;
    v_title properties.title%TYPE;
    v_type properties.type%TYPE;
    v_description properties.description%TYPE;
    v_rooms properties.rooms%TYPE;
    v_is_available properties.is_available%TYPE;
    v_price properties.price%TYPE;
    v_street_title addresses.street_title%TYPE;
    v_street_address addresses.street_address%TYPE;
  BEGIN
    OPEN v_results FOR
      SELECT p.id, p.title, p.type, p.description, p.rooms, p.is_available, p.price,
             a.street_title, a.street_address
      FROM properties p
      JOIN addresses a ON p.address_id = a.id
      WHERE p.title LIKE '%' || p_keyword || '%'
         OR p.description LIKE '%' || p_keyword || '%';

    LOOP
      FETCH v_results INTO v_property_id, v_title, v_type, v_description, v_rooms, v_is_available, v_price,
                         v_street_title, v_street_address;
      EXIT WHEN v_results%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE('----------Поиск по ключевому слову-----------');
      DBMS_OUTPUT.PUT_LINE('Название: ' || v_title);
      DBMS_OUTPUT.PUT_LINE('Тип: ' || v_type);
      DBMS_OUTPUT.PUT_LINE('Адрес: ' || v_street_title || ', ' || v_street_address);
      DBMS_OUTPUT.PUT_LINE('Описание: ' || v_description);
      DBMS_OUTPUT.PUT_LINE('Количество комнат: ' || v_rooms);
      DBMS_OUTPUT.PUT_LINE('Доступность: ' || v_is_available);
      DBMS_OUTPUT.PUT_LINE('Цена: ' || v_price);
      DBMS_OUTPUT.PUT_LINE('-------------------------------------');
    END LOOP;

    CLOSE v_results;
  END search_by_keyword;

  PROCEDURE search_by_type (
    p_type IN properties.type%TYPE
  )
  AS
    v_results SYS_REFCURSOR;
    v_property_id properties.id%TYPE;
    v_title properties.title%TYPE;
    v_type properties.type%TYPE;
    v_description properties.description%TYPE;
    v_rooms properties.rooms%TYPE;
    v_is_available properties.is_available%TYPE;
    v_price properties.price%TYPE;
    v_street_title addresses.street_title%TYPE;
    v_street_address addresses.street_address%TYPE;
  BEGIN
    OPEN v_results FOR
      SELECT p.id, p.title, p.type, p.description, p.rooms, p.is_available, p.price,
             a.street_title, a.street_address
      FROM properties p
      JOIN addresses a ON p.address_id = a.id
      WHERE p.type = p_type;

    LOOP
      FETCH v_results INTO v_property_id, v_title, v_type, v_description, v_rooms, v_is_available, v_price,
                         v_street_title, v_street_address;
      EXIT WHEN v_results%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE('-------------Поиск по типу жилья----------------');
      DBMS_OUTPUT.PUT_LINE('Название: ' || v_title);
      DBMS_OUTPUT.PUT_LINE('Тип: ' || v_type);
      DBMS_OUTPUT.PUT_LINE('Адрес: ' || v_street_title || ', ' || v_street_address);
      DBMS_OUTPUT.PUT_LINE('Описание: ' || v_description);
      DBMS_OUTPUT.PUT_LINE('Количество комнат: ' || v_rooms);
      DBMS_OUTPUT.PUT_LINE('Доступность: ' || v_is_available);
      DBMS_OUTPUT.PUT_LINE('Цена: ' || v_price);
      DBMS_OUTPUT.PUT_LINE('-------------------------------------');
    END LOOP;

    CLOSE v_results;
  END search_by_type;

  PROCEDURE search_by_city (
    p_city IN addresses.city%TYPE
  )
  AS
    v_results SYS_REFCURSOR;
    v_property_id properties.id%TYPE;
    v_title properties.title%TYPE;
    v_type properties.type%TYPE;
    v_description properties.description%TYPE;
    v_rooms properties.rooms%TYPE;
    v_is_available properties.is_available%TYPE;
    v_price properties.price%TYPE;
    v_street_title addresses.street_title%TYPE;
    v_street_address addresses.street_address%TYPE;
  BEGIN
    OPEN v_results FOR
      SELECT p.id, p.title, p.type, p.description, p.rooms, p.is_available, p.price,
             a.street_title, a.street_address
      FROM properties p
      JOIN addresses a ON p.address_id = a.id
      WHERE a.city = p_city;

    LOOP
      FETCH v_results INTO v_property_id, v_title, v_type, v_description, v_rooms, v_is_available, v_price,
                         v_street_title, v_street_address;
      EXIT WHEN v_results%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE('------------Поиск по городу---------------');
      DBMS_OUTPUT.PUT_LINE('Название: ' || v_title);
      DBMS_OUTPUT.PUT_LINE('Тип: ' || v_type);
      DBMS_OUTPUT.PUT_LINE('Адрес: ' || v_street_title || ', ' || v_street_address);
      DBMS_OUTPUT.PUT_LINE('Описание: ' || v_description);
      DBMS_OUTPUT.PUT_LINE('Количество комнат: ' || v_rooms);
      DBMS_OUTPUT.PUT_LINE('Доступность: ' || v_is_available);
      DBMS_OUTPUT.PUT_LINE('Цена: ' || v_price);
      DBMS_OUTPUT.PUT_LINE('-------------------------------------');
    END LOOP;

    CLOSE v_results;
  END search_by_city;

  PROCEDURE search_by_price_range (
    p_min_price IN properties.price%TYPE,
    p_max_price IN properties.price%TYPE
  )
  AS
    v_results SYS_REFCURSOR;
    v_property_id properties.id%TYPE;
    v_title properties.title%TYPE;
    v_type properties.type%TYPE;
    v_description properties.description%TYPE;
    v_rooms properties.rooms%TYPE;
    v_is_available properties.is_available%TYPE;
    v_price properties.price%TYPE;
    v_street_title addresses.street_title%TYPE;
    v_street_address addresses.street_address%TYPE;
  BEGIN
    OPEN v_results FOR
      SELECT p.id, p.title, p.type, p.description, p.rooms, p.is_available, p.price,
             a.street_title, a.street_address
      FROM properties p
      JOIN addresses a ON p.address_id = a.id
      WHERE p.price BETWEEN p_min_price AND p_max_price;

    LOOP
      FETCH v_results INTO v_property_id, v_title, v_type, v_description, v_rooms, v_is_available, v_price,
                         v_street_title, v_street_address;
      EXIT WHEN v_results%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE('----------Поиск по ценовому диапазону------------');
      DBMS_OUTPUT.PUT_LINE('Название: ' || v_title);
      DBMS_OUTPUT.PUT_LINE('Тип: ' || v_type);
      DBMS_OUTPUT.PUT_LINE('Адрес: ' || v_street_title || ', ' || v_street_address);
      DBMS_OUTPUT.PUT_LINE('Описание: ' || v_description);
      DBMS_OUTPUT.PUT_LINE('Количество комнат: ' || v_rooms);
      DBMS_OUTPUT.PUT_LINE('Доступность: ' || v_is_available);
      DBMS_OUTPUT.PUT_LINE('Цена: ' || v_price);
      DBMS_OUTPUT.PUT_LINE('-------------------------------------');
    END LOOP;

    CLOSE v_results;
  END search_by_price_range;

  PROCEDURE search_by_availability (
    p_is_available IN properties.is_available%TYPE
  )
  AS
    v_results SYS_REFCURSOR;
    v_property_id properties.id%TYPE;
    v_title properties.title%TYPE;
    v_type properties.type%TYPE;
    v_description properties.description%TYPE;
    v_rooms properties.rooms%TYPE;
    v_is_available properties.is_available%TYPE;
    v_price properties.price%TYPE;
    v_street_title addresses.street_title%TYPE;
    v_street_address addresses.street_address%TYPE;
  BEGIN
    OPEN v_results FOR
      SELECT p.id, p.title, p.type, p.description, p.rooms, p.is_available, p.price,
             a.street_title, a.street_address
      FROM properties p
      JOIN addresses a ON p.address_id = a.id
      WHERE p.is_available = p_is_available;

    LOOP
      FETCH v_results INTO v_property_id, v_title, v_type, v_description, v_rooms, v_is_available, v_price,
                         v_street_title, v_street_address;
      EXIT WHEN v_results%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE('-------------------------------------');
    DBMS_OUTPUT.PUT_LINE('----------Поиск по доступности-------------');
      DBMS_OUTPUT.PUT_LINE('Название: ' || v_title);
      DBMS_OUTPUT.PUT_LINE('Тип: ' || v_type);
      DBMS_OUTPUT.PUT_LINE('Адрес: ' || v_street_title || ', ' || v_street_address);
      DBMS_OUTPUT.PUT_LINE('Описание: ' || v_description);
      DBMS_OUTPUT.PUT_LINE('Количество комнат: ' || v_rooms);
      DBMS_OUTPUT.PUT_LINE('Доступность: ' || v_is_available);
      DBMS_OUTPUT.PUT_LINE('Цена: ' || v_price);
      DBMS_OUTPUT.PUT_LINE('-------------------------------------');
    END LOOP;

    CLOSE v_results;
  END search_by_availability;

END property_search;

SET SERVEROUTPUT ON;

select * from hr.properties;
select * from hr.addresses;
BEGIN
  hr.property_search.search_by_keyword('Уютная');
  hr.property_search.search_by_type('flat');
  hr.property_search.search_by_city('Самара');
  hr.property_search.search_by_price_range(1000, 2000);
  hr.property_search.search_by_availability(1);
END;


