# from the networking.tf file:
# resource "aws_security_group" "mtc_sg" 
# from compute.tf file:
# vpc_security_group_ids = [aws_security_group.mtc_sg.id]
output "security_group_id" {
  value = aws_security_group.mtc_sg.id
}

# from the networking.tf file:
# resource "aws_subnet" "mtc_public_subnet" 
# from compute.tf file:
# subnet_id = aws_subnet.mtc_public_subnet.id
output "subnet_id" {
  value = aws_subnet.mtc_public_subnet.id
}

# experimental outputs 1 and 2
output "subnet_id-1" {
  value = aws_subnet.mtc_public_subnet-1.id
}
