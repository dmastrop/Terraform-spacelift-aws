output "first-connection_script" {
  value = module.compute.connection_script
}

output "first-dev_ip" {
  value = module.compute.dev_ip
}

# these outputs unlike the compute and the networking module
# are visible to us.


# add the root outputs for the second compute instance 
# these are derived from the **compute** outputs.tf file with the module pre-pended as below
# the modules are "compute" for the first instance and "second-compute" for the second instance
# see the main.tf file.
output "second-connection_script" {
    value = module.second-compute.connection_script
}

output "second-dev_ip" {
    value = module.second-compute.dev_ip
}


output "third-connection_script" {
    value = module.third-compute.connection_script
}

output "third-dev_ip" {
    value = module.third-compute.dev_ip
}