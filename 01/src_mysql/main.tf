terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
    }
  }
  required_version = ">1.14.0" /*Многострочный комментарий.
 Требуемая версия terraform */
}

provider "docker" {
  host = "ssh://root@neto2:22"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null"]
}

resource "random_password" "mysql_root_pass" {
  length      = 16
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}

resource "random_password" "mysql_pass" {
  length      = 16
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}

resource "docker_image" "mysql_im" {
  name         = "mysql:8"
  keep_locally = true
}

resource "docker_container" "mysql" {
  image = docker_image.mysql_im.image_id
  name  = "mysql_db_neto"
  restart = "unless-stopped"

  env = [
    "MYSQL_ROOT_PASSWORD=${random_password.mysql_root_pass.result}", 
    "MYSQL_DATABASE=neto_db", 
    "MYSQL_USER=neto_user", 
    "MYSQL_PASSWORD=${random_password.mysql_pass.result}" 
  ]

  ports {
    internal = 3306
    external = 3306
  }
}
