#!/usr/bin/env bash
UserCN="master.byted.org"

getopts "c:" arg
if [ ${arg} = c ];then
    UserCN=${OPTARG}
fi

openssl genrsa -out userkey.pem 2048

openssl req -new -days 365 -key userkey.pem -out userreq.pem -subj "/C=/ST=/L=/O=/OU=/CN=${UserCN}" -config openssl.cnf

/usr/bin/expect <<-EOF
set time 10
spawn openssl ca -in userreq.pem -out usercert.pem -config openssl.cnf -extensions v3_req -config openssl.cnf
expect "*certificate?*:" {send "y\r"}
expect "*commit?*" {send "y\r"}
expect eof
EOF
