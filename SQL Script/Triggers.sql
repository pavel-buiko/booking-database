CREATE OR REPLACE TRIGGER users_trigger
AFTER INSERT OR UPDATE OR DELETE ON users
FOR EACH ROW
BEGIN
  IF INSERTING THEN
    DBMS_OUTPUT.PUT_LINE('New user inserted with ID: ' || :NEW.id);
  ELSIF UPDATING THEN
    DBMS_OUTPUT.PUT_LINE('User with ID: ' || :OLD.id || ' updated');
  ELSIF DELETING THEN
    DBMS_OUTPUT.PUT_LINE('User with ID: ' || :OLD.id || ' deleted');
  END IF;
END;

CREATE OR REPLACE TRIGGER bookings_trigger
AFTER INSERT OR UPDATE OR DELETE ON bookings
FOR EACH ROW
BEGIN
  IF INSERTING THEN
    DBMS_OUTPUT.PUT_LINE('New booking inserted with ID: ' || :NEW.id);
  ELSIF UPDATING THEN
    DBMS_OUTPUT.PUT_LINE('Booking with ID: ' || :OLD.id || ' updated');
  ELSIF DELETING THEN
    DBMS_OUTPUT.PUT_LINE('Booking with ID: ' || :OLD.id || ' deleted');
  END IF;
END;

CREATE OR REPLACE TRIGGER properties_trigger
AFTER INSERT OR UPDATE OR DELETE ON properties
FOR EACH ROW
BEGIN
  IF INSERTING THEN
    DBMS_OUTPUT.PUT_LINE('New property inserted with ID: ' || :NEW.id);
  ELSIF UPDATING THEN
    DBMS_OUTPUT.PUT_LINE('Property with ID: ' || :OLD.id || ' updated');
  ELSIF DELETING THEN
    DBMS_OUTPUT.PUT_LINE('Property with ID: ' || :OLD.id || ' deleted');
  END IF;
END;

CREATE OR REPLACE TRIGGER check_user_unique
BEFORE INSERT ON users
FOR EACH ROW
DECLARE
  user_exists NUMBER;
BEGIN
  SELECT COUNT(*) INTO user_exists
  FROM users
  WHERE email = :NEW.email;

  IF user_exists > 0 THEN
    RAISE_APPLICATION_ERROR(-20001, '������������ � ����� email ��� ����������.');
  END IF;
END;

CREATE OR REPLACE TRIGGER check_landlord_property
BEFORE INSERT OR UPDATE ON properties
FOR EACH ROW
DECLARE
  user_role users.role%TYPE;
BEGIN
  -- �������� ���� ������������
  SELECT role INTO user_role
  FROM users
  WHERE id = :NEW.user_id;

  -- ���������, �������� �� ������������ landlord ��� admin
  IF user_role != 'landlord' AND user_role != 'admin' THEN
    RAISE_APPLICATION_ERROR(-20002, '������ ������������ � ����� "landlord" ����� ����� �����.');
  END IF;
END;


CREATE OR REPLACE TRIGGER check_past_booking_dates
BEFORE INSERT ON bookings
FOR EACH ROW
BEGIN
  IF :NEW.check_in < SYSDATE OR :NEW.check_out < SYSDATE THEN
    RAISE_APPLICATION_ERROR(-20006, '������ ������� ������������ �� ��������� ����.');
  END IF;
END;

CREATE OR REPLACE TRIGGER check_overlapping_bookings
BEFORE INSERT ON bookings
FOR EACH ROW
DECLARE
  overlapping_bookings_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO overlapping_bookings_count
  FROM bookings
  WHERE property_id = :NEW.property_id
  AND (
    (:NEW.check_in BETWEEN check_in AND check_out)
    OR (:NEW.check_out BETWEEN check_in AND check_out)
    OR (check_in BETWEEN :NEW.check_in AND :NEW.check_out)
  );

  IF overlapping_bookings_count > 0 THEN
    RAISE_APPLICATION_ERROR(-20007, '��������� ���� ������������ � ������������ �������������.');
  END IF;
END;


CREATE OR REPLACE TRIGGER check_guests
BEFORE INSERT OR UPDATE ON bookings
FOR EACH ROW
BEGIN
  IF :NEW.guests <= 0 THEN
    RAISE_APPLICATION_ERROR(-20003, '���������� ������ ������ ���� ������ ����.');
  END IF;
END;

DROP TRIGGER trg_check_landlord_status;

CREATE OR REPLACE TRIGGER trg_check_landlord_status
BEFORE UPDATE OF status ON bookings
FOR EACH ROW
DECLARE
    v_property_user_id NUMBER(20);
BEGIN
    -- �������� user_id landlord'�, �������� ����������� ������������, ��������� � ���� �������������
    SELECT user_id
    INTO v_property_user_id
    FROM properties
    WHERE id = (
        SELECT property_id
        FROM bookings
        WHERE id = :OLD.id
    );

    -- ���������, �������� �� ������� ������������ landlord'�� ��������
    IF v_property_user_id != :NEW.user_id THEN
        RAISE_APPLICATION_ERROR(-20001, 'You are not authorized to change status for this booking.');
    END IF;
END;

