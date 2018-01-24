#!/bin/bash

if [ -z $(ls -A ${DB_DATA_PATH}) ]
then
	echo "=> Installing DB"
	mysql_install_db --user=mysql --datadir="${DB_DATA_PATH}"
	sleep 3
	echo "=> Starting DB for set DB root password"
	mysqld --user=mysql --datadir="${DB_DATA_PATH}" &
	sleep 3
	echo "=> Setting DB root password"
	mysqladmin -u root password "${DB_ROOT_PASSWORD}"
	echo "=> Enable remote access as root from any host"
	#echo "update user set host=’%’ where user=’root’ and host=’ubuntuserv’;\nflush privileges;" > /tmp/sql
	mysql --user=root --password="${DB_ROOT_PASSWORD}" mysql -e "update user set host='%' where user='root' and host='localhost';"
	mysql --user=root --password="${DB_ROOT_PASSWORD}" mysql -e "flush privileges;"
	echo "=> Killing all mysqld instances"
	killall mysqld
	echo "=> Starting DB after installation"
	mysqld --user=mysql --datadir="${DB_DATA_PATH}"
else
	echo "=> Starting DB"
	chown -R mysql:mysql /data
	mysqld --user=mysql --datadir="${DB_DATA_PATH}"
fi

