

select * from payments;




-- 1. Пользователи
BEGIN
  add_user('Иван', 'Иванов', 'ivan@example.com', 12345, 30, 'user');
END;
  add_user('Анна', 'Петрова', 'anna@example.com', 67890, 25, 'landlord');
  add_user('Сергей', 'Сидоров', 'sergey@example.com', 54321, 42, 'admin');
  add_user('Елена', 'Смирнова', 'elena@example.com', 98765, 38, 'user');
  add_user('Дмитрий', 'Кузнецов', 'dmitry@example.com', 10293, 28, 'landlord');


select * from users
join properties ON users.id =  properties.user_id;
-- 2. Имущество и адреса
BEGIN
  add_property(2, 'Ленина', '10', 'Москва', 'Московская область', '123456', 'Россия', 12, 'Уютная квартира в центре', 'flat', 'Описание 1', 2, 1, 15000);
  add_property(5, 'Пушкина', '25', 'Санкт-Петербург', 'Ленинградская область', '789012', 'Россия', 34, 'Просторный дом с садом', 'house', 'Описание 2', 5, 1, 30000);
  add_property(2, 'Гагарина', '5', 'Казань', 'Татарстан', '345678', 'Россия', 56, 'Комната в квартире', 'room', 'Описание 3', 1, 1, 8000);
  add_property(5, 'Мира', '1', 'Новосибирск', 'Новосибирская область', '901234', 'Россия', 78, 'Студия с видом на море', 'flat', 'Описание 4', 1, 0, 22000);
  add_property(2, 'Советская', '15', 'Екатеринбург', 'Свердловская область', '567890', 'Россия', null, 'Квартира с балконом', 'flat', 'Описание 5', 2, 1, 18000); 
END;


-- 3. Карты
BEGIN
  add_payment(1, '1234-5678-9012-3456', 'Иван Иванов', TO_DATE('01/25', 'MM/YY'), 123);
  add_payment(2, '9876-5432-1098-7654', 'Анна Петрова', TO_DATE('05/26', 'MM/YY'), 456);
  add_payment(1, '5555-4444-3333-2222', 'Иван Иванов', TO_DATE('12/27', 'MM/YY'), 789);
  add_payment(3, '1111-2222-3333-4444', 'Сергей Сидоров', TO_DATE('08/24', 'MM/YY'), 987);
  add_payment(4, '1000-2000-3000-4000', 'Елена Смирнова', TO_DATE('03/28', 'MM/YY'), 654);
END;

select * from properties
-- 4. Бронирования
BEGIN
  add_booking(1, 1, 1, TO_DATE('2024-06-15', 'YYYY-MM-DD'), TO_DATE('2024-06-20', 'YYYY-MM-DD'), 2, 75000, 'approved');
  add_booking(3, 2, 4, TO_DATE('2024-07-10', 'YYYY-MM-DD'), TO_DATE('2024-07-20', 'YYYY-MM-DD'), 4, 120000, 'denied');
  add_booking(4, 3, 5, TO_DATE('2024-08-01', 'YYYY-MM-DD'), TO_DATE('2024-08-05', 'YYYY-MM-DD'), 1, 40000, 'waiting');
  add_booking(1, 5, 3, TO_DATE('2024-09-18', 'YYYY-MM-DD'), TO_DATE('2024-09-25', 'YYYY-MM-DD'), 2, 90000, 'approved');
  add_booking(3, 1, 4, TO_DATE('2024-10-10', 'YYYY-MM-DD'), TO_DATE('2024-10-15', 'YYYY-MM-DD'), 3, 75000, 'waiting');
END;
select * from bookings

-- 5. Удобства 
BEGIN
  add_property_amenity(10, 1); -- Wi-Fi
END;
  add_property_amenity(1, 2); -- Кондиционер
  add_property_amenity(2, 6); -- Кухня
  add_property_amenity(2, 15); -- Парковка
  add_property_amenity(3, 11); -- Телевизор

SELECT * FROM amenities
SELECT * FROM property_amenities
-- 6. Фотографии
DECLARE
  photos1 url_varray := url_varray('https://example.com/photo1_1.jpg', 'https://example.com/photo1_2.jpg');
  photos2 url_varray := url_varray('https://example.com/photo2_1.jpg', 'https://example.com/photo2_2.jpg', 'https://example.com/photo2_3.jpg');
  photos3 url_varray := url_varray('https://example.com/photo3_1.jpg');
  photos4 url_varray := url_varray('https://example.com/photo4_1.jpg', 'https://example.com/photo4_2.jpg');
  photos5 url_varray := url_varray('https://example.com/photo5_1.jpg', 'https://example.com/photo5_2.jpg', 'https://example.com/photo5_3.jpg', 'https://example.com/photo5_4.jpg');
BEGIN
  add_photos_to_property(1, photos1);
  add_photos_to_property(2, photos2);
  add_photos_to_property(3, photos3);
  add_photos_to_property(4, photos4);
  add_photos_to_property(5, photos5);
END;


-- 7. Отзывы
BEGIN
  add_rating(1, 1, 5, 'Отличная квартира!');


  add_rating(3, 2, 4, 'Хороший дом, но немного далеко от центра.');
  add_rating(4, 3, 3, 'Комната чистая, но шумные соседи.');
  add_rating(1, 5, 5, 'Прекрасный вид с балкона!');
  add_rating(3, 1, 4, 'Удобное расположение.');
END;

SELECT * FROM RATINGS

-- 1. Основные удобства
INSERT INTO amenities (name) VALUES ('Wi-Fi');
INSERT INTO amenities (name) VALUES ('Кондиционер');
INSERT INTO amenities (name) VALUES ('Отопление');
INSERT INTO amenities (name) VALUES ('Горячая вода');
INSERT INTO amenities (name) VALUES ('Холодная вода');

-- 2. Кухня
INSERT INTO amenities (name) VALUES ('Кухня');
INSERT INTO amenities (name) VALUES ('Холодильник');
INSERT INTO amenities (name) VALUES ('Плита');
INSERT INTO amenities (name) VALUES ('Микроволновая печь');
INSERT INTO amenities (name) VALUES ('Посудомоечная машина');

-- 3. Ванная комната
INSERT INTO amenities (name) VALUES ('Ванная');
INSERT INTO amenities (name) VALUES ('Душ');
INSERT INTO amenities (name) VALUES ('Стиральная машина');
INSERT INTO amenities (name) VALUES ('Фен');
INSERT INTO amenities (name) VALUES ('Полотенца');

-- 4. Развлечения
INSERT INTO amenities (name) VALUES ('Телевизор');
INSERT INTO amenities (name) VALUES ('Кабельное телевидение');
INSERT INTO amenities (name) VALUES ('DVD-плеер');
INSERT INTO amenities (name) VALUES ('Музыкальный центр');
INSERT INTO amenities (name) VALUES ('Игровая приставка');

-- 5. Другое
INSERT INTO amenities (name) VALUES ('Парковка');
INSERT INTO amenities (name) VALUES ('Балкон');
INSERT INTO amenities (name) VALUES ('Лифт');
INSERT INTO amenities (name) VALUES ('Бассейн');
INSERT INTO amenities (name) VALUES ('Сауна');
-------------------------------------------------------------------------------------------------------------
