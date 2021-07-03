# unir-c2
Caso Practico 2 - UNIR -


En este repositorio veremos como desplegar con Terraform en AZURE y como instalar con ANSIBLE un cluster de Kubernetes compuesto de los siguientes equipos

- Una maquina con rol de  Master
- Dos maquinas con roles de  Workers
- Una maquina para NFS

Definiremos FQDN
EJ
master.dominio.com
worker01.dominio.com
worker02.dominio.com
nfs.dominio.com

# Clonacion de repositorio
git clone https://github.com/maxigg10/unir-c2.git

# Instalacion az cli #

Debemos instalar el az cli  (en CentOS 8)
a)	Importamos la key del repositorio
rpm --import https://packages.microsoft.com/keys/microsoft.asc

b)	Creamos el fichero .repo

echo -e "[azure-cli]
name=Azure CLI
baseurl=https://packages.microsoft.com/yumrepos/azure-cli
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/azure-cli.repo

c)	Instalamos el cli
dnf install azure-cli

d) Login a azure
az login

e) Dentro de azure, vamos a suscripciones y copiamos el id

az account set --subscription=id_copiado_de_Azure

//Guardamos la salida del comando

f) Creacion del SERVICE PRINCIPAL

az ad sp create-for-rbac --role="Contributor"

//Guardamos la salida del comando

# Instalacion Terraform #
Para ejecutar el plan de terraform debemos tener instalado el cliente de terraform
https://www.terraform.io/docs/cli/install/yum.html

Debemos crear un fichero credentials.tf con el siguiente contenido


provider "azurerm" {

  features {}

  subscription_id = "id suscripcion entorno AZURE" 

  client_id       = "id client"

  client_secret   = "id password"

  tenant_id       = "id del tenant de Azure"

}


  subscription_id --> lo obtenemos del portal de azure en suscripciones

  client_id       --> lo obtenemos de la salida del service principal "name"

  client_secret   --> lo obtenemos de la salida del service principal "secret"

  tenant_id       --> lo obtenemos de la salida del service principal "tenant"


# Prerequisitos terraform #
Nos posicionamos dentro de la carpeta terraform del repositorio y realizamos


az vm image accept-terms --urn cognosys:centos-8-stream-free:centos-8-stream-free:1.2019.0810

az vm image terms show --urn cognosys:centos-8-stream-free:centos-8-stream-free:1.2019.0810


# Despliegue de la infraestructura de servidores en Azure con Terraform y despliegue de el cluster de Kubernetes con Ansible #
En la raiz del directorio hay un fichero llamado  deploy_All.sh

Este fichero lo que hace es lo siguiente

a) Ejecuta el plan de terraform para generar la maquinas virtuales
b) Realiza automaticamente la conexion y desconexion por ssh a las 4 maquinas desplegadas para aceptar la clave publica.
c) Nos preguntará si generamos las entradas con las IPs publicas y los hostname de las maquinas en nuestro archivo de Host.

Esto es necesario ya que no es posible que las maquinas reciban IP publica fija

Ejemplo Fichero: /etc/hosts


xx.xx.xx.xx master.ipxsistemas.com

xx.xx.xx.xx worker01.ipxsistemas.com

xx.xx.xx.xx worker02.ipxsistemas.com

xx.xx.xx.xxx nfs.ipxsistemas.com


Esta tarea no se puede omitir

d) Una vez hecho el paso anterior, tipeamos "si" (sin comillas) para iniciar el despliegue del cluster con Ansible

Esperamos hasta finalizar.

Nota: El plan de terraform tiene un usuario llamado maxigg y cada playbook se le indica el usuario maxigg para instalar el cluster
En caso de querer cambiar dicho usuario se debe hacer tanto en los ficheros de terraform como en las tareas de los roles.


