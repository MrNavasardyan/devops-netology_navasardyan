#https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_network
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
  #backend "s3" {
   #  endpoint   = "storage.yandexcloud.net"
    # bucket     = "tf-state-bucket-gnavasardyan"
     #region     = "ru-central1-a"
     #key        = "terraform/infrastructure1/terraform.tfstate"
     #access_key = "YCAJEPie5HNBklZlGOmrxRkY6"
     #secret_key = "YCNP8puzHOBgiyOg1AYRGzWEhS71m1oxoksO2-yv"

     #skip_region_validation      = true
     #skip_credentials_validation = true
  #}
}

provider "yandex" {
  token     = var.token_auth
  cloud_id  = var.cloud_id
  folder_id = var.yandex_folder_id
  zone      = var.zone
}

resource "yandex_compute_instance" "vm-1" {
  name = "terraform1"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd86ca997krgb6vcroqm"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

#locals {
#  instance = {
#  stage = 1
#  prod = 2
#  }
#}

#resource "yandex_compute_instance" "vm-count" {
#  name = "vm-${count.index}-${terraform.workspace}"

#  resources {
#        cores = "2"
#        memory = "2"
#  }

#  boot_disk {
#    initialize_params {
#      image_id = "fd86ca997krgb6vcroqm"
#    }
#  }

#    metadata = {
#    ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
#  }


#  network_interface {
#    subnet_id = yandex_vpc_subnet.subnet-1.id
#    nat       = true
#  }

#  count = local.instance[terraform.workspace]
#}


output "internal_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.ip_address
}

output "external_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
}


locals {
  id = toset([
    "1",
    "2",
  ])
}

resource "yandex_compute_instance" "vm-for" {
  for_each = local.id
  name = "vm-${each.key}-${terraform.workspace}"

  resources {
    cores  = "2"
    memory = "2"
  }

  boot_disk {
    initialize_params {
      image_id = "fd86ca997krgb6vcroqm"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }
}
