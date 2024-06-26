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
  -- ������� ������ � bookings, ��������� � ��������� ������������
  DELETE FROM bookings
  WHERE payment_id IN (SELECT id FROM payments WHERE user_id = p_user_id);

  -- ������� ������ �� ������� payments
  DELETE FROM payments
  WHERE user_id = p_user_id;

  -- ������� ������ �� ������� ratings
  DELETE FROM ratings
  WHERE user_id = p_user_id;

  -- ������� ������ �� ������� properties
  DELETE FROM properties
  WHERE user_id = p_user_id;

  -- ������� ������ �� ������� users
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
  -- ������� ������ �� ������� ratings
  DELETE FROM ratings
  WHERE property_id = p_property_id;

  -- ������� ������ �� ������� property_amenities ��������� � ������� p_property_id
  DELETE FROM property_amenities
  WHERE property_id = p_property_id;

  -- ������� ��� ��������� ������������ (bookings)
  DELETE FROM bookings
  WHERE property_id = p_property_id;

  -- ������� ������ �� ������� photoes
  DELETE FROM photoes
  WHERE property_id = p_property_id;

  -- ������� ������ �� ������� properties
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
  DBMS_OUTPUT.PUT_LINE('���������� ������������: ' || v_bookings_count);
END;

SET SERVEROUTPUT ON;

-- �������� ������������ � ID 5
BEGIN
  delete_user_cascade(4);
END;
SELECT * from users;
ROLLBACK;
-- �������� ����������
SELECT *
FROM users
WHERE id = 4; -- ������ ������������� ������ � ID 5


-- ��������� ������������ � ID 2
BEGIN
  update_user(
    2,
    '����',
    '�������',
    'ann.petrov@example.com',
    35,
    'landlord'
  );
END;
/

-- �������� ����������
SELECT *
FROM users
WHERE id = 2; -- ������ ���� ����������� ��������



-- �������� ������������ � ID 3
BEGIN
  hr.delete_booking(2);
END;
/

-- �������� ����������
SELECT *
FROM properties
WHERE id = 3; -- ������ ������������� ������ � ID 3

-- �������� ������������ � ID 4
BEGIN
  hr.delete_property(10);
END;


-- �������� ����������
SELECT *
FROM hr.properties
WHERE id = 4; -- ������ ������������� ������ � ID 4

-- �������� �������� ��������� ������
SELECT *
FROM property_amenities
WHERE property_id = 4; -- ������ ������������� ������
SELECT *
FROM photoes
WHERE property_id = 4; -- ������ ������������� ������