output "dev_ip" {
  value = aws_instance.dev_node.public_ip
}

output "connection_script" {
  value = templatefile("${var.host_os}-ssh-config.tpl", {
    #hostname = self.public_ip,
    # we no longer have access to self.public_ip because this is no longer in the aws_instance resource of main.tf
    # we will have to reference the resource directly as below, for each instance:
    hostname = aws_instance.dev_node.public_ip
    user     = "ubuntu",
  identityfile = "~/.ssh/mtckey" })
  # note this output is created at the end of the terraform apply

}



#the connection_script is based upon the old local provisioner that was
#in main (since then commented out). Note the command below.
#provisioner "local-exec" {
#  command = templatefile("${var.host_os}-ssh-config.tpl", {
#    hostname = self.public_ip,
#    user     = "ubuntu",
#  identityfile = "~/.ssh/mtckey" })
#  interpreter = var.host_os == "windows" ? ["Powershell", "-Command"] : ["bash", "-c"]
#}
