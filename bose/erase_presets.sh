if [ -z "$SOUNDTOUCH_IP" ]; then
    read -p "IP address of the Sounttouch you want to configure: " device_ip
else
    device_ip=$SOUNDTOUCH_IP
fi

device_name=$( curl -s http://{$device_ip}:8090/info |  grep -oP '(?<=<name>).*?(?=</name>)' )
if [ $? -ne 0 ]
then
    echo "Une erreur est survenue (code : $?) l'adresse n'est peut-%etre pas celle d'une enceinte Soundtouch"
    return 1
fi

read -t 10 -p "Are you sure you want to erase all presets for  $device_name ? Y,N [N] " answer
if [ "$answer" != "Y" ] && [ "$answer" != "y" ]
then
  echo Bye
  return 1
fi

echo Deleting $device_name presets

tmpfile=$(mktemp)
for i in 1 2 3 4 5 6
do
cat <<EOF > $tmpfile
  <preset id="${i}"> 
  </preset>
EOF
  curl -X POST "http://${device_ip}:8090/removePreset" -H 'Content-Type: application/xml' -d@${tmpfile} >/dev/null 2>&1
done


echo Verification
curl -s "http://${device_ip}:8090/presets" | python3 -c "
import sys, xmltodict, yaml
data = xmltodict.parse(sys.stdin.read())
print(yaml.dump(data, allow_unicode=True, sort_keys=False))
"
