-- Создаем процедуру для заполнения таблицы users
CREATE OR REPLACE PROCEDURE populate_users(
    count_users IN NUMBER
) AS
    -- Массивы имен и фамилий
    v_first_names VARCHAR2(4000) := 'John,Jane,Mike,Emily,David,Jessica,Daniel,Ashley,Christopher,Samantha,Alexander,Benjamin,Olivia,Emma,James,Liam,Isabella,Sophia,Michael,William,Ethan,Charlotte,Ava,Matthew,Aiden,Elijah,Mia,Abigail,Elizabeth,Natalie,Hannah,Grace,Andrew,Joshua,Lucas,Avery,Scarlett,Victoria,Chloe,Sebastian,Evelyn,Lily,Zoe,Logan,Jackson,Owen,Ella,Claire,Lincoln,Carter,Luke,Gabriel,Grace,Harper,Henry,Nathan,Oscar,Penelope,Riley,Sarah,Stella,Thomas,Amelia,Anna,Anthony,Brandon,Emily,Hailey,Jacob,Julia,Leah,Liam,Lucas,Madeline,Mason,Megan,Nicholas,Noah,Samantha,Sophie,Zachary';
    v_last_names VARCHAR2(4000) := 'Smith,Jones,Brown,Davis,Miller,Wilson,Moore,Taylor,Anderson,Thomas,Roberts,Johnson,Lewis,Walker,Hall,Allen,Young,Harris,Scott,Cook,Morris,Rogers,Hill,Cooper,King,Carter,Parker,Edwards,Stewart,Reed,Collins,Bailey,Kelly,Richardson,Ward,Cox,Bell,Fisher,Hughes,Murphy,Turner,Adams,Ross,Griffin,Murray,Phillips,Woods,Graham,Sullivan,Butler,Perry,Cole,Bennett,Kelly,Foster,Bryant,Simmons,Russell,Hamilton,Griffith,Hansen,Ferguson,Walters,Carroll,Lawrence,Holland,Curtis,Bradley,Jensen,Weaver,Burke,Warren,Dixon,Hudson,May,Dean,Lane,Blake,Sharp,Gardner';

    -- Переменные для хранения случайных значений
    v_first_name VARCHAR2(30);
    v_last_name VARCHAR2(50);
    v_email VARCHAR2(100);
    v_password NUMBER(10);
    v_age NUMBER(3);
    v_role VARCHAR2(10);

    -- Вспомогательные переменные для обработки массивов
    v_first_name_idx NUMBER;
    v_last_name_idx NUMBER;
BEGIN
    -- Цикл для создания заданного количества пользователей
    FOR i IN 1..count_users LOOP
        -- Выбор случайного имени из массива
        v_first_name_idx := DBMS_RANDOM.VALUE(1, LENGTH(v_first_names) - LENGTH(REPLACE(v_first_names, ',', '')));
        v_first_name := SUBSTR(v_first_names, INSTR(v_first_names, ',', 1, v_first_name_idx - 1) + 1,
                              INSTR(v_first_names, ',', 1, v_first_name_idx) - INSTR(v_first_names, ',', 1, v_first_name_idx - 1) - 1);

        -- Выбор случайной фамилии из массива
        v_last_name_idx := DBMS_RANDOM.VALUE(1, LENGTH(v_last_names) - LENGTH(REPLACE(v_last_names, ',', '')));
        v_last_name := SUBSTR(v_last_names, INSTR(v_last_names, ',', 1, v_last_name_idx - 1) + 1,
                              INSTR(v_last_names, ',', 1, v_last_name_idx) - INSTR(v_last_names, ',', 1, v_last_name_idx - 1) - 1);

        -- Генерация случайного email
        v_email := v_first_name || '@g.com';

        -- Генерация случайного пароля
        v_password := TRUNC(DBMS_RANDOM.VALUE * 100000); -- Исправлено: TRUNC вместо ROUND

        -- Генерация случайного возраста
        v_age := DBMS_RANDOM.VALUE(18, 65);

        -- Выбор случайной роли
        v_role := CASE ROUND(DBMS_RANDOM.VALUE(1, 3))
            WHEN 1 THEN 'admin'
            WHEN 2 THEN 'user'
            ELSE 'landlord'
          END;

        -- Вставка данных в таблицу users
        INSERT INTO users (first_name, last_name, email, password, age, role) 
        VALUES (v_first_name, v_last_name, v_email, v_password, v_age, v_role);
    END LOOP;
END;

BEGIN
    populate_users(100);
END;


select * from users;







CREATE OR REPLACE PROCEDURE populate_payments(
    count_payments IN NUMBER
) AS
    -- Переменные для хранения случайных значений
    v_user_id NUMBER(20);
    v_card_number VARCHAR2(19);
    v_card_owner VARCHAR2(100);
    v_expiration_date DATE;
    v_cvv_code NUMBER(3);

    -- Вспомогательная переменная для обработки массива
    v_card_number_idx NUMBER;
BEGIN
    -- Цикл для создания заданного количества платежей
    FOR i IN 1..count_payments LOOP
        -- Выбор случайного user_id
        v_user_id := TRUNC(DBMS_RANDOM.VALUE(1, 100000));

        -- Выбор случайного номера карты из массива
        --v_card_number_idx := DBMS_RANDOM.VALUE(1, LENGTH(v_card_numbers) - LENGTH(REPLACE(v_card_numbers, ',', '')));
       --v_card_number := SUBSTR(v_card_numbers, INSTR(v_card_numbers, ',', 1, v_card_number_idx - 1) + 1,
                              --INSTR(v_card_numbers, ',', 1, v_card_number_idx) - INSTR(v_card_numbers, ',', 1, v_card_number_idx - 1) - 1);
        v_card_number :='4111111111111111';
        -- Генерация случайного имени владельца карты
        v_card_owner := 'John' || ' ' ||'Rockfeller';

        -- Генерация случайной даты окончания срока действия
        v_expiration_date := ADD_MONTHS(TRUNC(SYSDATE), DBMS_RANDOM.VALUE(12, 60));

        -- Генерация случайного CVV-кода
        v_cvv_code := 111;

        -- Вставка данных в таблицу payments
        INSERT INTO payments (user_id, card_number, card_owner, expiration_date, cvv_code) 
        VALUES (v_user_id, v_card_number, v_card_owner, v_expiration_date, v_cvv_code);
    END LOOP;
END;

-- Вызываем процедуру для заполнения таблицы 10 записями
BEGIN
    populate_payments(100000);
END;

select * from payments;





CREATE OR REPLACE PROCEDURE populate_addresses(
    count_addresses IN NUMBER
) AS
    -- Переменные для хранения случайных значений
    v_street_title VARCHAR2(50);
    v_street_address VARCHAR2(5);
    v_city VARCHAR2(50);
    v_state VARCHAR2(50);
    v_postal_code VARCHAR2(7);
    v_country VARCHAR2(50);
    v_apartment_number NUMBER(4);

    -- Вспомогательные переменные для обработки массивов
    v_street_title_idx NUMBER;
    v_city_idx NUMBER;
    v_state_idx NUMBER;
    v_country_idx NUMBER;
BEGIN
    -- Цикл для создания заданного количества адресов
    FOR i IN 1..count_addresses LOOP

        v_street_title := 'Main';

        -- Выбор случайного номера улицы
        v_street_address := TO_CHAR(ROUND(DBMS_RANDOM.VALUE(1, 1000)));

        -- Выбор случайного города из массива
        
        v_city := 'Chicago';

        -- Выбор случайного штата из массива

        v_state := 'Texas';

        -- Выбор случайного почтового индекса
        v_postal_code := TO_CHAR(ROUND(DBMS_RANDOM.VALUE(10000, 99999)));

        -- Выбор случайной страны из массива
        v_country := 'USA';

        -- Выбор случайного номера квартиры (может быть NULL)
        IF DBMS_RANDOM.VALUE > 0.5 THEN
            v_apartment_number := ROUND(DBMS_RANDOM.VALUE(1, 999));
        END IF;

        -- Вставка данных в таблицу addresses
        INSERT INTO addresses (street_title, street_address, city, state, postal_code, country, apartment_number)
        VALUES (v_street_title, v_street_address, v_city, v_state, v_postal_code, v_country, v_apartment_number);
    END LOOP;
END;


-- Вызываем процедуру для заполнения таблицы 100 записями
BEGIN
    populate_addresses(100000);
END;


select * from addresses;




CREATE OR REPLACE PROCEDURE populate_properties(
    count_properties IN NUMBER
) AS
    -- Переменные для хранения случайных значений
    v_user_id NUMBER(20);
    v_address_id NUMBER(20);
    v_title VARCHAR2(250);
    v_type VARCHAR2(50);
    v_description VARCHAR2(4000);
    v_rooms NUMBER(2);
    v_is_available NUMBER(1, 0);
    v_price NUMBER(10, 2);
BEGIN
    -- Цикл для создания заданного количества свойств
    FOR i IN 1..count_properties LOOP
        
    v_user_id := 9;
        
    v_address_id := 4;
        -- Генерация случайного заголовка
        v_title := DBMS_RANDOM.STRING('L', 10) || ' ' || DBMS_RANDOM.STRING('L', 15);

        -- Выбор случайного типа недвижимости
        v_type := CASE TRUNC(DBMS_RANDOM.VALUE(1, 3))
            WHEN 1 THEN 'flat'
            WHEN 2 THEN 'house'
            ELSE 'room'
        END;

        -- Генерация случайного описания
        v_description := DBMS_RANDOM.STRING('L', 50) || ' ' || DBMS_RANDOM.STRING('L', 100);

        -- Генерация случайного количества комнат
        v_rooms := DBMS_RANDOM.VALUE(1, 5);

        -- Выбор случайного значения доступности
        v_is_available := CASE DBMS_RANDOM.VALUE(1, 2)
            WHEN 1 THEN 1
            ELSE 0
        END;

        -- Генерация случайной цены
        v_price := DBMS_RANDOM.VALUE(500, 5000);

        -- Вставка данных в таблицу properties
        INSERT INTO properties (user_id, address_id, title, type, description, rooms, is_available, price)
        VALUES (v_user_id, v_address_id, v_title, v_type, v_description, v_rooms, v_is_available, v_price);
    END LOOP;
END;


-- Вызываем процедуру для заполнения таблицы 100 записями
BEGIN
    populate_properties(100000);
END;

SELECT * from properties;



CREATE OR REPLACE PROCEDURE populate_property_amenities(
    count_relations IN NUMBER
) AS
    -- Переменные для хранения случайных значений
    v_property_id NUMBER(20);
    v_amenity_id NUMBER(20);
BEGIN
    -- Цикл для создания заданного количества связей
    FOR i IN 1..count_relations LOOP
        -- Выбор случайного property_id
        v_property_id := DBMS_RANDOM.VALUE(1, 10000);

        -- Выбор случайного amenity_id
        v_amenity_id := DBMS_RANDOM.VALUE(1, 20);

        -- Вставка данных в таблицу property_amenities
        INSERT INTO property_amenities (property_id, amenity_id)
        VALUES (v_property_id, v_amenity_id);
    END LOOP;
END;


-- Вызываем процедуру для заполнения таблицы 100 записями
BEGIN
    populate_property_amenities(100000);
END;




