#!/bin/bash

cd /opt
wget  https://www.percona.com/downloads/Percona-Server-5.7/Percona-Server-5.7.24-27/binary/debian/trusty/x86_64/percona-server-client-5.7_5.7.24-27-1.trusty_amd64.deb
wget  https://www.percona.com/downloads/Percona-Server-5.7/Percona-Server-5.7.24-27/binary/debian/trusty/x86_64/percona-server-common-5.7_5.7.24-27-1.trusty_amd64.deb
wget  https://www.percona.com/downloads/Percona-Server-5.7/Percona-Server-5.7.24-27/binary/debian/trusty/x86_64/percona-server-server-5.7_5.7.24-27-1.trusty_amd64.deb
wget  https://www.percona.com/downloads/Percona-Server-5.7/Percona-Server-5.7.24-27/binary/debian/trusty/x86_64/libperconaserverclient20_5.7.24-27-1.trusty_amd64.deb
apt-get update
export DEBIAN_FRONTEND=noninteractive;

