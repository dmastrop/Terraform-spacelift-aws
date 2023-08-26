resource "aws_key_pair" "mtc_auth" {
  key_name = "mtckey2"
  #public_key = file("~/.ssh/mtckey.pub")
  #public_key = file("mtckey.pub")
  # the mtckey.pub has been moved to local folder for spacelift
  public_key = file("/mnt/workspace/mtckey.pub")
  # the mtckey.pub has been moved again to the spacelift directory
}

resource "aws_instance" "dev_node" {
  instance_type = "t2.micro"
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
    Name = "dev-node"
  }

  #provisioner "local-exec" {
  #  command = templatefile("${var.host_os}-ssh-config.tpl", {
  #    hostname = self.public_ip,
  #    user     = "ubuntu",
  #  identityfile = "~/.ssh/mtckey" })
  #  interpreter = var.host_os == "windows" ? ["Powershell", "-Command"] : ["bash", "-c"]
  #}

}