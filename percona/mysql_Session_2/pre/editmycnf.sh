#!/bin/bash

while IFS='' read -r line || [[ -n "$line" ]]; do
  echo "$line"
  echo $line >> /etc/mysql/percona-server.conf.d/mysqld.cnf
done < /home/vagrant/mycnf.txt
