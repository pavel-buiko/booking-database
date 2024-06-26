-- �������� �����
CREATE ROLE admin;
CREATE ROLE landlord;
CREATE ROLE DefUser;

GRANT CREATE SESSION TO admin;
GRANT CREATE SESSION TO landlord;
GRANT CREATE SESSION TO DefUser;

-- ���������� ��� ���� admin
GRANT ALL ON users TO admin;
GRANT ALL ON payments TO admin;
GRANT ALL ON addresses TO admin;
GRANT ALL ON properties TO admin;
GRANT ALL ON amenities TO admin;
GRANT ALL ON property_amenities TO admin;
GRANT ALL ON photoes TO admin;
GRANT ALL ON bookings TO admin;
GRANT ALL ON ratings TO admin;

-- ���������� ��� ���� landlord
GRANT SELECT, INSERT, UPDATE, DELETE ON properties TO landlord;
GRANT SELECT, INSERT, UPDATE, DELETE ON property_amenities TO landlord;
GRANT SELECT, INSERT, UPDATE, DELETE ON bookings TO landlord;
GRANT SELECT, INSERT, UPDATE, DELETE ON photoes TO landlord;
GRANT SELECT, INSERT, UPDATE, DELETE ON addresses TO landlord;
-- ���������� ��� ���� DefUser
GRANT SELECT, INSERT, UPDATE, DELETE ON bookings TO DefUser;
GRANT SELECT, INSERT ON ratings TO DefUser;
GRANT SELECT, INSERT, UPDATE ON users TO DefUser;
GRANT SELECT, INSERT, UPDATE ON payments TO DefUser;

-- ���������� ��� ��������� ������ � ��������� � ��������� ������������
GRANT SELECT ON properties TO DefUser;
GRANT SELECT ON amenities TO DefUser;
GRANT SELECT ON property_amenities TO DefUser;
GRANT SELECT ON photoes TO DefUser;

-- ���������� ��� ������ � �������� ��� ���� �����
GRANT SELECT ON addresses TO landlord;
GRANT SELECT ON addresses TO DefUser;

-- �������� ������������� � ���������� �� �����
-- ������ �������� ������������ � ���������� ����
CREATE USER landlord_user IDENTIFIED BY 1111;
GRANT landlord TO landlord_user;

CREATE USER default_user IDENTIFIED BY 1111;
GRANT DefUser TO default_user;

CREATE USER admin_user IDENTIFIED BY 1111;
GRANT admin TO admin_user ;
