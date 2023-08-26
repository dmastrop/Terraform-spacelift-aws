# this is used in the compute.tf
variable "subnet_id" {
  #type = list
  type = string
}

# this is used in the compute.tf
variable "security_group_id" {
  #type = string
  type = list(any)
}

# this allows the outputs.tf in compute to access this variable in outputs.tf
variable "host_os" {
  type = string
}


##NOTES:

#vpc_security_group_ids = [aws_security_group.mtc_sg.id]
# we will need to create a variables.tf for this
##vpc_security_group_ids = var.security_group_id
# NOTE: originally this is in brackets so this is a type = list 
# when we define this as a variable

#subnet_id = aws_subnet.mtc_public_subnet.id
# we will need to create a variables.tf for this
##subnet_id = var.subnet_id
# NOTE: originally this is not in brackets so this is a type = string
# when we define this as a variable.