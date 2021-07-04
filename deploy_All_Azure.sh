#!/bin/bash
echo -n "Despues de desplegar TERRAFORM debemos agregar las IPs publicas de AZURE en el archivo de hosts"
echo -n "-------------------------------------"
echo -n "-------------------------------------"
echo -n "Desplegando TERRAFORM"
sh ./terraform/deploy_terraform.sh

echo -n ""
echo -n "Debemos conectarnos a cada hosts"
echo -n "ssh maxigg@master.ipxsistemas.com"
ssh -o "StrictHostKeyChecking no" maxigg@master.ipxsistemas.com << EOF
 exit
EOF
echo -n "ssh maxigg@worker01.ipxsistemas.com"
ssh -o "StrictHostKeyChecking no" maxigg@worker01.ipxsistemas.com << EOF
 exit
EOF
echo -n "ssh maxigg@worker02.ipxsistemas.com"
ssh -o "StrictHostKeyChecking no" maxigg@worker02.ipxsistemas.com << EOF
 exit
EOF

echo -n "ssh maxigg@nfs.ipxsistemas.com"
ssh -o "StrictHostKeyChecking no" maxigg@nfs.ipxsistemas.com << EOF
 exit
EOF


echo -n "Agregaste las IPs al archivo de hosts y te conectaste a las maquinas? (si/no):   "
read respuesta
case $respuesta in

  si)
    echo -n "Desplegando ANSIBLE"
    sh ./ansible/deploy_ansible.sh
    ;;

  no)
    echo -n "No se ejecuta nada"
    exit
    ;;


  *)
    exit
    ;;
esac

