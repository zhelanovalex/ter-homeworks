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
  name        = var.vm_web_instance_name
  platform_id = "standard-v2"
  resources {
    cores         = 2
    memory        = 1
    core_fraction = 5
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

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }
}
resource "yandex_compute_instance" "platform_db" {
  name        = var.vm_db_instance_name
  provider      = yandex.zone_b
  zone          = var.vm_zones_b
  platform_id = "standard-v2"
  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
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
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }
}
