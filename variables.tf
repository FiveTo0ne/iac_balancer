variable "devs" {
  description = "Infra settings"
  default = {login = ["starov", "starov"], prefix = ["balancer", "web"]}
}
# variable "devs" {
#     description = "Infra settings"
#     default = {login = ["starovoytenko"], prefix = ["at-mail-ru"]}
#   }

variable "ya_key" {
  description = "Yandex service acc key"
  type        = string
}
variable "cloud_id" {
  description = "Yandex cloud id"
  type        = string
}
variable "folder_id" {
  description = "Yandex folder id"
  type        = string
}
variable "zone" {
  description = "Yandex zone"
  default     = "ru-central1-a"
  type        = string
}
variable "ya_ssh" {
  description = "yandex ssh rsa"
  type        = string
}
variable "ya_pub" {
  description = "yandex ssh rsa"
  type        = string
}
variable "ya_ssh_pr" {
  description = "reb yandex ssh private rsa"
  type        = string
}
variable "priv_rsa" {
  description = "yandex ssh private rsa"
  type        = string
}
variable "name" {
  description = "name dns"
  type        = string
  default     = "starovoytenko"
}
variable "vpc_name" {
  description = "name dns"
  type        = string
  default     = "vm-1-tf-07-t"
}
variable "aws_region" {
  description = "aws dns location"
  type        = string
  default     = "eu-west-3"
}
# Route53
variable "aws_key" {
  description = "AWS Route53 Access key"
  type        = string
}
variable "aws_s_key" {
  description = "AWS Route53 Secret key"
  type        = string
}
variable "primary" {
  description = "AWS Hosted zone name"
  type        = string
}
variable "dns_type" {
  description = "AWS Route53 dns type "
  type        = string
  default     = "A"
}
variable "dns_ttl" {
  description = "AWS Route53 dns ttl "
  type        = string
  default     = "300"
}
# variable "countc" {
#   description = "count"
# }

variable "login" {
  description = "ya vpc login"
  type        = string
  default     = "ubuntu"
}

variable "platform" {
  description = "ya platform id "
  type        = string
  default     = "standard-v1"
}

variable "password" {
  description = "ya ubuntu pass"
  type        = string
  default     = "Password123"
}
variable "ya_labels" {
  description = "labels(tags)"
  type        = map(any)
  default = {
    "user_email" : "starovoytenkoa@mail.ru"
    "task_name" : "ansible-05"
  }
}
variable "email" {
  description = "user email"
  type        = string
  default     = "starovoytenkoa@mail.ru"
}


variable "aws_tags" {
  description = "aws tags"
  default = {
    module = "devops"
    email  = "starovoytenkoa_at_mail_ru"
  }
}
