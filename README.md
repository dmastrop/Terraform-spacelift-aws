main branch is the latest modular implementation of the terraform infra deployment (compute and networking terraform modules). New variables added

development_through_18_first_module is the first modular implementation of terraform.

development_through_14 is the non-modular implementation on the terraform infra deployment



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



