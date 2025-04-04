#-----------------------------------------------------------------------------------------------------
# Outputs
#-----------------------------------------------------------------------------------------------------
output "fgt" {
  value = { for i, v in module.fgt.fgt_list :
    v["fgt"] => {
      fgt_pass = v["id"]
      fgt_mgmt = var.fgt_cluster_type == "fgcp" ? (
        "https://${element(lookup(module.fgt_nis.fgt_ni_list, v["fgt"], "").mgmt_eips, 0)}:${var.admin_port}"
        ) : (
        "https://${element(lookup(module.fgt_nis.fgt_ni_list, v["fgt"], "").public_eips, 0)}:${var.admin_port}"
      )
      fgt_public = try(element(lookup(module.fgt_nis.fgt_ni_list, v["fgt"], "").public_eips, 0), "None")
    }
  }
}

output "keypair_name" {
  value = trimspace(aws_key_pair.keypair.key_name)
}

output "subnet_ids" {
  value = module.fgt_vpc.subnet_ids
}

output "subnet_private_ids" {
  value = module.fgt_vpc.subnet_private_ids
}

output "subnet_public_ids" {
  value = module.fgt_vpc.subnet_public_ids
}

output "subnet_cidrs" {
  value = module.fgt_vpc.subnet_cidrs
}

output "subnet_private_cidrs" {
  value = module.fgt_vpc.subnet_private_cidrs
}

output "subnet_public_cidrs" {
  value = module.fgt_vpc.subnet_public_cidrs
}

output "rt_ids" {
  value = module.fgt_vpc.rt_ids
}

output "sg_ids" {
  value = module.fgt_vpc.sg_ids
}

output "vpc_id" {
  value = module.fgt_vpc.vpc_id
}

output "fgt_ids_map" {
  value = module.fgt_nis.fgt_ids_map
}

output "fgt_ni_list" {
  value = module.fgt_nis.fgt_ni_list
}

/*
#-------------------------------
# Debugging 
#-------------------------------
output "fgt_ni_list" {
  value = module.fgt_nis.fgt_ni_list
}

output "fgt_ni_ports_config" {
  value = module.fgt_nis.fgt_ports_config
}

output "ni_list" {
  value = module.fgt_nis.ni_list
}
*/