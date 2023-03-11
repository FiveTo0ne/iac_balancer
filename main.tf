terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.72.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "yandex" {
  service_account_key_file = var.ya_key
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

provider "aws" {
  default_tags {
    tags = var.aws_tags
  }
  region     = var.aws_region
  access_key = var.aws_key
  secret_key = var.aws_s_key
}

data "yandex_vpc_subnet" "ya_sub" {
  name = "default-ru-central1-a"
}

data "aws_route53_zone" "primary" {
  name = var.primary
}
# locals {
#   ipv4 = yandex_compute_instance.vm-1-tf-07-.network_interface[0].ip_address
# }

resource "random_string" "ya_pass" {
  count            = length(var.devs.login)
  length           = 12
  special          = true
  override_special = false
}

resource "yandex_compute_instance" "vm-1-tf-07-t" {
  count       = length(var.devs.login)
  name        = "${var.vpc_name}-${count.index}"
  zone        = var.zone
  platform_id = var.platform
  labels      = var.ya_labels

  resources {
    cores  = 2
    memory = 2
  }
  boot_disk {
    initialize_params {
      image_id = "fd83n3uou8m03iq9gavu"
    }
  }

  network_interface {
    subnet_id = data.yandex_vpc_subnet.ya_sub.subnet_id
    nat       = true
  }
  # metadata = {
  #   ssh-keys = <<EOF
  #   "ubuntu:${var.ya_ssh}"
  #   "ubuntu:${var.priv_rsa}"
  #   EOF
  # }

  metadata = {
    ssh-keys = "ubuntu:${var.priv_rsa}"
  }

  connection {
    type        = "ssh"
    host        = self.network_interface[0].nat_ip_address
    user        = var.login
    private_key = file(var.ya_ssh_pr)
    #timeout     = "2m"
  }

    provisioner "remote-exec" {
    inline = [
      #"sleep 60",
      "echo 'ready'",
      "echo ${var.login}:${element(random_string.ya_pass.*.result, count.index)} | sudo chpasswd",
      # "yes ${random_string.ya_pass.*.result} | sudo passwd ${var.login}",
      "sudo sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication no/g' /etc/ssh/sshd_config",
      "sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config",
      "sudo systemctl restart ssh",
    ]
  }


}

resource "aws_route53_record" "www" {
  allow_overwrite = true
  count           = length(var.devs.login)
  zone_id         = data.aws_route53_zone.primary.zone_id
  name            = "${element(var.devs.login, count.index)}-${element(var.devs.prefix, count.index)}"
  #name    = "starovoytenko.${data.aws_route53_zone.primary.name}" 
  type    = var.dns_type
  ttl     = var.dns_ttl
  records = [yandex_compute_instance.vm-1-tf-07-t[count.index].network_interface[0].nat_ip_address]
}


resource "null_resource" "provision" {
  provisioner "local-exec" {
    command = "ansible-playbook -i ansible/hosts ansible/main.yml"
  }
  depends_on = [
    yandex_compute_instance.vm-1-tf-07-t,
    aws_route53_record.www
  ]
}



resource "local_file" "creds" {
  count = length(var.devs.login)
  content = templatefile("inventory.tpl", {
    fqdn   = aws_route53_record.www.*.fqdn,
    prefix = var.devs.prefix
    ipv4   = yandex_compute_instance.vm-1-tf-07-t[*].network_interface[0].nat_ip_address,
    pass   = random_string.ya_pass.*.result
    user   = var.login
    email  = var.email
  })
  filename = "ansible/hosts"
}
