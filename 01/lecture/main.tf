terraform {
  required_providers {}
  required_version = ">1.14.0"
}

resource "random_password" "neto_test_name" {
  length = 16
}

resource "local_file" "from_resourse" {
  content  = random_password.neto_test_name.result
  filename = "/tmp/from_resource_neto.txt"
}




data "local_file" "version" {
  filename = "/proc/version"
}

resource "local_file" "from_dataversion" {
  content  = data.local_file.version.content
  filename = "/tmp/from_data_source_version_neto.txt"
}

data "local_file" "list_hosts" {
  filename = "/etc/hosts"
}

resource "local_file" "from_datahosts" {
  content  = data.local_file.list_hosts.content
  filename = "/tmp/from_data_source_hosts_neto.txt"
}

