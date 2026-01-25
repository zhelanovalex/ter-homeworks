resource "yandex_compute_instance" "platform_db" {
  for_each = { for i, wms in var.vms_db : i => wms }
  name        = each.value.db_name
  platform_id = each.value.platid
  resources {
    cores         = each.value.cores
    memory        = each.value.memory
    core_fraction = each.value.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = each.value.bdisksize
      type     = each.value.bdisktype
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
    serial-port-enable = var.vms_metadata["metassh"].sport
    ssh-keys           = local.pub-key
  }
}

