#-----------------------------------------------------------------------------------------------------
# Outputs
#-----------------------------------------------------------------------------------------------------
output "fgt_ids" {
  value = module.fgt.fgt_list
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