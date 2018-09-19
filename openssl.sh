#!/usr/bin/env bash
set -e

OUT="tls"

CADIR="demoCA"
CAREQ="careq.pem"
CACRT="cacert.pem"

USERCRT="usercert.pem"
USERKEY="userkey.pem"
USERREQ="userreq.pem"

rm -rf ${OUT}

CaCN="byted.org"
MasterCN="master-tao.byted.org"
PaasCN="paas-tao.byted.org"

echo "Generate CA..."
./gen-ca.sh -c ${CaCN} > /dev/null 2>&1
echo "Sign ${MasterCN}..."
./self-sign.sh -c ${MasterCN} > /dev/null 2>&1

mkdir ${OUT}

cp "./${CADIR}/"${CACRT} ./${OUT}/ &&  mv ./${OUT}/${CACRT}  ./${OUT}/${CaCN}".crt"
cp ${USERKEY}            ./${OUT}/ &&  mv ${OUT}/${USERKEY}  ./${OUT}/${MasterCN}".key"
cp ${USERCRT}            ./${OUT}/ &&  mv ${OUT}/${USERCRT}  ./${OUT}/${MasterCN}".crt"

echo "Sign ${PaasCN}..."
./self-sign.sh -c ${PaasCN} > /dev/null 2>&1
cp ${USERKEY}            ./${OUT}/ &&  mv ${OUT}/${USERKEY}  ./${OUT}/${PaasCN}".key"
cp ${USERCRT}            ./${OUT}/ &&  mv ${OUT}/${USERCRT}  ./${OUT}/${PaasCN}".crt"

rm -rf ${CADIR} ${CAREQ} ${USERCRT} ${USERKEY} ${USERREQ}
