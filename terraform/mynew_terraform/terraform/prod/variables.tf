
variable "yandex_folder_id" {
  type        = string
  default     = "b1g9eeptbncntgrfjcof"
}

variable "token_auth" {
  type        = string
  default     = "AQAAAAA6NjbpAATuwcIaTCYDxEWxnh6mihTXYlc"
}

variable "cloud_id" {
  type        = string
  default     = "b1ga39ackif6hoe1jml8"
}

variable "zone" {
  type        = string
  default     = "ru-central1-a"
}

variable "vm_name_pfx" {
  description = "VM Names"
  default     = "test-vm"
  type        = string
}

variable "vm_count" {
  description = "Number of Virtual Machines"
  default     = 2
  type        = string
}
