env
cd /workspace
cat <<EOF
ansible-playbook ./playbooks/populate-db.yaml
  -e db_host=mariadb
  -e db_root_password=$DB_ROOT_PASSWORD
  -e target_db_name=$DB_NAME 
  -e target_db_user=$DB_USER
  -e target_db_pass=$DB_PASS
EOF

