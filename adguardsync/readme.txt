The playbook push2adg2.yaml does the following

1- delete all DNS rewrites in the backup/secondary AdGuard Home server
2- Push all DNS rewrite rules from your primary AdGuard home server to the backup/secondary AdGuard Home server

It may be disruptive if some of your devices on your network use the secondary AdGuard Home server for name resolution while this playbook is played.

Before using:

1- Create the file called secrets.yaml. Populate it with the credentials for your AdGuard Home servers (see secrets.yaml.txt)

2- optional if encrypting secrets.yaml:
   Create the file ~/.adguardhome. the first line should contain a secret word which will be used to encrypt your secrets.yaml file

3- optional if encrypting secrets.yaml:
   Encrypt your secrets.yaml file with ansible-vault encrypt secrets.yaml

4- edit the following variables in the push2adg2.yaml file
    adg1_url: "https://adguard1.lekerpont.fr/control"  # URL of your primary AdGuard Home server
    adg2_url: "https://adguard2.lekerpont.fr/control"  # URL of your secondary AdGuard Home Server

5- You can now run the push2adg2 playbook like this:

   $ ansible-playbook push2adg2.yaml


