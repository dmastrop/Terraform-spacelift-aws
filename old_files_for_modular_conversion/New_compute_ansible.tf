resource "aws_key_pair" "mtc_auth" {

  key_name = var.key_name
  # change static key_name to variable for extensible compute module changes

  #key_name = "mtckey2"
  #public_key = file("~/.ssh/mtckey.pub")
  #public_key = file("mtckey.pub")
  # the mtckey.pub has been moved to local folder for spacelift
  public_key = file("/mnt/workspace/mtckey.pub")
  # the mtckey.pub has been moved again to the spacelift directory
}

resource "aws_instance" "dev_node" {

  instance_type = var.instance_type
  # change static instance_type to variable for extensible compute module changes
  # NOTE only t2.micro is in the free tier.

  #instance_type = "t2.micro"
  ami           = data.aws_ami.server_ami.id
  key_name      = aws_key_pair.mtc_auth.id
  #vpc_security_group_ids = [aws_security_group.mtc_sg.id]
  # we will need to create a variables.tf for this
  vpc_security_group_ids = var.security_group_id
  # NOTE: originally this is in brackets so this is a type = list 
  # when we define this as a variable

  #subnet_id = aws_subnet.mtc_public_subnet.id
  # we will need to create a variables.tf for this
  subnet_id = var.subnet_id
  # NOTE: originally this is not in brackets so this is a type = string
  # when we define this as a variable.


  #user_data = file("userdata.tpl")
  # userdata.tpl is already in local file so spacelift will be ok with this.
  user_data = file("${path.module}/userdata.tpl")
  # path.module is the module (folder) that we are in. For compute.tf this is compute folder

  root_block_device {
    volume_size = 10
  }

  tags = {

    Name = "${var.node_name}-dev-node"
    # change static tag of dev-node to dynamic to support extensible compute module implementation

    # Name = "dev-node"
  }


  ## Insert the code that is required for ansible implementation here. It all needs to go in the aws_instance resource
  ## this resource will be utlized by each instance that in invoked the root main.tf through the call to this file/compute folder

  # this is a local provsioner, i.e. it is embedded in the aws_instance resource object.
  # Thus the self object can be used
  # https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax
  # https://developer.hashicorp.com/terraform/language/resources/provisioners/local-exec
  # this provisioner is executed locally whenever a new aws_instance is created.  the command will be run.
  provisioner "local-exec" {
    ##command = "printf '\n${self.public_ip}' >> aws_hosts"
    # note that single quotes around what we are passing into the aws_hosts file
    # the aws_hosts file is local on Cloud9 development instance where we are running terraform.
    # For ansible integration, since there is a problem with the ansible connector to the EC2 instance when 
    # null_instance below is running (ansible-playbook is run before the EC2 instance is fully up), 
    # add the following to the command below: 
    # use self.id to reference the paricular instance-id. This will prevent null_resource granfana install below from running
    # until the EC2 aws_instances are all up and running.
    command = "printf '\n${self.public_ip}' >> aws_hosts && aws ec2 wait instance-status-ok  --instance-ids ${self.id} --region us-west-2"
  }

  # https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax
  provisioner "local-exec" {
    when    = destroy
    command = "sed -i '/^[0-9]/d' aws_hosts"
    # regex expression is used above
    # sed is linux. It will perform the operation on the aws_hosts file.
    # Any line beginnin with a number [0-9] will be removed  /d at the end means delete the line.
    # last is the filename that the sed operation will be performed on....
  }



  #provisioner "local-exec" {
  #  command = templatefile("${var.host_os}-ssh-config.tpl", {
  #    hostname = self.public_ip,
  #    user     = "ubuntu",
  #  identityfile = "~/.ssh/mtckey" })
  #  interpreter = var.host_os == "windows" ? ["Powershell", "-Command"] : ["bash", "-c"]
  #}

}



