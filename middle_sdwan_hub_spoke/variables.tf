#--------------------------------------------------------------------------------------------------------------
# General Variables
#--------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------
# Variables
# ----------------------------------------------------------------------------------------
variable "prefix" {
  description = "Prefix to configured items in AWS"
  type        = string
  default     = "ptf-eng-demo"
}

variable "fortiflex_token" {
  description = "FortiFlex token"
  type        = string
  default     = ""
}

variable "custom_vars" {
  description = "Custom variables"
  type = object({
    region                     = optional(string, "eu-west-1")
    fgt_build                  = optional(string, "build2731")
    license_type               = optional(string, "byol")
    fgt_size                   = optional(string, "c6i.large")
    fgt_cluster_type           = optional(string, "fgcp")
    fgt_number_peer_az         = optional(number, 1)
    number_azs                 = optional(number, 1)
    fgt_vpc_cidr               = optional(string, "172.10.0.0/23")
    public_subnet_names_extra  = optional(list(string), ["bastion"])
    private_subnet_names_extra = optional(list(string), ["protected"])
    k8s_size                   = optional(string, "t3.2xlarge")
    k8s_version                = optional(string, "1.31")
    tags                       = optional(map(string), { "Deploy" = "CloudLab AWS", "Project" = "CloudLab" })
  })
  default = {}
}

#--------------------------------------------------------------------------------------------------------------
# Hub Configuration Variables
#--------------------------------------------------------------------------------------------------------------
variable "hub_aws" {
  description = "AWS Hub configuration"
  type = list(object({
    id                = optional(string, "HUB-AWS")
    bgp_asn_hub       = optional(string, "65001")
    bgp_asn_spoke     = optional(string, "65000")
    vpn_cidr          = optional(string, "172.16.10.0/24")
    vpn_psk           = optional(string, "secret-key-123")
    cidr              = optional(string, "10.0.0.0/8")
    ike_version       = optional(string, "2")
    network_id        = optional(string, "1")
    dpd_retryinterval = optional(string, "5")
    mode_cfg          = optional(bool, true)
    vpn_port          = optional(string, "public")
  }))
  default = []
}
