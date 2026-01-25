resource "yandex_compute_disk" "neto_multidisks" {
  count = 3
  name = "neto-disk-0${count.index + 1}" 
  type = var.vms_resources["web"].bdisktype
  zone = var.default_zone
  size = var.vms_resources["web"].bdisksize
}
resource "yandex_compute_instance" "platform_storage" {
  name        = var.vms_storage_name
  platform_id = var.vms_resources["web"].platid
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
  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.neto_multidisks
    content {
      disk_id = secondary_disk.value.id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
#    security_group_ids = [yandex_vpc_security_group.neto_example.id]
  }
  metadata = {
    serial-port-enable = var.vms_metadata["metassh"].sport
    ssh-keys           = local.pub-key
  }
#  depends_on = [yandex_compute_instance.platform_db]
}
