module "networking" {
  source = "./networking"
  # I need to add aws_availability_zone because I added that as a variable
  aws_availability_zone = var.aws_availability_zone
}

module "compute" {
  source = "./compute"
  # need to pass in the security group id and subnet id so that i can access the 
  # outputs of the networking module
  # it can only access them through the output
  # the variables.tf in compute module (folder) will look for the definition of these in this root module
  #  and the root module will then fetch the values from output of the networking module.
  security_group_id = [module.networking.security_group_id]
  subnet_id         = module.networking.subnet_id
  host_os           = var.host_os
  # unlike the first 2 this one has to come from the root module and into the compute module
  # host_os is not an output but a variable from the spacelift context
  # it is used as a variable in the compute.tf outputs.tf
  # we can remove the default value for host_os in root variables.tf file
}