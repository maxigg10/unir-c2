#!/bin/bash
cd ./terraform/
terraform init
terraform validate
terraform apply
