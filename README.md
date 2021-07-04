# unir-c2
Caso Practico 2 - UNIR -


En este repositorio veremos como desplegar con Terraform en AZURE y como instalar con ANSIBLE un cluster de Kubernetes compuesto de los siguientes equipos

- **Una maquina con rol de  Master**
- **Dos maquinas con roles de  Workers**
- **Una maquina para NFS**

**Definiremos FQDN**
```
EJ

master.dominio.com
worker01.dominio.com
worker02.dominio.com
nfs.dominio.com
```


# Clonacion de repositorio

**git clone https://github.com/maxigg10/unir-c2.git**

# Instalacion az cli #

Debemos instalar el az cli  (en CentOS 8)
a)	Importamos la key del repositorio

**rpm --import https://packages.microsoft.com/keys/microsoft.asc**

b)	Creamos el fichero .repo

```
echo -e "[azure-cli]
name=Azure CLI
baseurl=https://packages.microsoft.com/yumrepos/azure-cli
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/azure-cli.repo
```
c)	Instalamos el cli

**dnf install azure-cli**

d) Login a azure

**az login**

e) Dentro de azure, vamos a suscripciones y copiamos el id

**az account set --subscription=id_copiado_de_Azure**

//Guardamos la salida del comando

f) Creacion del SERVICE PRINCIPAL

**az ad sp create-for-rbac --role="Contributor"**

//Guardamos la salida del comando

# Instalacion Terraform #
Para ejecutar el plan de terraform debemos tener instalado el cliente de terraform
**https://www.terraform.io/docs/cli/install/yum.html**

Debemos crear el fichero **credentials.tf** dentro del directorio terraform con el siguiente contenido

**Este fichero esta dentro del .gitignore para no hacer publicas las credenciales**

```
provider "azurerm" {

  features {}

  subscription_id = "id suscripcion entorno AZURE" 

  client_id       = "id client"

  client_secret   = "id password"

  tenant_id       = "id del tenant de Azure"

}
```

  **subscription_id** --> lo obtenemos del portal de azure en suscripciones

  **client_id**       --> lo obtenemos de la salida del service principal "name"

  **client_secret**   --> lo obtenemos de la salida del service principal "secret"

  **tenant_id**       --> lo obtenemos de la salida del service principal "tenant"


# Prerequisitos terraform #
Nos posicionamos dentro de la carpeta terraform del repositorio y realizamos


**az vm image accept-terms --urn cognosys:centos-8-stream-free:centos-8-stream-free:1.2019.0810**

**az vm image terms show --urn cognosys:centos-8-stream-free:centos-8-stream-free:1.2019.0810**


# Despliegue de la infraestructura de servidores en Azure con Terraform y despliegue del cluster de Kubernetes con Ansible #

Los dos directorios que utilizaremos para realizar esta tarea es

```
- ansible
- terraform
```


Dentro de cada uno de ellos se encuentra el codigo y las tareas para realizar el despliegue.

En la raiz del directorio hay un fichero llamado  **deploy_All_Azure.sh**

Este fichero lo que hace es lo siguiente:

a) Ejecuta el plan de terraform para generar la maquinas virtuales.
b) Realiza automaticamente la conexion y desconexion por ssh a las 4 maquinas desplegadas para aceptar la clave publica.
c) Nos preguntará si generamos las entradas con las IPs publicas y los hostname de las maquinas en nuestro archivo de Host.

Esto es necesario ya que no es posible que las maquinas reciban IP publica fija

Debemos agregar a nuestro archivo de hosts las IPs / Dominios de nuestras maquinas

Ejemplo Fichero: **/etc/hosts**

```
xx.xx.xx.xx master.ipxsistemas.com

xx.xx.xx.xx worker01.ipxsistemas.com

xx.xx.xx.xx worker02.ipxsistemas.com

xx.xx.xx.xxx nfs.ipxsistemas.com
```

Tanto en el plan de terraform como en las tareas de ansible, se ha seteado con el dominio propuesto **ipxsistemas.com**

En caso de modificarlo, es necesario repasar todos los ficheros y cambiar las ocurrencias por el dominio que prefieran.

**Esta tarea no se puede omitir**

d) Una vez hecho el paso anterior, tipeamos "**si**" (sin comillas) para iniciar el despliegue del cluster con Ansible

Esperamos hasta finalizar.

**Nota**: El plan de terraform tiene la creacion de un usuario llamado **maxigg** para que con ansible nos podamos conectar por ssh y realizar las tareas de despligue. Este usuario se puede modificar pero es necesario cambiar las ocurrencias en los ficheros de terraform y ansible. 


Una vez explicado lo que realiza el script, con solo ejecutarlo nos creara toda infraestructura en Azure y desplegara Kubernetes

```
./deploy_All_Azure.sh
```

# Explicacion extra de ansible



Cada playbook esta formado por esta estructura

```
- name: Requirements
  hosts: all
  become: yes
  roles:
    - 1-requirements
```

En la cual tenemos
* **name**: Seteamos un nombre descriptivo al playbook
* **hosts**: Especificamos a que servidor o grupo de servidores le lanzaremos el playbook. Estos tags estan en el fichero hosts (inventario). El tag "all" aplica a todos
* **become**: Le indicamos que escale privilegios
* **roles**: Aplicamos el rol que esta compuesto entre otras cosas por tareas. Este nombre coincide con un directorio llamado igual dentro del directorio *roles/task*

Para saber cuales son las tareas de dicho rol, debemos ir al directorio **roles/1-requirements/task**

Dentro del mismo encontraremos ficheros yaml donde se describen las tareas y un fichero **main.yaml** donde
incluiremos a cada grupo de tareas que pueden ser uno a mas ficheros yaml.

En el mismo directorio **ansible**  encontraremos varios ficheros yaml dentro del directorio **custom_files**, los mismos se dejan dentro del repositorio para evitar tener que descargarlos nuevamente y que estos ya no se encuentren disponibles.

Ademas en la raiz de la carpeta encontraremos estos 4 ficheros

* **join-command**: Aqui se guardara automaticamente un token para unir los workers con el master
* **kubectl.txt**: Aqui nos imprimirá los puertos del ingress controller
* **hosts**: Es nuestro fichero de inventario de hosts
* **vars**: Es un ejemplo para definir variables, no se ha utilizado.



