#!/bin/bash
pass='Qwe-1234Qwe-1234'
mysql --skip-column-names -p$pass -e "CREATE DATABASE wordpress; "
mysql --skip-column-names -p$pass -e "CREATE USER 'wordpressuser'@'%' IDENTIFIED WITH mysql_native_password BY '$pass'; "
files=$(find ./otus-linux-basic/nginx-apache-mysql/ -name "wp_*.gz")
for filename in $files
    do
        zcat $filename | mysql --skip-column-names -p$pass wordpress &>/dev/null
    done
mysql --skip-column-names -p$pass -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpressuser'@'%'; "
mysql --skip-column-names -p$pass -e "FLUSH PRIVILEGES; "
mysql --skip-column-names -p$pass -e "update wordpress.wp_options set option_value='http://192.168.1.196' where option_name in ('siteurl','home'); "