#!/bin/bash
echo  "Despues de desplegar TERRAFORM debemos agregar las IPs publicas de AZURE en el archivo de hosts "
echo ""
echo "-----------------------"
echo  "Desplegando TERRAFORM"
echo "-----------------------"
#sh ./terraform/apply_terraform.sh

echo ""

echo "Agregaste las IPs al archivo de hosts y te conectaste a las maquinas? (si/no):   "
read respuesta

echo  " "
echo "Debemos conectarnos a cada hosts"
echo "ssh maxigg@master.ipxsistemas.com"
echo " "
ssh -o "StrictHostKeyChecking no" maxigg@master.ipxsistemas.com << EOF
 exit
EOF
echo ""
echo  "ssh maxigg@worker01.ipxsistemas.com"
echo  " "
ssh -o "StrictHostKeyChecking no" maxigg@worker01.ipxsistemas.com << EOF
 exit
EOF
echo""
echo  "ssh maxigg@worker02.ipxsistemas.com"
echo  " "
ssh -o "StrictHostKeyChecking no" maxigg@worker02.ipxsistemas.com << EOF
 exit
EOF
echo ""
echo  "ssh maxigg@nfs.ipxsistemas.com"
echo  " "
ssh -o "StrictHostKeyChecking no" maxigg@nfs.ipxsistemas.com << EOF
 exit
EOF
echo ""
case $respuesta in

  si)
    echo "*****************"   
    echo  "Desplegando ANSIBLE"
    echo "*****************"
    sh ./ansible/deploy_ansible.sh
    ;;

  no)
    echo  "No se ejecuta nada"
    exit
    ;;


  *)
    exit
    ;;
esac

