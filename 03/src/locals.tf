locals {
  ssh-key = file("~/.ssh/id_ed25519.pub")
  pub-key = "ubuntu:${local.ssh-key}"
}

