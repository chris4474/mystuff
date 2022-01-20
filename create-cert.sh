#!/bin/bash
if (( $# != 1 ))
then
  echo usage $0 node
  exit
fi
node=$1.symphorines.home
tmpdir=$(mktemp -d)

vault write -format=json intca/issue/symphorines common_name=${node} alt_names=${node} >${tmpdir}/${node}.json

cat ${tmpdir}/${node}.json | jq -r .data.private_key  >${tmpdir}/key.pem
cat ${tmpdir}/${node}.json | jq -r .data.ca_chain[0]  >${tmpdir}/cert-plus-intca.pem
cat ${tmpdir}/${node}.json | jq -r .data.certificate >>${tmpdir}/cert-plus-intca.pem
cat ${tmpdir}/${node}.json | jq -r .data.ca_chain[1]  >${tmpdir}/ca.crt
cat ${tmpdir}/${node}.json | jq -r .data.certificate  >${tmpdir}/cert.pem

tar -cvf $node-bundle.tar --directory ${tmpdir} --remove-files .


