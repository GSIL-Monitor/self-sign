#!/usr/bin/env bash
CaCN="bytedance.org"
CADIR="demoCA"

getopts "c:" arg
if [ ${arg} = c ];then
    CaCN=${OPTARG}
fi

echo ${arg} ${OPTARG}
mkdir -p ./${CADIR}/{private,newcerts} && \
    touch ./demoCA/index.txt && \
    touch ./demoCA/serial && \
    echo 01 > ./demoCA/serial

openssl genrsa -out ./demoCA/private/cakey.pem 2048

openssl req -new -key ./demoCA/private/cakey.pem -out careq.pem -subj "/C=/ST=/L=/O=/OU=/CN=${CaCN}" -config openssl.cnf

/usr/bin/expect <<-EOF
set time 10
spawn openssl ca -selfsign -days 3650 -in careq.pem -out ./demoCA/cacert.pem -extensions v3_ca -config openssl.cnf
expect "*certificate?*:" {send "y\r"}
expect "*commit?*" {send "y\r"}
expect eof
EOF
