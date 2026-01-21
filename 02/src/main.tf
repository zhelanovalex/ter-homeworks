resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}

resource "yandex_vpc_subnet" "develop-b" {
  name           = var.vpc_b_name
  zone           = var.vm_zones_b
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.zone_b_cidr
}

data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_image_family
}
data "yandex_compute_image" "ubuntu_db" {
  family = var.vm_db_image_family
}
resource "yandex_compute_instance" "platform" {
  name        = local.vm_web_instance
  platform_id = "standard-v2"
  resources {
    cores         = var.vms_resources["web"].cores
    memory        = var.vms_resources["web"].memory
    core_fraction = var.vms_resources["web"].core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }
/*
  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }
*/
  metadata = {
    serial-port-enable = var.vms_metadata["metassh"].sport
    ssh-keys           = var.vms_metadata["metassh"].skeys
  }
}
resource "yandex_compute_instance" "platform_db" {
  name        = local.vm_db_instance
  provider      = yandex.zone_b
  zone          = var.vm_zones_b
  platform_id = "standard-v2"
  resources {
    cores         = var.vms_resources["db"].cores
    memory        = var.vms_resources["db"].memory
    core_fraction = var.vms_resources["db"].core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop-b.id
    nat       = true
  }

  metadata = {
    serial-port-enable = var.vms_metadata["metassh"].sport
    ssh-keys           = var.vms_metadata["metassh"].skeys
  }
}
