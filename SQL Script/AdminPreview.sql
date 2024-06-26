GRANT EXECUTE ON delete_user_cascade TO admin;
GRANT EXECUTE ON update_user TO admin;
GRANT EXECUTE ON delete_booking TO admin;
GRANT EXECUTE ON delete_property TO admin;
GRANT EXECUTE ON count_bookings_in_period TO admin;




CREATE OR REPLACE PROCEDURE delete_user_cascade(
  p_user_id IN users.id%TYPE
)
AS
BEGIN
  -- Удалить записи в bookings, связанные с платежами пользователя
  DELETE FROM bookings
  WHERE payment_id IN (SELECT id FROM payments WHERE user_id = p_user_id);

  -- Удалить записи из таблицы payments
  DELETE FROM payments
  WHERE user_id = p_user_id;

  -- Удалить записи из таблицы ratings
  DELETE FROM ratings
  WHERE user_id = p_user_id;

  -- Удалить записи из таблицы properties
  DELETE FROM properties
  WHERE user_id = p_user_id;

  -- Удалить запись из таблицы users
  DELETE FROM users
  WHERE id = p_user_id;

  COMMIT;
END;


CREATE OR REPLACE PROCEDURE update_user(
  p_user_id IN users.id%TYPE,
  p_first_name IN users.first_name%TYPE,
  p_last_name IN users.last_name%TYPE,
  p_email IN users.email%TYPE,
  p_age IN users.age%TYPE,
  p_role IN users.role%TYPE
)
AS
BEGIN
  UPDATE users
  SET first_name = p_first_name,
      last_name = p_last_name,
      email = p_email,
      age = p_age,
      role = p_role
  WHERE id = p_user_id;

  COMMIT;
END;


CREATE OR REPLACE PROCEDURE delete_booking(
  p_booking_id IN bookings.id%TYPE
)
AS
BEGIN
  DELETE FROM bookings
  WHERE id = p_booking_id;

  COMMIT;
END;


CREATE OR REPLACE PROCEDURE delete_property(
  p_property_id IN properties.id%TYPE
)
AS
BEGIN
  -- Удаляем записи из таблицы ratings
  DELETE FROM ratings
  WHERE property_id = p_property_id;

  -- Удаляем записы из таблицы property_amenities связанные с текущим p_property_id
  DELETE FROM property_amenities
  WHERE property_id = p_property_id;

  -- Удаляем все связанные бронирования (bookings)
  DELETE FROM bookings
  WHERE property_id = p_property_id;

  -- Удаляем записи из таблицы photoes
  DELETE FROM photoes
  WHERE property_id = p_property_id;

  -- Удаляем запись из таблицы properties
  DELETE FROM properties
  WHERE id = p_property_id;

  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    RAISE;
END;


select * from hr.properties;
SELECT * FROM hr.bookings;
DECLARE
  v_bookings_count NUMBER;
BEGIN
  hr.count_bookings_in_period(2, TO_DATE('2023-01-01', 'YYYY-MM-DD'), TO_DATE('2025-01-31', 'YYYY-MM-DD'), v_bookings_count);
  DBMS_OUTPUT.PUT_LINE('Количество бронирований: ' || v_bookings_count);
END;

SET SERVEROUTPUT ON;

-- Удаление пользователя с ID 5
BEGIN
  delete_user_cascade(4);
END;
SELECT * from users;
ROLLBACK;
-- Проверка результата
SELECT *
FROM users
WHERE id = 4; -- Должна отсутствовать запись с ID 5


-- Изменение пользователя с ID 2
BEGIN
  update_user(
    2,
    'Анна',
    'Петрова',
    'ann.petrov@example.com',
    35,
    'landlord'
  );
END;
/

-- Проверка результата
SELECT *
FROM users
WHERE id = 2; -- Должны быть обновленные значения



-- Удаление бронирования с ID 3
BEGIN
  hr.delete_booking(2);
END;
/

-- Проверка результата
SELECT *
FROM properties
WHERE id = 3; -- Должна отсутствовать запись с ID 3

-- Удаление недвижимости с ID 4
BEGIN
  hr.delete_property(10);
END;


-- Проверка результата
SELECT *
FROM hr.properties
WHERE id = 4; -- Должна отсутствовать запись с ID 4

-- Проверка удаления связанных данных
SELECT *
FROM property_amenities
WHERE property_id = 4; -- Должны отсутствовать записи
SELECT *
FROM photoes
WHERE property_id = 4; -- Должны отсутствовать записи