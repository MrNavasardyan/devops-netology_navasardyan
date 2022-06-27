# Домашнее задание к занятию "7.3. Основы и принцип работы Терраформ"

## Задача 1. Создадим бэкэнд в S3 (необязательно, но крайне желательно).

Если в рамках предыдущего задания у вас уже есть аккаунт AWS, то давайте продолжим знакомство со взаимодействием
терраформа и aws. 

1. Создайте s3 бакет, iam роль и пользователя от которого будет работать терраформ. Можно создать отдельного пользователя,
а можно использовать созданного в рамках предыдущего задания, просто добавьте ему необходимы права, как описано 
[здесь](https://www.terraform.io/docs/backends/types/s3.html).
1. Зарегистрируйте бэкэнд в терраформ проекте как описано по ссылке выше. 


## Задача 2. Инициализируем проект и создаем воркспейсы. 

1. Выполните `terraform init`:
    * если был создан бэкэнд в S3, то терраформ создат файл стейтов в S3 и запись в таблице 
dynamodb.
    * иначе будет создан локальный файл со стейтами.  
1. Создайте два воркспейса `stage` и `prod`.
1. В уже созданный `aws_instance` добавьте зависимость типа инстанса от вокспейса, что бы в разных ворскспейсах 
использовались разные `instance_type`.
1. Добавим `count`. Для `stage` должен создаться один экземпляр `ec2`, а для `prod` два. 
1. Создайте рядом еще один `aws_instance`, но теперь определите их количество при помощи `for_each`, а не `count`.
1. Что бы при изменении типа инстанса не возникло ситуации, когда не будет ни одного инстанса добавьте параметр
жизненного цикла `create_before_destroy = true` в один из рессурсов `aws_instance`.
1. При желании поэкспериментируйте с другими параметрами и рессурсами.

В виде результата работы пришлите:
* Вывод команды `terraform workspace list`.
* Вывод команды `terraform plan` для воркспейса `prod`.  


```
[root@node-2 terraform_new]# terraform workspace list
  default
* prod
  stage

[root@node-2 terraform_new]# terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_instance.first-1 will be created
  + resource "yandex_compute_instance" "first-1" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                centos:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC4jG916sng1R9lP3RlHVm3NrLq/xbVtOpZIINZjpiu1HysO4eHozhjOBMX1r4F+NobVeMWWNlw3rN6I2HuBGFQJBabAx3STmx/c6PiZFc5AY7zURuCcl/4lHS5I3/mphrxPmVmQ/qf+kYVBo27ZpcDAZBofka4SfbovYgx59e0jOLN6/bMhAjkXj0vw46Y3qcaNBu+RZhTF/Dbx4T8efVUxnb+f/wM6/SEoVo9AlDtJ3Mn9Rq6QylbgCWoKvtqPt+Hjz+IAWqDP8FBwQEcTdBut97+uA/e6JGzaiMz1yfbiXrPadlUr8azQI6YAhx9JA5rvtxjTxnTMgKEqH5dwv+hUHwdN5Xhw61VD7t2JagvkWn5rW1Tn82XfMdWnu+ZjGFXEywLmkabWVF6/mahOZHgT5RAEtnzLUDVZpCSczRsO+m5OiH2HvNdmS51lUY3Ur7hkWcaag3qUBxY1Q8vexVQ/+ufdRaN0RRKFdAwZpc3gUvG0CJIXGOVtmUvpnIo45W4/IBkS5MKg6Aqcv0h/sVVlaUWeW8jQCmyszbGJr0cAA+6Fd1KLSj5YAOQM9XG9FH9Vrjl6Ti3DYR5szGSsfWMx31Z6TwP5CNQSxeknv02pSScRWTxHl8tJ5Sioxx89qD4DIsaHiBM3XLrbzZuqWia6XsGhWl4m27U5CwCYCZsLQ== ngrachik2011@gmail.com
            EOT
        }
      + name                      = "terraform1"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd86ca997krgb6vcroqm"
              + name        = (known after apply)
              + size        = (known after apply)
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.vm-count[0] will be created
  + resource "yandex_compute_instance" "vm-count" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + name                      = "vm-0-prod"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd86ca997krgb6vcroqm"
              + name        = (known after apply)
              + size        = (known after apply)
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 1
          + memory        = 1
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.vm-count[1] will be created
  + resource "yandex_compute_instance" "vm-count" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + name                      = "vm-1-prod"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd86ca997krgb6vcroqm"
              + name        = (known after apply)
              + size        = (known after apply)
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 1
          + memory        = 1
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.vm-for["1"] will be created
  + resource "yandex_compute_instance" "vm-for" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + name                      = "vm-1-prod"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd86ca997krgb6vcroqm"
              + name        = (known after apply)
              + size        = (known after apply)
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 1
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.vm-for["2"] will be created
  + resource "yandex_compute_instance" "vm-for" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + name                      = "vm-2-prod"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd86ca997krgb6vcroqm"
              + name        = (known after apply)
              + size        = (known after apply)
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 1
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_iam_service_account.gn will be created
  + resource "yandex_iam_service_account" "gn" {
      + created_at = (known after apply)
      + folder_id  = "b1g9eeptbncntgrfjcof"
      + id         = (known after apply)
      + name       = "gnavasardyan"
    }

  # yandex_iam_service_account_static_access_key.gn-static-key will be created
  + resource "yandex_iam_service_account_static_access_key" "gn-static-key" {
      + access_key           = (known after apply)
      + created_at           = (known after apply)
      + description          = "Static access key for object storage"
      + encrypted_secret_key = (known after apply)
      + id                   = (known after apply)
      + key_fingerprint      = (known after apply)
      + secret_key           = (sensitive value)
      + service_account_id   = (known after apply)
    }

  # yandex_resourcemanager_folder_iam_member.my-robot will be created
  + resource "yandex_resourcemanager_folder_iam_member" "my-robot" {
      + folder_id = "b1g9eeptbncntgrfjcof"
      + id        = (known after apply)
      + member    = (known after apply)
      + role      = "storage.editor"
    }

  # yandex_storage_bucket.state will be created
  + resource "yandex_storage_bucket" "state" {
      + access_key            = (known after apply)
      + acl                   = "private"
      + bucket                = "tf-state-bucket-navasardyan"
      + bucket_domain_name    = (known after apply)
      + default_storage_class = (known after apply)
      + folder_id             = (known after apply)
      + force_destroy         = false
      + id                    = (known after apply)
      + secret_key            = (sensitive value)
      + website_domain        = (known after apply)
      + website_endpoint      = (known after apply)

      + anonymous_access_flags {
          + list = (known after apply)
          + read = (known after apply)
        }

      + versioning {
          + enabled = (known after apply)
        }
    }

  # yandex_vpc_network.network-1 will be created
  + resource "yandex_vpc_network" "network-1" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "network1"
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_subnet.subnet-1 will be created
  + resource "yandex_vpc_subnet" "subnet-1" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "subnet1"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.10.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

Plan: 11 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + access_key                  = (sensitive value)
  + external_ip_address_first-1 = (known after apply)
  + internal_ip_address_first-1 = (known after apply)
  + secret_key                  = (sensitive value)

```
![](https://github.com/MrNavasardyan/devops-netology_navasardyan/blob/main/homework/img/tr_workspace.PNG)
---

```
!!!!!!!!!!!!Просьба разъяснить по заданию, почему при terraform apply получаю ошибки:

yandex_vpc_network.network-1: Creating...
yandex_iam_service_account.gn: Creating...
╷
│ Error: Error while requesting API to create network: server-request-id = b0677b28-9700-4c06-8934-ac621208e50a server-trace-id = 6c194e9f6148b9f2:3b64a788946c5641:6c194e9f6148b9f2:1 client-request-id = cbbea82e-c530-4449-882f-888f23200cfe client-trace-id = 5c4678c1-8dfc-48c4-82bd-b859458bfd8e rpc error: code = AlreadyExists desc = Network with name network1 already exists
│
│   with yandex_vpc_network.network-1,
│   on main.tf line 52, in resource "yandex_vpc_network" "network-1":
│   52: resource "yandex_vpc_network" "network-1" {
│
╵
╷
│ Error: Error while requesting API to create service account: server-request-id = 792e712b-7672-4e4a-8497-1effbd891228 server-trace-id = 88715a7f0d38c5e4:b6a607c8ed59d8c2:88715a7f0d38c5e4:1 client-request-id = d7eaa10f-4d7f-44cb-9787-b9fd327e5ed4 client-trace-id = 5c4678c1-8dfc-48c4-82bd-b859458bfd8e rpc error: code = AlreadyExists desc = Service account 'gnavasardyan@b1ga39ackif6hoe1jml8' already exists
│
│   with yandex_iam_service_account.gn,
│   on yandex_storage_bucket.tf line 1, in resource "yandex_iam_service_account" "gn":
│    1: resource "yandex_iam_service_account" "gn" {
│
```

---