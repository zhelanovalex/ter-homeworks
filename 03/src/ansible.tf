resource "local_file" "ansible_hosts" {
  content = templatefile( "./inventory.tftpl",
  { dbserv = yandex_compute_instance.platform_db,
    webserv = yandex_compute_instance.platform_web,
    storserv = [yandex_compute_instance.platform_storage] })
  filename = "hosts.ini"
}

