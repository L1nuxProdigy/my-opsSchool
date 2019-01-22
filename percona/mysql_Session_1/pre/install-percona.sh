#!/bin/bash

cd /opt
wget  https://www.percona.com/downloads/Percona-Server-5.7/Percona-Server-5.7.24-27/binary/debian/trusty/x86_64/percona-server-client-5.7_5.7.24-27-1.trusty_amd64.deb
wget  https://www.percona.com/downloads/Percona-Server-5.7/Percona-Server-5.7.24-27/binary/debian/trusty/x86_64/percona-server-common-5.7_5.7.24-27-1.trusty_amd64.deb
wget  https://www.percona.com/downloads/Percona-Server-5.7/Percona-Server-5.7.24-27/binary/debian/trusty/x86_64/percona-server-server-5.7_5.7.24-27-1.trusty_amd64.deb
wget  https://www.percona.com/downloads/Percona-Server-5.7/Percona-Server-5.7.24-27/binary/debian/trusty/x86_64/libperconaserverclient20_5.7.24-27-1.trusty_amd64.deb

apt-get update
apt-get -y install mysql-common
apt-get -y install debsums
apt-get -y install libaio1
apt-get -y install libmecab2
dpkg -i /opt/percona-server-common-5.7_5.7.24-27-1.trusty_amd64.deb
dpkg -i /opt/percona-server-client-5.7_5.7.24-27-1.trusty_amd64.deb
dpkg -i /opt/libperconaserverclient20_5.7.24-27-1.trusty_amd64.deb
export DEBIAN_FRONTEND=noninteractive;
dpkg -i /opt/percona-server-server-5.7_5.7.24-27-1.trusty_amd64.deb

apt-get install git -y
git clone https://github.com/L1nuxProdigy/my-opsSchool
mysql <  /home/ubuntu/my-opsSchool/percona/mysql_Session1_pre/mysqlsampledatabase.sql

