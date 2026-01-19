output "instances_terms" {
  value  =  [
    { web_instance_fqdn = yandex_compute_instance.platform.fqdn , web_instance_name = yandex_compute_instance.platform.name , web_instance_external_ip = yandex_compute_instance.platform.network_interface[0].nat_ip_address , db_instance_fqdn = yandex_compute_instance.platform_db.fqdn , db_instance_name = yandex_compute_instance.platform_db.name , db_instance_external_ip = yandex_compute_instance.platform_db.network_interface[0].nat_ip_address}
  ]
}
