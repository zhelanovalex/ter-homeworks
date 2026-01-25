###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
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
  description = "VPC network&subnet name"
}

variable "vpc_sg_name" {
  type        = string
  default     = "neto_sg_dynamic"
  description = "VPC SG name"
}

variable "vms_storage_name" {
  type        = string
  default     = "stotage-neto"
  description = "VMS Storage name"
}

variable "vm_web_image_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "VM image family"
}

variable "vms_resources" {
  type = map(object({
    cores         = number
    memory        = number
    core_fraction = number
    bdisksize      = number
    bdisktype     = string
    platid        = string
  }))
  default = {
    web = {
      cores         = 2
      memory        = 1
      core_fraction = 5
      bdisksize     = 1
      bdisktype     = "network-hdd"
      platid        = "standard-v2"
    }
    db = {
      cores         = 2
      memory        = 2
      core_fraction = 20
      bdisksize     = 1
      bdisktype     = "network-hdd"
      platid        = "standard-v2"
    }
  }
}
variable "vms_metadata" {
  type = map(object({
    sport           = number
  }))
  default = {
    metassh= {
      sport         = 1
    }
  }
}

variable "vms_db" {
  type = list(object({
    db_name       = string
    cores         = number
    memory        = number
    core_fraction = number
    bdisksize      = number
    bdisktype     = string
    platid        = string
  }))
  default = [
    {
      db_name       = "main-neto"
      cores         = 4
      memory        = 4
      core_fraction = 50
      bdisksize     = 15
      bdisktype     = "network-hdd"
      platid        = "standard-v2"
    },
    {
      db_name       = "replica-neto"
      cores         = 2
      memory        = 2
      core_fraction = 20
      bdisksize     = 12
      bdisktype     = "network-hdd"
      platid        = "standard-v2"
    }
  ]
}
