#!/bin/bash
cd ./ansible/
ansible-playbook -i hosts -u maxigg 01-playbook_requirements.yaml
echo "Esperamos 2 minutos para que reinicien las maquinas virtuales"
sleep 2m
ansible-playbook -i hosts -u maxigg 02-playbook_NFS_installation.yaml
ansible-playbook -i hosts -u maxigg 03-playbook_Master_Workers_commonTasks.yaml
ansible-playbook -i hosts -u maxigg 04-playbook_Master_Configuration.yaml
ansible-playbook -i hosts -u maxigg 05-playbook_Workers_Configuration.yaml
