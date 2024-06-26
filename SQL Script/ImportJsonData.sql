CREATE OR REPLACE PROCEDURE import_users_from_json(filename IN VARCHAR2) AS
v_file UTL_FILE.FILE_TYPE;
v_json CLOB;
BEGIN
-- Открываем файл из директории JSON_IMPORT
v_file := UTL_FILE.FOPEN('JSON_INPUT', filename, 'R');

      
-- Читаем строку из файла
UTL_FILE.GET_LINE(v_file, v_json);

-- Вставляем данные в таблицу users
INSERT INTO users (first_name, last_name, email, password, age, role)
SELECT jt.first_name,
       jt.last_name,
       jt.email,
       jt.password,
       jt.age,
       jt.role
FROM JSON_TABLE(v_json, '$[*]'
    COLUMNS (
        first_name VARCHAR2(30) PATH '$.first_name',
        last_name VARCHAR2(50) PATH '$.last_name',
        email VARCHAR2(100) PATH '$.email',
        password NUMBER(10) PATH '$.password',
        age NUMBER(3) PATH '$.age',
        role VARCHAR2(10) PATH '$.role'
    )
) jt;

-- Фиксируем транзакцию
COMMIT;

-- Закрываем файл
UTL_FILE.FCLOSE(v_file);

EXCEPTION
    WHEN OTHERS THEN
        IF UTL_FILE.IS_OPEN(v_file) THEN
        UTL_FILE.FCLOSE(v_file);
    END IF;
    RAISE;
END;

CREATE OR REPLACE PROCEDURE import_payments_from_json(filename IN VARCHAR2) AS
    v_file UTL_FILE.FILE_TYPE;
    v_json CLOB;
BEGIN
    -- Открываем файл из директории JSON_INPUT
    v_file := UTL_FILE.FOPEN('JSON_INPUT', filename, 'R');
    
    -- Читаем строку из файла
    UTL_FILE.GET_LINE(v_file, v_json);
    
    -- Вставляем данные в таблицу payments
    INSERT INTO payments (user_id, card_number, card_owner, expiration_date, cvv_code)
    SELECT jt.user_id,
           jt.card_number,
           jt.card_owner,
           TO_DATE(jt.expiration_date, 'YYYY-MM-DD'), -- Преобразование строки в дату
           jt.cvv_code
    FROM JSON_TABLE(v_json, '$[*]'
        COLUMNS (
            user_id NUMBER(20) PATH '$.user_id',
            card_number VARCHAR2(19) PATH '$.card_number',
            card_owner VARCHAR2(100) PATH '$.card_owner',
            expiration_date VARCHAR2(10) PATH '$.expiration_date', -- Строка в формате YYYY-MM-DD
            cvv_code NUMBER(3) PATH '$.cvv_code'
        )
    ) jt;
    
    -- Фиксируем транзакцию
    COMMIT;
    
    -- Закрываем файл
    UTL_FILE.FCLOSE(v_file);
EXCEPTION
    WHEN OTHERS THEN
        IF UTL_FILE.IS_OPEN(v_file) THEN
            UTL_FILE.FCLOSE(v_file);
        END IF;
        RAISE;
END;

CREATE OR REPLACE PROCEDURE IMPORT_ADDRESSES_FROM_JSON(filename IN VARCHAR2) AS
    v_file UTL_FILE.FILE_TYPE;
    v_json CLOB;
BEGIN
    v_file := UTL_FILE.FOPEN('JSON_INPUT', filename, 'R');
    UTL_FILE.GET_LINE(v_file, v_json);
    INSERT INTO addresses (street_title, street_address, city, state, postal_code, country, apartment_number)
    SELECT jt.street_title,
           jt.street_address,
           jt.city,
           jt.state,
           jt.postal_code,
           jt.country,
           jt.apartment_number
    FROM JSON_TABLE(v_json, '$[*]'
        COLUMNS (
            street_title VARCHAR2(50) PATH '$.street_title',
            street_address VARCHAR2(5) PATH '$.street_address',
            city VARCHAR2(50) PATH '$.city',
            state VARCHAR2(50) PATH '$.state',
            postal_code VARCHAR2(7) PATH '$.postal_code',
            country VARCHAR2(50) PATH '$.country',
            apartment_number NUMBER(4) PATH '$.apartment_number'
        )
    ) jt;
    COMMIT;
    UTL_FILE.FCLOSE(v_file);
EXCEPTION
    WHEN OTHERS THEN
        IF UTL_FILE.IS_OPEN(v_file) THEN
            UTL_FILE.FCLOSE(v_file);
        END IF;
        RAISE;
END;




SET SERVEROUTPUT ON;


BEGIN
    import_users_from_json('users.json');
END;

SELECT * FROM USERS;

BEGIN
    import_payments_from_json('payments.json');
END;

BEGIN
    import_addresses_from_json('addresses.json');
END;


select * from properties


