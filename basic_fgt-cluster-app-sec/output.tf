output "fgt" {
  value = module.fgt-cluster.fgt
}

output "k8s" {
  value = {
    public_ip    = module.k8s.vm["public_ip"]
    adminuser    = module.k8s.vm["adminuser"]
    app_dvwa_url = "http://${module.k8s.vm["public_ip"]}:31000"
    app_api_url  = "http://${module.k8s.vm["public_ip"]}:31001"
  }
}

output "ssh_private_key_pem" {
  sensitive = true
  value = module.fgt-cluster.ssh_private_key_pem
}