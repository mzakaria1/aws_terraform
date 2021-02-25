#!/bin/bash
yum update -y
yum install -y httpd 
amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
cp -r wordpress/* /var/www/html/
service httpd start
cp /var/www/html/wp-config-sample.php  /var/www/html/wp-config.php

sed -i -e 's/database_name_here/wordpress/g' /var/www/html/wp-config.php
sed -i -e 's/username_here/wordpress/g' /var/www/html/wp-config.php
sed -i -e 's/password_here/wordpress/g' /var/www/html/wp-config.php
sed -i -e 's/localhost/${host}/g' /var/www/html/wp-config.php
