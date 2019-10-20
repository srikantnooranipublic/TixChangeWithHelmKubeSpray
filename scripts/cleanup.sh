helm delete tixchange --purge
helm delete uma --purge
ansible-playbook -b --become-user=root -v -i  inventory/mycluster/hosts.yml --user=root reset.yml --flush-cache

# 1019  pip install --upgrade --force-reinstall pip==9.0.3
 #1020  pip install requests --disable-pip-version-check
 #1021  pip upgrade requests --disable-pip-version-check
 #1022  pip uninstall requests --disable-pip-version-check
 #1023  pip install --upgrade pip
