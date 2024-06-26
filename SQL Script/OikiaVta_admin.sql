--=========================================================
ALTER SESSION SET "_oracle_script" = true;
alter session set "_ORACLE_SCRIPT"=true;
CREATE USER hr identified by "1111" default tablespace users quota unlimited on users;

GRANT resource, connect, create table, create session TO hr;
GRANT CREATE ANY DIRECTORY TO hr;
CREATE OR REPLACE DIRECTORY json_output AS 'C:\app\pavel\product\21c\JsonExport';
GRANT READ, WRITE ON DIRECTORY json_output TO hr;

CREATE OR REPLACE DIRECTORY json_input AS '"C:\app\pavel\product\21c\JsonImport"';
GRANT READ, WRITE ON DIRECTORY json_input TO hr;

SELECT directory_name, directory_path
FROM all_directories
WHERE directory_name = 'JSON_INPUT';


CREATE USER backup_user IDENTIFIED BY 1111;
GRANT CONNECT, RESOURCE, RECOVERY_CATALOG_OWNER TO backup_user;
GRANT SYSBACKUP TO backup_user;


GRANT CREATE SESSION TO hr;

-- Выдача прав на управление ролями и пользователями
GRANT CREATE USER TO hr;
GRANT ALTER USER TO hr;
GRANT DROP USER TO hr;
GRANT CREATE ROLE TO hr;
GRANT GRANT ANY ROLE TO hr;
GRANT CREATE SESSION TO hr;

-- Выдача прав на управление объектами
GRANT SELECT, INSERT, UPDATE, DELETE ON users TO hr;
GRANT SELECT, INSERT, UPDATE, DELETE ON properties TO hr;
GRANT SELECT, INSERT, UPDATE, DELETE ON payments TO hr;
GRANT SELECT, INSERT, UPDATE, DELETE ON addresses TO hr;
GRANT SELECT, INSERT, UPDATE, DELETE ON bookings TO hr;
GRANT SELECT, INSERT, UPDATE, DELETE ON ratings TO hr;
GRANT SELECT, INSERT, UPDATE, DELETE ON amenities TO hr;
GRANT SELECT, INSERT, UPDATE, DELETE ON property_amenities TO hr;
GRANT SELECT, INSERT, UPDATE, DELETE ON photos TO hr;