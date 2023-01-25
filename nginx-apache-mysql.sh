#!/bin/bash
yum -y install nginx
systemctl enable --now nginx
yes | cp -rf ./otus-linux-basic/nginx-apache-mysql/default.conf /etc/nginx/conf.d/
yes | cp -rf ./otus-linux-basic/nginx-apache-mysql/nginx.conf /etc/nginx/
yum -y install httpd
sed -i "s/Listen 80/Listen 8080/" /etc/httpd/conf/httpd.conf
sed -i "s/\#ServerName www.example.com:80/ServerName localhost/" /etc/httpd/conf/httpd.conf
yes | cp -rf ./otus-linux-basic/nginx-apache-mysql/wordpress.conf /etc/httpd/conf.d
systemctl enable --now httpd.service
tar -xzf ./otus-linux-basic/nginx-apache-mysql/html.tar.gz
rsync -avP ./html/ /var/www/html/
chown -R apache:apache /var/www/html/*
rpm -Uvh https://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum -y --enablerepo=remi-php80 install php php-bcmath php-cli php-common php-curl php-devel php-dom php-exif php-fileinfo php-fpm php-gd php-imagick php-json php-mbstring php-mysqlnd php-mysqli php-openssl php-pcre php-pear php-xml php-zip
systemctl restart httpd.service
rpm -Uvh https://repo.mysql.com/mysql80-community-release-el7-5.noarch.rpm
sed -i 's/enabled=1/enabled=0/' /etc/yum.repos.d/mysql-community.repo
yum -y --enablerepo=mysql80-community install mysql-community-server
systemctl enable --now mysqld
sleep 5
root_temp_pass=$(grep 'A temporary password' /var/log/mysqld.log |tail -1 |awk '{split($0,a,": "); print a[2]}')
pass="Qwe-1234"
mysql --skip-column-names -p$root_temp_pass -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH 'caching_sha2_password' BY '${pass}'; "
mysql --skip-column-names -p$pass -e "FLUSH PRIVILEGES; "
echo "__________________"
mysql_secure_installation -u root --password="${pass}" --use-default
mysql --skip-column-names -p$pass -e "CREATE USER repl@'%' IDENTIFIED WITH 'caching_sha2_password' BY '$pass'; "
mysql --skip-column-names -p$pass -e "GRANT REPLICATION SLAVE ON *.* TO repl@'%'; "
mysql --skip-column-names -p$pass -e "CREATE DATABASE wordpress; "
mysql --skip-column-names -p$pass -e "CREATE USER 'wordpressuser'@'%' IDENTIFIED WITH mysql_native_password BY '$pass'; "
files=$(find ./otus-linux-basic/nginx-apache-mysql/ -name "wp_*.gz")
for filename in $files
    do
        zcat $filename | mysql --skip-column-names -p$pass wordpress &>/dev/null
    done
mysql --skip-column-names -p$pass -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpressuser'@'%'; "
mysql --skip-column-names -p$pass -e "FLUSH PRIVILEGES;"