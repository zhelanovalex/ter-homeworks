data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_image_family
}

resource "yandex_compute_instance" "platform_web" {
  count       = 2
  name        = "web-0${count.index + 1}"
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
    security_group_ids = [yandex_vpc_security_group.neto_example.id]
  }
  metadata = {
    serial-port-enable = var.vms_metadata["metassh"].sport
    ssh-keys           = local.pub-key
  }
  depends_on = [yandex_compute_instance.platform_db]
}

