#!/bin/bash

# añadir tantas líneas como sean necesarias para el correcto despligue
ansible-playbook -i hosts 01-playbook_requirements.yamlÇ
sleep (60)
ansible-playbook -i hosts 02-playbook_NFS_installation.yaml
ansible-playbook -i hosts 03-playbook_Master_Workers_commonTasks.yaml
ansible-playbook -i hosts 04-playbook_Master_Configuration.yaml
ansible-playbook -i hosts 05-playbook_Workers_Configuration.yaml
