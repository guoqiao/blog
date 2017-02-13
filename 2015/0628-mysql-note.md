Title: MySQL Note

* dump all database

    mysqldump --all-databases -u root -p xxxx > dump.sql

* allow all permissons for remote access:

    grant all privileges on *.* to 'root'@'%' with grant option;FLUSH PRIVILEGES;