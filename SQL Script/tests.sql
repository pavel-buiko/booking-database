

select * from payments;




-- 1. ������������
BEGIN
  add_user('����', '������', 'ivan@example.com', 12345, 30, 'user');
END;
  add_user('����', '�������', 'anna@example.com', 67890, 25, 'landlord');
  add_user('������', '�������', 'sergey@example.com', 54321, 42, 'admin');
  add_user('�����', '��������', 'elena@example.com', 98765, 38, 'user');
  add_user('�������', '��������', 'dmitry@example.com', 10293, 28, 'landlord');


select * from users
join properties ON users.id =  properties.user_id;
-- 2. ��������� � ������
BEGIN
  add_property(2, '������', '10', '������', '���������� �������', '123456', '������', 12, '������ �������� � ������', 'flat', '�������� 1', 2, 1, 15000);
  add_property(5, '�������', '25', '�����-���������', '������������� �������', '789012', '������', 34, '���������� ��� � �����', 'house', '�������� 2', 5, 1, 30000);
  add_property(2, '��������', '5', '������', '���������', '345678', '������', 56, '������� � ��������', 'room', '�������� 3', 1, 1, 8000);
  add_property(5, '����', '1', '�����������', '������������� �������', '901234', '������', 78, '������ � ����� �� ����', 'flat', '�������� 4', 1, 0, 22000);
  add_property(2, '���������', '15', '������������', '������������ �������', '567890', '������', null, '�������� � ��������', 'flat', '�������� 5', 2, 1, 18000); 
END;


-- 3. �����
BEGIN
  add_payment(1, '1234-5678-9012-3456', '���� ������', TO_DATE('01/25', 'MM/YY'), 123);
  add_payment(2, '9876-5432-1098-7654', '���� �������', TO_DATE('05/26', 'MM/YY'), 456);
  add_payment(1, '5555-4444-3333-2222', '���� ������', TO_DATE('12/27', 'MM/YY'), 789);
  add_payment(3, '1111-2222-3333-4444', '������ �������', TO_DATE('08/24', 'MM/YY'), 987);
  add_payment(4, '1000-2000-3000-4000', '����� ��������', TO_DATE('03/28', 'MM/YY'), 654);
END;

select * from properties
-- 4. ������������
BEGIN
  add_booking(1, 1, 1, TO_DATE('2024-06-15', 'YYYY-MM-DD'), TO_DATE('2024-06-20', 'YYYY-MM-DD'), 2, 75000, 'approved');
  add_booking(3, 2, 4, TO_DATE('2024-07-10', 'YYYY-MM-DD'), TO_DATE('2024-07-20', 'YYYY-MM-DD'), 4, 120000, 'denied');
  add_booking(4, 3, 5, TO_DATE('2024-08-01', 'YYYY-MM-DD'), TO_DATE('2024-08-05', 'YYYY-MM-DD'), 1, 40000, 'waiting');
  add_booking(1, 5, 3, TO_DATE('2024-09-18', 'YYYY-MM-DD'), TO_DATE('2024-09-25', 'YYYY-MM-DD'), 2, 90000, 'approved');
  add_booking(3, 1, 4, TO_DATE('2024-10-10', 'YYYY-MM-DD'), TO_DATE('2024-10-15', 'YYYY-MM-DD'), 3, 75000, 'waiting');
END;
select * from bookings

-- 5. �������� 
BEGIN
  add_property_amenity(10, 1); -- Wi-Fi
END;
  add_property_amenity(1, 2); -- �����������
  add_property_amenity(2, 6); -- �����
  add_property_amenity(2, 15); -- ��������
  add_property_amenity(3, 11); -- ���������

SELECT * FROM amenities
SELECT * FROM property_amenities
-- 6. ����������
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


-- 7. ������
BEGIN
  add_rating(1, 1, 5, '�������� ��������!');


  add_rating(3, 2, 4, '������� ���, �� ������� ������ �� ������.');
  add_rating(4, 3, 3, '������� ������, �� ������ ������.');
  add_rating(1, 5, 5, '���������� ��� � �������!');
  add_rating(3, 1, 4, '������� ������������.');
END;

SELECT * FROM RATINGS

-- 1. �������� ��������
INSERT INTO amenities (name) VALUES ('Wi-Fi');
INSERT INTO amenities (name) VALUES ('�����������');
INSERT INTO amenities (name) VALUES ('���������');
INSERT INTO amenities (name) VALUES ('������� ����');
INSERT INTO amenities (name) VALUES ('�������� ����');

-- 2. �����
INSERT INTO amenities (name) VALUES ('�����');
INSERT INTO amenities (name) VALUES ('�����������');
INSERT INTO amenities (name) VALUES ('�����');
INSERT INTO amenities (name) VALUES ('������������� ����');
INSERT INTO amenities (name) VALUES ('������������� ������');

-- 3. ������ �������
INSERT INTO amenities (name) VALUES ('������');
INSERT INTO amenities (name) VALUES ('���');
INSERT INTO amenities (name) VALUES ('���������� ������');
INSERT INTO amenities (name) VALUES ('���');
INSERT INTO amenities (name) VALUES ('���������');

-- 4. �����������
INSERT INTO amenities (name) VALUES ('���������');
INSERT INTO amenities (name) VALUES ('��������� �����������');
INSERT INTO amenities (name) VALUES ('DVD-�����');
INSERT INTO amenities (name) VALUES ('����������� �����');
INSERT INTO amenities (name) VALUES ('������� ���������');

-- 5. ������
INSERT INTO amenities (name) VALUES ('��������');
INSERT INTO amenities (name) VALUES ('������');
INSERT INTO amenities (name) VALUES ('����');
INSERT INTO amenities (name) VALUES ('�������');
INSERT INTO amenities (name) VALUES ('�����');
-------------------------------------------------------------------------------------------------------------
