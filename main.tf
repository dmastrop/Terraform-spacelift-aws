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

module "third-compute" {
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
  node_name = "third-node"
  key_name = "third-key"
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

  subnet_id = module.networking.subnet_id-1
  # this is a manual override test of the spacelift context TF_VAR_aws_availability_zone.
  # Want to override the default linux spacelift context and force the second instance to windows aws_availablity_zone 
  # of us-east-1a but this is not possible given the aws_region is still us-west-2
  # Thus subnet_id-2 does not work, but subnet_id-1 does work. The availability_zone can be set to us-west-2a 2b 2c or 2d
  # If host_os is hardcoded to "windows" below, can set this availability zone to us-west-2c and subnet 10.123.3.0/24 to align with the spacelift context.
  
  ##subnet_id         = module.networking.subnet_id
  



  host_os = "windows"
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


# Ansible null_resource:
# We want to place this in a null_resource because we only want it to run once for all aws_instances. So we do not want to put it
# in the aws_instance resource block.  The aws_instances need to be up when this is run so put it at the bottom of compute.tf
resource "null_resource" "grafana_install" {
  # we do not want to run this before all the aws_instances are up and running
  # note there is no count or count.index specified, so ALL instances must be up and running before null_instance ansible runs
  # created vs. initialized?
  # note that this is a loal provisioner, so it is run locally and ansible-playbook is executed on aws_hosts via ssh (private key)
  depends_on = [module.compute.aws_instance.dev_node]
  provisioner "local-exec" {
    #command = "ansible-playbook -i aws_hosts --key-file /home/ubuntu/.ssh/mtckey playbooks/grafana.yml"
    # ansible-playbook is run locally on Cloud9 but uses ssh to aws_hosts to deploy the ansible playbook on the remote aws_hosts
    command = "ansible-playbook -i compute/aws_hosts --key-file ~/.ssh/mtckey playbooks/main-playbook.yml"
  }
} 