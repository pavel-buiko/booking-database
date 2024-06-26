SET SERVEROUTPUT ON;



CREATE OR REPLACE PROCEDURE export_users_to_json AS
    v_json CLOB;
    v_chunk_size CONSTANT INTEGER := 4096;
    v_start_pos INTEGER := 1;
    v_end_pos INTEGER;
    v_chunk VARCHAR2(4096);
    file_handle UTL_FILE.FILE_TYPE;
BEGIN
    -- �������� JSON �� ������ ������� users
    SELECT JSON_ARRAYAGG(
                JSON_OBJECT(
                    'id' VALUE id,
                    'first_name' VALUE first_name,
                    'last_name' VALUE last_name,
                    'email' VALUE email,
                    'password' VALUE password,  -- � �������� ����������� ������ ������ ��������� ��������������
                    'age' VALUE age,
                    'role' VALUE role
                )
           ) INTO v_json
    FROM users;
    
    -- ����� JSON � ������� (��� ��������)
    DBMS_OUTPUT.PUT_LINE(v_json);

    -- ������ JSON � ����
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Opening file for appending...');
        file_handle := UTL_FILE.FOPEN('JSON_OUTPUT', 'users.json', 'w', 4096);
        DBMS_OUTPUT.PUT_LINE('File opened successfully.');
        
        -- ���� ������ JSON �� ������
        LOOP
            v_end_pos := v_start_pos + v_chunk_size - 1;
            -- ��������, ��� �� �������� ����� JSON
            IF v_end_pos > LENGTH(v_json) THEN
                v_end_pos := LENGTH(v_json);
            END IF;
            -- ���������� ����� JSON
            v_chunk := SUBSTR(v_json, v_start_pos, v_end_pos - v_start_pos + 1);
            -- ������ ����� JSON � ����
            UTL_FILE.PUT_LINE(file_handle, v_chunk);
            -- ������� � ��������� �����
            v_start_pos := v_end_pos + 1;
            -- ����� �� �����, ���� ��������� ����� JSON
            EXIT WHEN v_start_pos > LENGTH(v_json);
        END LOOP;

        DBMS_OUTPUT.PUT_LINE('JSON written to file.');
        UTL_FILE.FCLOSE(file_handle);
        DBMS_OUTPUT.PUT_LINE('File closed successfully.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('������ ������ �����: ' || SQLERRM);
    END;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('������: ' || SQLERRM);
END export_users_to_json;

CREATE OR REPLACE PROCEDURE export_payments_to_json AS
    v_json CLOB;
    v_chunk_size CONSTANT INTEGER := 4096;
    v_start_pos INTEGER := 1;
    v_end_pos INTEGER;
    v_chunk VARCHAR2(4096);
    file_handle UTL_FILE.FILE_TYPE;
BEGIN
    -- �������� JSON �� ������ ������� payments
    SELECT JSON_ARRAYAGG(
                JSON_OBJECT(
                    'id' VALUE id,
                    'user_id' VALUE user_id,
                    'card_number' VALUE card_number,
                    'card_owner' VALUE card_owner,
                    'expiration_date' VALUE TO_CHAR(expiration_date, 'YYYY-MM-DD'),
                    'cvv_code' VALUE cvv_code
                )
           ) INTO v_json
    FROM payments;
    
    -- ����� JSON � ������� (��� ��������)
    DBMS_OUTPUT.PUT_LINE('Generated JSON: ' || v_json);

    -- ������ JSON � ����
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Opening file for appending...');
        file_handle := UTL_FILE.FOPEN('JSON_OUTPUT', 'payments.json', 'w', 4096);
        DBMS_OUTPUT.PUT_LINE('File opened successfully.');
        
        -- ���� ������ JSON �� ������
        LOOP
            v_end_pos := v_start_pos + v_chunk_size - 1;
            -- ��������, ��� �� �������� ����� JSON
            IF v_end_pos > LENGTH(v_json) THEN
                v_end_pos := LENGTH(v_json);
            END IF;
            -- ���������� ����� JSON
            v_chunk := SUBSTR(v_json, v_start_pos, v_end_pos - v_start_pos + 1);
            -- ������ ����� JSON � ����
            UTL_FILE.PUT_LINE(file_handle, v_chunk);
            -- ������� � ��������� �����
            v_start_pos := v_end_pos + 1;
            -- ����� �� �����, ���� ��������� ����� JSON
            EXIT WHEN v_start_pos > LENGTH(v_json);
        END LOOP;

        DBMS_OUTPUT.PUT_LINE('JSON written to file.');
        UTL_FILE.FCLOSE(file_handle);
        DBMS_OUTPUT.PUT_LINE('File closed successfully.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('������ ������ �����: ' || SQLERRM);
    END;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('������: ' || SQLERRM);
END export_payments_to_json;

CREATE OR REPLACE PROCEDURE export_addresses_to_json AS
    v_json CLOB;
    file_handle UTL_FILE.FILE_TYPE;
BEGIN
    -- �������� JSON �� ������ ������� payments
    SELECT JSON_ARRAYAGG(
                JSON_OBJECT(
                    'id' VALUE id,
                    'street_title' VALUE street_title,
                    'street_address' VALUE street_address,
                    'city' VALUE city,
                    'state' VALUE state,
                    'postal_code' VALUE postal_code,
                    'country' VALUE country,
                    'apartment_number' VALUE apartment_number
                )
           ) INTO v_json
    FROM addresses;
    
    -- ����� JSON � ������� (��� ��������)
    DBMS_OUTPUT.PUT_LINE('Generated JSON: ' || v_json);

    -- ������ JSON � ����
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Opening file for appending...');
        file_handle := UTL_FILE.FOPEN('JSON_OUTPUT', 'addresses.json', 'w', 4096);
        DBMS_OUTPUT.PUT_LINE('File opened successfully.');
        
        UTL_FILE.PUT_RAW(file_handle, UTL_RAW.CAST_TO_RAW(v_json)); 
        DBMS_OUTPUT.PUT_LINE('JSON written to file.');
        UTL_FILE.FCLOSE(file_handle);
        DBMS_OUTPUT.PUT_LINE('File closed successfully.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('������ ������ �����: ' || SQLERRM);
    END;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('������: ' || SQLERRM);
END export_addresses_to_json;

CREATE OR REPLACE PROCEDURE export_properties_amenities_to_json AS
    v_json CLOB;
    v_chunk_size CONSTANT INTEGER := 4096;
    v_start_pos INTEGER := 1;
    v_end_pos INTEGER;
    v_chunk VARCHAR2(4096);
    file_handle UTL_FILE.FILE_TYPE;
BEGIN
    -- �������� JSON �� ������ ������� properties
    SELECT JSON_ARRAYAGG(
                JSON_OBJECT(
                    'id' VALUE p.id,
                    'user_id' VALUE p.user_id,
                    'address_id' VALUE p.address_id,
                    'title' VALUE p.title,
                    'type' VALUE p.type,
                    'description' VALUE p.description,
                    'rooms' VALUE p.rooms,
                    'is_available' VALUE p.is_available,
                    'price' VALUE p.price,
                    'amenities' VALUE JSON_ARRAYAGG(a.name)
                )
           ) INTO v_json
    FROM properties p
    LEFT JOIN property_amenities pa ON p.id = pa.property_id
    LEFT JOIN amenities a ON pa.amenity_id = a.id
    GROUP BY p.id, p.user_id, p.address_id, p.title, p.type, p.description, p.rooms, p.is_available, p.price;
    
    -- ����� JSON � ������� (��� ��������)
    DBMS_OUTPUT.PUT_LINE('Generated JSON: ' || v_json);

    -- ������ JSON � ����
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Opening file for appending...');
        file_handle := UTL_FILE.FOPEN('JSON_OUTPUT', 'properties_amenities.json', 'w', 4096);
        DBMS_OUTPUT.PUT_LINE('File opened successfully.');
        
        -- ���� ������ JSON �� ������
        LOOP
            v_end_pos := v_start_pos + v_chunk_size - 1;
            -- ��������, ��� �� �������� ����� JSON
            IF v_end_pos > LENGTH(v_json) THEN
                v_end_pos := LENGTH(v_json);
            END IF;
            -- ���������� ����� JSON
            v_chunk := SUBSTR(v_json, v_start_pos, v_end_pos - v_start_pos + 1);
            -- ������ ����� JSON � ����
            UTL_FILE.PUT_LINE(file_handle, v_chunk);
            -- ������� � ��������� �����
            v_start_pos := v_end_pos + 1;
            -- ����� �� �����, ���� ��������� ����� JSON
            EXIT WHEN v_start_pos > LENGTH(v_json);
        END LOOP;

        DBMS_OUTPUT.PUT_LINE('JSON written to file.');
        UTL_FILE.FCLOSE(file_handle);
        DBMS_OUTPUT.PUT_LINE('File closed successfully.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('������ ������ �����: ' || SQLERRM);
    END;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('������: ' || SQLERRM);
END export_properties_amenities_to_json;

CREATE OR REPLACE PROCEDURE export_bookings_to_json AS
    v_json CLOB;
    v_chunk_size CONSTANT INTEGER := 4096;
    v_start_pos INTEGER := 1;
    v_end_pos INTEGER;
    v_chunk VARCHAR2(4096);
    file_handle UTL_FILE.FILE_TYPE;
BEGIN
    -- �������� JSON �� ������ ������� bookings
    SELECT JSON_ARRAYAGG(
                JSON_OBJECT(
                    'id' VALUE b.id,
                    'user_id' VALUE b.user_id,
                    'property_id' VALUE b.property_id,
                    'payment_id' VALUE b.payment_id,
                    'check_in' VALUE TO_CHAR(b.check_in, 'YYYY-MM-DD'),
                    'check_out' VALUE TO_CHAR(b.check_out, 'YYYY-MM-DD'),
                    'guests' VALUE b.guests,
                    'total_price' VALUE b.total_price,
                    'status' VALUE b.status
                )
           ) INTO v_json
    FROM bookings b;
    
    -- ����� JSON � ������� (��� ��������)
    DBMS_OUTPUT.PUT_LINE('Generated JSON: ' || v_json);

    -- ������ JSON � ����
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Opening file for appending...');
        file_handle := UTL_FILE.FOPEN('JSON_OUTPUT', 'bookings.json', 'w', 4096);
        DBMS_OUTPUT.PUT_LINE('File opened successfully.');
        
        -- ���� ������ JSON �� ������
        LOOP
            v_end_pos := v_start_pos + v_chunk_size - 1;
            -- ��������, ��� �� �������� ����� JSON
            IF v_end_pos > LENGTH(v_json) THEN
                v_end_pos := LENGTH(v_json);
            END IF;
            -- ���������� ����� JSON
            v_chunk := SUBSTR(v_json, v_start_pos, v_end_pos - v_start_pos + 1);
            -- ������ ����� JSON � ����
            UTL_FILE.PUT_LINE(file_handle, v_chunk);
            -- ������� � ��������� �����
            v_start_pos := v_end_pos + 1;
            -- ����� �� �����, ���� ��������� ����� JSON
            EXIT WHEN v_start_pos > LENGTH(v_json);
        END LOOP;

        DBMS_OUTPUT.PUT_LINE('JSON written to file.');
        UTL_FILE.FCLOSE(file_handle);
        DBMS_OUTPUT.PUT_LINE('File closed successfully.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('������ ������ �����: ' || SQLERRM);
    END;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('������: ' || SQLERRM);
END export_bookings_to_json;

CREATE OR REPLACE PROCEDURE export_ratings_to_json AS
    v_json CLOB;
    v_chunk_size CONSTANT INTEGER := 4096;
    v_start_pos INTEGER := 1;
    v_end_pos INTEGER;
    v_chunk VARCHAR2(4096);
    file_handle UTL_FILE.FILE_TYPE;
BEGIN
    -- �������� JSON �� ������ ������� ratings
    SELECT JSON_ARRAYAGG(
                JSON_OBJECT(
                    'id' VALUE r.id,
                    'user_id' VALUE r.user_id,
                    'property_id' VALUE r.property_id,
                    'rating' VALUE r.rating,
                    'comment' VALUE r."comment"
                )
           ) INTO v_json
    FROM ratings r;
    
    -- ����� JSON � ������� (��� ��������)
    DBMS_OUTPUT.PUT_LINE('Generated JSON: ' || v_json);

    -- ������ JSON � ����
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Opening file for appending...');
        file_handle := UTL_FILE.FOPEN('JSON_OUTPUT', 'ratings.json', 'w', 4096);
        DBMS_OUTPUT.PUT_LINE('File opened successfully.');
        
        -- ���� ������ JSON �� ������
        LOOP
            v_end_pos := v_start_pos + v_chunk_size - 1;
            -- ��������, ��� �� �������� ����� JSON
            IF v_end_pos > LENGTH(v_json) THEN
                v_end_pos := LENGTH(v_json);
            END IF;
            -- ���������� ����� JSON
            v_chunk := SUBSTR(v_json, v_start_pos, v_end_pos - v_start_pos + 1);
            -- ������ ����� JSON � ����
            UTL_FILE.PUT_LINE(file_handle, v_chunk);
            -- ������� � ��������� �����
            v_start_pos := v_end_pos + 1;
            -- ����� �� �����, ���� ��������� ����� JSON
            EXIT WHEN v_start_pos > LENGTH(v_json);
        END LOOP;

        DBMS_OUTPUT.PUT_LINE('JSON written to file.');
        UTL_FILE.FCLOSE(file_handle);
        DBMS_OUTPUT.PUT_LINE('File closed successfully.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('������ ������ �����: ' || SQLERRM);
    END;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('������: ' || SQLERRM);
END export_ratings_to_json;

CREATE OR REPLACE PROCEDURE export_all_data_to_json AS
BEGIN
    -- ����� ��������� ��� �������� �������������
    export_users_to_json;

    -- ����� ��������� ��� �������� �������
    export_addresses_to_json;

    -- ����� ��������� ��� �������� ������������
    export_properties_amenities_to_json;

    -- ����� ��������� ��� �������� ��������
    export_payments_to_json;

    -- ����� ��������� ��� �������� ������������
    export_bookings_to_json;

    -- ����� ��������� ��� �������� ���������
    export_ratings_to_json;

    DBMS_OUTPUT.PUT_LINE('������� ���� ������ � JSON ��������.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('������ �� ����� ��������: ' || SQLERRM);
END export_all_data_to_json;

BEGIN
    export_users_to_json;
END;

BEGIN
    export_payments_to_json;
END;

BEGIN
    export_addresses_to_json;
END;

BEGIN 
    export_properties_amenities_to_json;
END;

BEGIN
     export_bookings_to_json;
END;

BEGIN
    export_ratings_to_json;
END;

BEGIN   
    export_all_data_to_json;
END;