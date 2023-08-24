
variable "host_os" {
	type = string
	default = "windows"
}

variable "aws_region" {
	type = string
}

# my addtion for the variable on aws_availability_zone based upon the spacelift
# host_os context windows vs. linux.   In linux we will deploy subnet and infra on us-west-2a
# on windows we will deploy subnet and infra on us-east-1a
# the relevant contexts in spaceflift have  been updated with TF_VAR_aws_availability_zone
variable "aws_availability_zone" {
	type = string
}