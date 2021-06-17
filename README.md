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

# Ejecucion plan terraform #
Nos posicionamos dentro de la carpeta terraform del repositorio y realizamos


az vm image accept-terms --urn cognosys:centos-8-stream-free:centos-8-stream-free:1.2019.0810
az vm image terms show --urn cognosys:centos-8-stream-free:centos-8-stream-free:1.2019.0810

El primer comando es para aceptar los terminos de uso de la imagen que tenemos en el plan de terraform. Es un Centos-8-stream-free

Despues realizamos lo siguiente


terraform init
terraform validate
terraform apply

Para destruir el entorno hacemos
terraform destroy