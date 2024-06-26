-- Создание ролей
CREATE ROLE admin;
CREATE ROLE landlord;
CREATE ROLE DefUser;

GRANT CREATE SESSION TO admin;
GRANT CREATE SESSION TO landlord;
GRANT CREATE SESSION TO DefUser;

-- Привилегии для роли admin
GRANT ALL ON users TO admin;
GRANT ALL ON payments TO admin;
GRANT ALL ON addresses TO admin;
GRANT ALL ON properties TO admin;
GRANT ALL ON amenities TO admin;
GRANT ALL ON property_amenities TO admin;
GRANT ALL ON photoes TO admin;
GRANT ALL ON bookings TO admin;
GRANT ALL ON ratings TO admin;

-- Привилегии для роли landlord
GRANT SELECT, INSERT, UPDATE, DELETE ON properties TO landlord;
GRANT SELECT, INSERT, UPDATE, DELETE ON property_amenities TO landlord;
GRANT SELECT, INSERT, UPDATE, DELETE ON bookings TO landlord;
GRANT SELECT, INSERT, UPDATE, DELETE ON photoes TO landlord;
GRANT SELECT, INSERT, UPDATE, DELETE ON addresses TO landlord;
-- Привилегии для роли DefUser
GRANT SELECT, INSERT, UPDATE, DELETE ON bookings TO DefUser;
GRANT SELECT, INSERT ON ratings TO DefUser;
GRANT SELECT, INSERT, UPDATE ON users TO DefUser;
GRANT SELECT, INSERT, UPDATE ON payments TO DefUser;

-- Привилегии для просмотра данных о свойствах и удобствах пользователю
GRANT SELECT ON properties TO DefUser;
GRANT SELECT ON amenities TO DefUser;
GRANT SELECT ON property_amenities TO DefUser;
GRANT SELECT ON photoes TO DefUser;

-- Привилегии для работы с адресами для всех ролей
GRANT SELECT ON addresses TO landlord;
GRANT SELECT ON addresses TO DefUser;

-- Создание пользователей и назначение им ролей
-- Пример создания пользователя и назначения роли
CREATE USER landlord_user IDENTIFIED BY 1111;
GRANT landlord TO landlord_user;

CREATE USER default_user IDENTIFIED BY 1111;
GRANT DefUser TO default_user;

CREATE USER admin_user IDENTIFIED BY 1111;
GRANT admin TO admin_user ;
