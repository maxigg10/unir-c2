#!/bin/bash
ansible-playbook -i hosts 01-playbook_requirements.yaml
sleep 3m
ansible-playbook -i hosts 02-playbook_NFS_installation.yaml
ansible-playbook -i hosts 03-playbook_Master_Workers_commonTasks.yaml
ansible-playbook -i hosts 04-playbook_Master_Configuration.yaml
ansible-playbook -i hosts 05-playbook_Workers_Configuration.yaml
ansible-playbook -i hosts 06-playbook_Deploy_App.yaml
