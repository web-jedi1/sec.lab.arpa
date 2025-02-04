# provider vars
variable "proxmox_api_url"{
  type = string
}

variable "proxmox_api_token_id" {
  type = string
}

variable "proxmox_api_token_secret" {
  type = string
  sensitive = true
}

variable "proxmox_host" {
  type = string
}

variable "terraform_pub_key" {
  type = string
}

variable "ciuser" {
  type = string
}

variable "cipassword" {
  type = string
  sensitive = true
}

variable "template_name" {
  type =  string
  default = "win19-cloudinit"
}

variable "domain" {
  type = map(string)
  default = {
    domain_suffix: "lab.arpa"
    authoritative_dns_server: "10.0.2.2"
  }
}