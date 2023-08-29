main branch is the latest modular implementation of the terraform infra deployment (compute and networking terraform modules). 
-Three new  variables added to make multiple computes more extensible (compute variables.tf), second compute node added (compute.tf and main.tf second compute module), root outputs.tf added second compute module entry.
- total of 3 compute nodes now
- Added experimental code for subnet-1 with availability zone that can be set apart from spacelift context. This applies to sescond comupute node only.  Second compute node currently runs in us-west-2c. 
- other 2 nodes run on either us-west-2a (linux nodes) or us-west-2b (windows nodes). 
- THere is also a special spacelift context in addtion to above for windows us-east-1 aws_region and us-east-1a availability_zone
- Added third compute (same as first compute).  Second compute uses this subnet-1
- Added policy in spacelift for allowing only deployment of t2.micro or t2.small. Tested node 2 with t2.large (denail), t2.micro and t2.small
- Adding code for ansible integration into the compute.tf module.  Need null_resoure in compute.tf to run ansible-playbook and aws_hosts file to keep track of the public ip inventory. Deployment will be grafana and prometheus apps on all 3 nodes.  Need ec2 wait function to wait for all of the instances to be up PRIOR to engaing with ansible for the application deployment onto the the nodes!!
- removed the ansible implementation code from development_experiemental. So it never made it into main. The running environment is spacelift and not local VSCode.  This requires more information from spacelift on ENV vars required to do this, etc....

development_through_18_first_module is the first modular implementation of terraform.

development_through_14 is the non-modular implementation on the terraform infra deployment

development_experimental for experimental code that is to be integrated into main.



==============

Use of spacelift context for linux mac context vs. windows context.

Linux context is in us-west-2a

Windows context is in us-east-1a

Spacelift context variables
TF_VAR_aws_region for providers.tf

TF_VAR_host_os

TF_VAR_aws_availability_zone for networking.tf (Subnet)

var.subnet_id as an output of networking.tf

var.security_group_id as an output of networking.tf



