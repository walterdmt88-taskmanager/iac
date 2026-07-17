variable "prefix" { type = string }
variable "project" { type = string }
variable "environment" { type = string }
variable "region_code" { type = string }
variable "region" { type = string }
variable "responsible_party" { type = string }
variable "owner" { type = string }
variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "purpose" {
  type    = string
  default = "api-server"
}
