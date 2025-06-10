#--------------------------------------------------------------------------------------------------------------
# General Variables
#--------------------------------------------------------------------------------------------------------------
variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    environment = "demo"
    project     = "multi-cloud-sdwan"
    owner       = "terraform"
  }
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
