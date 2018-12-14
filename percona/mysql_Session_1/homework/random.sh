#!/bin/bash


service mysql stop
echo "!includedir /etc/mysql/percona-server.conf.d/" >> /etc/mysql/my.cnf
TEMP=$RANDOM
echo "You drew case number $TEMP"
RAND=$(( ( TEMP % 3 ) + 1 ))
#echo "You drew case number $RAND"

case "$RAND" in

1)  chown root:root /var/lib/mysql/ibdata1
    ;;
2)  echo  "innodb_buffer_pool_size = 200G" >> /etc/mysql/percona-server.conf.d/mysqld.cnf
    ;;
3)  echo  "--skip-secure-auth" >> /etc/mysql/percona-server.conf.d/mysqld.cnf
    ;;
esac

echo "MySQL got broken, please fix"
