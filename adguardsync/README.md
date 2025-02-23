# Purpose
The playbook push2adg2.yaml does the following:
1.   delete all DNS rewrites in the backup/secondary AdGuard Home server
1. Push all DNS rewrite rules from your primary AdGuard home server to the backup/secondary AdGuard Home server

It may be disruptive if some of your devices on your network use the secondary AdGuard Home server for name resolution while this playbook is played.

# Preparations

1. Copy `secrets.yaml.tpl` to `secrets.yaml`. Edit `secrets.yaml`, populating the user/password variables. Save you changes.

2. Recommended. encrypt `secrets.yaml`

	2a. Create the file `~/.adguardhome`. the first line should contain a secret word which will be used to encrypt your `secrets.yaml` file
	
	2b. Encrypt your `secrets.yaml` file with `ansible-vault encrypt secrets.yaml`

3. edit the file `hosts`. Make sure you specify the URL of your primary and secondary AdGuard Home servers. You may populate the exceptions list with rewrite rules you don't want the playbook to touch/delete.

# Run the playbook
You can now run the `push2adg2.yaml` playbook like this:

> $ ansible-playbook push2adg2.yaml

