output "connection_script" {
  value = module.compute.connection_script
}

output "dev_ip" {
  value = module.compute.dev_ip
}

# these outputs unlike the compute and the networking module
# is visible to us.