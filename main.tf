module "networking" {
  source = "./networking"
  # I need to add aws_availability_zone because I added that as a variable
  # NOTE that the value of this variable is defined in the spacelift context as TF_VAR_aws_availability_zone
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
  # host_os is not an output but a variable from the spacelift context TF_VAR_host_os
  # it is used as a variable in the compute.tf outputs.tf
  # we can remove the default value for host_os in root variables.tf file

  #the variables below are added for the changes to compute.tf for extensiblity for multiple aws instances
  # the compute variables.tf and the compute.tf have also been modified accordingly
  # for now we will give the following static assignments
  node_name = "first-node"
  key_name = "first-key"
  instance_type = "t2.micro"
}




# create a new second compute instance
module "second-compute" {

  source = "./compute"
  # need to pass in the security group id and subnet id so that i can access the 
  # outputs of the networking module
  # it can only access them through the output
  # the variables.tf in compute module (folder) will look for the definition of these in this root module
  #  and the root module will then fetch the values from output of the networking module.
  security_group_id = [module.networking.security_group_id]
  subnet_id         = module.networking.subnet_id
  
  host_os = "windows"
  availability_zone = "us-east-1a"
  # this is a manual override test of the spacelift context (as noted in comments below)
  # Even though spacelift context is set at linux, this should deploy windows for the second comute
  # and first compute should continue to use linux since it's host_os = var.host_os
  
  ##host_os           = var.host_os
  # unlike the first 2 this one has to come from the root module and into the compute module
  # host_os is not an output but a variable from the spacelift context TF_VAR_host_os
  # it is used as a variable in the compute.tf outputs.tf
  # we can remove the default value for host_os in root variables.tf file
  
  # this second compute instance can be given a static host_os, but I will continue to derive all
  # compute instance host_os  from the spacelift context
  # the host_os in this case will be homogeneous, but this does not have to be the case
  # One can have a mixture of linux and windows host_os aws instances.

  #the variables below are added for the changes to compute.tf for extensiblity for multiple aws instances
  # the compute variables.tf and the compute.tf have also been modified accordingly
  # for now we will give the following static assignments
  node_name = "second-node"
  key_name = "second-key"
  instance_type = "t2.small"


}