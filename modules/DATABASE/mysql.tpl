#!/bin/bash
apt update -y
apt install mysql-server net-tools -y
systemctl enable mysql
service mysql start
sed -i -e 's/127.0.0.1/0.0.0.0/g' /etc/mysql/mysql.conf.d/mysqld.cnf
systemctl restart mysql
service mysql restart
mysql -uroot -pwordpress -e  "CREATE DATABASE wordpress;use wordpress;FLUSH PRIVILEGES;create user 'wordpress'@'%' identified WITH mysql_native_password by 'wordpress';GRANT ALL ON wordpress.* TO ' wordpress '@'%'; "


#sed -i -e 's/127.0.0.1/0.0.0.0/g' /etc/mysql/mysql.conf.d/mysqld.cnf 
#sed -e '/mysqlx-bind-address/s/^/#/' /etc/mysql/mysql.conf.d/mysqld.cnf 


