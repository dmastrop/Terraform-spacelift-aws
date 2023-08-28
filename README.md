main branch is the latest modular implementation of the terraform infra deployment (compute and networking terraform modules). Three new  variables added to make multiple computes more extensible (compute variables.tf), second compute node added (compute.tf and main.tf second compute module), root outputs.tf added second compute module entry.
Added experimental code for subnet-1 with availability zone that can be set apart from spacelift context
Added third compute (same as first compute).  Second compute uses this subnet-1

development_through_18_first_module is the first modular implementation of terraform.

development_through_14 is the non-modular implementation on the terraform infra deployment

development_experimental for experimental code.



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



