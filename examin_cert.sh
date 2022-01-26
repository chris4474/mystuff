serial=$1
vault read --format=json intca/cert/$serial | jq -r .data.certificate | openssl x509 -text -noout | more
