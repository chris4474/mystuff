env
exit
cd /workspace
echo Cur dir is $PWD
ls -l ./playbooks/populate_db.yaml
ansible-playbook ./playbooks/populate-db.yaml
  -e db_host=mariadb
  -e db_root_password=\$DB_ROOT_PASSWORD
  -e target_db_name=$NEW_DB_NAME 
  -e target_db_user=$NEW_DB_USER
  -e target_db_pass=$NEW_DB_PASS


