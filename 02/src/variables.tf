###cloud vars


variable "cloud_id" {
  type        = string
  default     = "b1goe5r76g9fptfhp9po"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  default     = "b1gq8s97k9ikht5vcsi4"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}

variable "vm_web_instance_name" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "VM instance name"
}

variable "vm_web_image_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "VM image family"
}
/*
###ssh vars

variable "vms_ssh_root_key" {
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEoPKcv9/oVqeP2irzonN4rB1GCChuDsTaledNpkcEpe root@Uglycomp"
  description = "ssh-keygen -t ed25519"
}
*/
variable "vms_resources" {
  type = map(object({
    cores         = number
    memory        = number
    core_fraction = number
  }))
  default = {
    web = {
      cores         = 2
      memory        = 1
      core_fraction = 5
    }
    db = {
      cores         = 2
      memory        = 2
      core_fraction = 20
    }
  }
}
variable "vms_metadata" {
  type = map(object({
    sport           = number
    skeys           = string
  }))
  default = {
    metassh= {
      sport         = 1
      skeys         = "ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEoPKcv9/oVqeP2irzonN4rB1GCChuDsTaledNpkcEpe root@Uglycomp"
    }
  }
}
