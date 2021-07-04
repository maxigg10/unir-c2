
# Despliegue del Cluster de Kubernetes con Ansible en un entorno Local #

Prerequisitos
* Disponer de un entorno con 4 maquinas con la siguiente configuracion minima

Master
CPU: 2
RAM: 2gb
Disco: 15gb
FQDN: master.ipxsistemas.com.ar (puede ser cualquier otro). En caso de cambiarlo se debe modificar en los distintos ficheros
IP: 192.168.0.3

Worker01
CPU: 2
RAM: 2gb
Disco: 15gb
FQDN: worker01.ipxsistemas.com.ar (puede ser cualquier otro). En caso de cambiarlo se debe modificar en los distintos ficheros
IP: 192.168.0.4

Worker02
CPU: 2
RAM: 2gb
Disco: 15gb
FQDN: worker02.ipxsistemas.com.ar (puede ser cualquier otro). En caso de cambiarlo se debe modificar en los distintos ficheros
IP: 192.168.0.5

NFS
CPU: 2
RAM: 2gb
Disco: 15gb
FQDN: nfs.ipxsistemas.com.ar (puede ser cualquier otro). En caso de cambiarlo se debe modificar en los distintos ficheros
IP: 192.168.0.6

* Crear un par de claves SSH en el entorno desde donde lancen los playbook de Ansible. Copiar la clave publica los servidores
ssh-keygen
ssh-copy-id -i /home/maxigg/.ssh/id_rsa.pub maxigg@master.ipxsistemas.com.ar
ssh-copy-id -i /home/maxigg/.ssh/id_rsa.pub maxigg@worker01.ipxsistemas.com.ar
ssh-copy-id -i /home/maxigg/.ssh/id_rsa.pub maxigg@worker02.ipxsistemas.com.ar
ssh-copy-id -i /home/maxigg/.ssh/id_rsa.pub maxigg@nfs.ipxsistemas.com.ar

* Crear un archivo de hosts en el entorno desde donde lacen los playbook de Ansible
vim /etc/hosts


192.168.0.3 master.ipxsistemas.com.ar
192.168.0.4 worker01.ipxsistemas.com.ar
192.168.0.5 worker02.ipxsistemas.com.ar
192.168.0.6 nfs.ipxsistemas.com.ar

* En cada maquina hacer que el usuario con el que se conecten a SSH (en este ejemplo maxigg), este en el sudoers

vim /etc/sudoers
maxigg ALL=(ALL) NOPASSWD:ALL

* Ejecutar playbooks

En la raiz del directorio ansible.local.roles encontramos el script

deploy.sh

El mismo esta compuesto por las siguientes lineas 
///
#!/bin/bash
ansible-playbook -i hosts 01-playbook_requirements.yaml
sleep 3m
ansible-playbook -i hosts 02-playbook_NFS_installation.yaml
ansible-playbook -i hosts 03-playbook_Master_Workers_commonTasks.yaml
ansible-playbook -i hosts 04-playbook_Master_Configuration.yaml
ansible-playbook -i hosts 05-playbook_Workers_Configuration.yaml
///
Entre el primer playbook y el segundo hay un sleep de 3 min, es para que nos de tiempo en que las maquinas
se reinicien antes de lanzar el segundo playbook

Cada playbook esta formado por esta estructura


- name: Requirements
  hosts: all
  become: yes
  roles:
    - 1-requirements


En la cual tenemos
* name: Seteamos un nombre descriptivo al playbook
* hosts: Especificamos a que servidor o grupo de servidores le lanzaremos el playbook. Estos tags estan en el fichero hosts (inventario). El tag "all" aplica a todos
* become: Le indicamos que escale privilegios
* roles: Aplicamos el rol que esta compuesto entre otras cosas por tareas.

Para saber cuales son las tareas de dicho rol, debemos ir al directorio roles/1-requirements/task

Dentro del mismo encontraremos ficheros yaml donde se describen las tareas y un fichero main.yaml donde
incluiremos a cada grupo de tareas que pueden ser uno a mas ficheros yaml.

* Explicacion extra

Encontraremos varios ficheros yaml dentro del directorio "custom_files", los mismos se dejan dentro del repositorio
para evitar tener que descargarlos nuevamente y que estos ya no se encuentren disponibles

Ademas en la raiz de la carpeta encontraremos estos 3 ficheros

join-command: Aqui se guardara automaticamente un token para unir los workers con el master
kubectl.txt: Aqui nos imprimirá los puertos del ingress controller
hosts: Es nuestro fichero de inventario de hosts
vars: Es un ejemplo para definir variables, no se ha utilizado.
