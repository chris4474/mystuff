#!/bin/bash
if (( $# != 1 ))
then
  echo usage $0 user
  exit
fi
set -x
user=$1
tmpdir=$(mktemp -d)

ttl_1day=$(( 60 * 60 * 24 ))
ttl_1year=$(( ttl_1day * 365 ))

vault write -tls-skip-verify  -format=json intca/issue/userv1.0 common_name=${user} ttl=$ttl_1year >${tmpdir}/${user}.json

cat ${tmpdir}/${user}.json | jq -r .data.private_key  >${tmpdir}/key.pem
cat ${tmpdir}/${user}.json | jq -r .data.certificate  >${tmpdir}/cert.pem
cat ${tmpdir}/${user}.json | jq -r .data.ca_chain[0]  >${tmpdir}/intca.pem
cat ${tmpdir}/${user}.json | jq -r .data.ca_chain[1]  >${tmpdir}/ca.crt

cat ${tmpdir}/${user}.json | jq -r .data.certificate  >${tmpdir}/cert-plus-intca.pem
cat ${tmpdir}/${user}.json | jq -r .data.ca_chain[0] >>${tmpdir}/cert-plus-intca.pem


cat ${tmpdir}/${user}.json | jq -r .data.ca_chain[0]  >${tmpdir}/cachain.pem
cat ${tmpdir}/${user}.json | jq -r .data.ca_chain[1] >>${tmpdir}/cachain.pem

cat ${tmpdir}/${user}.json | jq -r .data.private_key  >${tmpdir}/key.pem
cat ${tmpdir}/${user}.json | jq -r .data.certificate >>${tmpdir}/fullchain.pem
cat ${tmpdir}/${user}.json | jq -r .data.ca_chain[0] >>${tmpdir}/fullchain.pem
cat ${tmpdir}/${user}.json | jq -r .data.ca_chain[1] >>${tmpdir}/fullchain.pem

tar -cvf ./certs/$user-bundle.tar --directory ${tmpdir} --remove-files .


