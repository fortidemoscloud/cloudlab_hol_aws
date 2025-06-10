output "fgt" {
  value = module.fgt.fgt
}

output "k8s" {
  value = {
    public_ip    = module.k8s.vm["public_ip"]
    adminuser    = module.k8s.vm["adminuser"]
    app_vote_url = "http://${module.k8s.vm["public_ip"]}:31000"
  }
}

output "ssh_private_key_pem" {
  sensitive = true
  value     = module.fgt.ssh_private_key_pem
}