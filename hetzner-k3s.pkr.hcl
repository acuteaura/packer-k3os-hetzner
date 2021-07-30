variable "version" {
  type    = string
  default = "v0.20.7-k3s1r0"
}

locals {
  iso_url = "https://github.com/rancher/k3os/releases/download/${var.version}/k3os-amd64.iso"
  install_url = "https://raw.githubusercontent.com/rancher/k3os/${var.version}/install.sh"
  time = formatdate("YYYY-MM-DD-hh-mm-ss", timestamp())
}

variable "region" {
  type    = string
  default = "hel1"
}

source "hcloud" "recovery" {
  image       = "ubuntu-20.04"
  location    = "${var.region}"
  server_type = "cx11"
  snapshot_labels = {
    name    = "k3os"
    version = "${var.version}"
  }
  snapshot_name = "k3os-${var.version}-amd64-${local.time}"
  ssh_username  = "root"
  rescue = "linux64"
}

build {
  sources = ["source.hcloud.recovery"]

  provisioner "file" {
    destination = "/tmp/config.yaml"
    source      = "./config.yaml"
  }

  provisioner "shell" {
    inline = ["wget -O /tmp/install.sh \"${local.install_url}\"", "bash /tmp/install.sh --config /tmp/config.yaml /dev/sda \"${local.iso_url}\""]
  }
}
