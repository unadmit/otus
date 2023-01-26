#!/bin/bash

pass='Qwe-1234Qwe-1234'
dbmask='wordpress'
MYSQL="mysql --skip-column-names -p$pass "
`$MYSQL -e "STOP SLAVE;"`
for dbname in `$MYSQL -e "SHOW DATABASES LIKE '%$dbmask%'"`;
do
	echo 'working with db:'$dbname
	mkdir -p $dbname;
	for tablename in `$MYSQL -e "USE $dbname; SHOW TABLES;"`
	do
		echo 'current table is:'$tablename
		/usr/bin/mysqldump -p$pass --add-drop-table --add-locks --create-options --disable-keys --extended-insert --single-transaction --quick --set-charset --events --triggers --master-data=2 $dbname $tablename | gzip -1 > $dbname/$tablename.gz;
	done
done
`$MYSQL -e "START SLAVE;"`