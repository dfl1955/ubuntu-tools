-- make database and login and grant permissions;
CREATE DATABASE openfire;

GRANT ALL PRIVILEGES ON openfire.* TO openfire@localhost 
   IDENTIFIED BY 'password';

FLUSH PRIVILEGES;
EXIT;

-- make the tables 

USE openfire;
source /usr/share/openfire/resources/database/openfire_mysql.sql;

EXIT;