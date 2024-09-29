#!/bin/bash
if (( $# != 1 ))
then
  echo usage $0 node
  exit
fi
set -x
node=$1.symphorines.home
tmpdir=$(mktemp -d)

ttl_1day=$(( 60 * 60 * 24 ))
ttl_1year=$(( ttl_1day * 365 ))

vault write -tls-skip-verify  -format=json intca/issue/rolev1.0 common_name=${node} ttl=$ttl_1year alt_names=${node} >${tmpdir}/${node}.json

cat ${tmpdir}/${node}.json | jq -r .data.private_key  >${tmpdir}/key.pem
cat ${tmpdir}/${node}.json | jq -r .data.certificate  >${tmpdir}/cert.pem
cat ${tmpdir}/${node}.json | jq -r .data.ca_chain[0]  >${tmpdir}/intca.pem
cat ${tmpdir}/${node}.json | jq -r .data.ca_chain[1]  >${tmpdir}/ca.crt

cat ${tmpdir}/${node}.json | jq -r .data.certificate  >${tmpdir}/cert-plus-intca.pem
cat ${tmpdir}/${node}.json | jq -r .data.ca_chain[0] >>${tmpdir}/cert-plus-intca.pem


cat ${tmpdir}/${node}.json | jq -r .data.ca_chain[0]  >${tmpdir}/cachain.pem
cat ${tmpdir}/${node}.json | jq -r .data.ca_chain[1] >>${tmpdir}/cachain.pem

cat ${tmpdir}/${node}.json | jq -r .data.private_key  >${tmpdir}/key.pem
cat ${tmpdir}/${node}.json | jq -r .data.certificate >>${tmpdir}/fullchain.pem
cat ${tmpdir}/${node}.json | jq -r .data.ca_chain[0] >>${tmpdir}/fullchain.pem
cat ${tmpdir}/${node}.json | jq -r .data.ca_chain[1] >>${tmpdir}/fullchain.pem

tar -cvf ./certs/$node-bundle.tar --directory ${tmpdir} --remove-files .


