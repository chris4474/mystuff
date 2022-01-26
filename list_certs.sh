#!/bin/bash

function prompt ()
{
  answer=""
  while [[ $answer != "Y" && $answer != "N" ]]
  do
    read -p "$1" answer
    answer=${answer^^}
    if [[ $answer = "" ]] ; then answer="N" ; fi
    case $answer in
      "Y" )
        answer="Y"
        ;;
      "N" )
        answer="N"
        ;;
      *)
        answer=""
    esac
  done
  echo $answer
}

certs=$(vault list --format json intca/certs/ | jq -r .[])
for cert in $certs
do
  revocation_time=$(vault read --format json intca/cert/$cert | jq -r .data.revocation_time )
  if [[ $revocation_time = "0" ]]
  then
    subject=$(vault read --format json intca/cert/$cert | jq -r .data.certificate | openssl x509 -text -noout | grep Subject\:)
    subject=$(echo $subject)
    echo "$cert $subject"
  fi
done
