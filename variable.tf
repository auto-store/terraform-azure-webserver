variable "resource_group" {
    description = "define name of resource group"
}

variable "location" {
    description = "resource group location" 
}

variable "public_network" {
    description = "name of the public network"
}

variable "instance_name {
    description = "name of the instance"
}

variable "instance_size" {}

variable "admin" {
    description = "admin username for server"
}

variable "password" {
    description = "password for instance"
}
