/* Se comenta porque ya esta en correccion-vars.tf

variable "location" {
  type = string
  description = "Región de Azure donde crearemos la infraestructura"
  default = "West Europe"
}
*/

variable "vm_size" {
  type = string
  description = "Tamaño de la máquina virtual Master"
  #default = "Standard_D1_v2" # 3.5 GB, 1 CPU 
  default = "Standard_B2s" # 4 GB, 2 CPU   ## se utiliza esta instancia que ya necesitamos 2 vcore al menos para master
}

variable "vm_size2" {
  type = string
  description = "Tamaño de la máquina virtual Worker01"
  default = "Standard_D1_v2" # 3.5 GB, 1 CPU 
  
}
variable "vm_size3" {
  type = string
  description = "Tamaño de la máquina virtual Worker02"
  default = "Standard_D1_v2" # 3.5 GB, 1 CPU 
  
}
variable "vm_size4" {
  type = string
  description = "Tamaño de la máquina virtual NFS"
  #default = "Standard_B1s" # 1 GB, 1 CPU 
  default = "Standard_D1_v2" # 3.5 GB, 1 CPU
}