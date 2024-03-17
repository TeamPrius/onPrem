#Create security group

resource "aws_security_group" "onpremsg" {
  name        = "onpremsg"
  description = "Allow http traffic"
  vpc_id      = aws_vpc.onprem.id

  tags = {
    Name = "onprem-SG"
  }
}

#Inbound rules

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.onpremsg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

#Outbound rules

resource "aws_vpc_security_group_egress_rule" "allow_http" {
  security_group_id = aws_security_group.labsg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# SSH Keys

variable "public_key" {
  type    = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDUDTnjc4Z9vOTbbAPkwWkFiuxr1DzQSDmwsef3IL3KyT7k3aZlMlf/tFZS5lsyo0fy9H6L7juNmH7P/BAJQteuC9bD7B6dYO8ciLcJ0tIMYR9ixmi2US6QdW8Ljfptu9ZczgysxsiijKwICwXdd5Om0IdGyjH4rFqkXn27wjwfZQbGivnBf2nT2qDlIebKcjgX/VXNofoz2KpSGa0ipemxddv1hti9oItCgMQ7HgygFnQp5bNCl1dQN3itSCOHOdKQjm765g8PVIbeOcnCQGtKh4v950aCZv6pGONgiYtuTYJ+ojwXm93z7CdtbwHdXutCPbPIqWR6EibQVywjoIAEQblm/7JcUeoVXqnwGyDmCJT/ek5fD8aXyKJ25N4jRdxOhCBA0evPiY/suwemZaJL50DQO90KjK9tpjnP0td6gfJNXscwgfGZP1uNSTgNSpRqhxwjyOeDlNTxM20hDLZO/mBl9ye8n47wGcsbZg5nqn2wVxLL0IfJLPMmZ2goSC0= catherine@Bichette"
}

variable "key_name" {
  type    = string
  default = "tenable" 
}

resource "aws_key_pair" "tenable" {
  key_name   = var.key_name
  public_key = var.public_key 
}

# Create EC2 instance

resource "aws_instance" "onprem_server" {
  ami              	 	= "ami-07d9b9ddc6cd8dd30"
  instance_type     		= "t2.micro"
  subnet_id         		= aws_subnet.public_subnet_prem.id
  availability_zone 		= "us-east-1a"
  associate_public_ip_address  = true
  vpc_security_group_ids 	= ["${aws_security_group.onpremsg.id}"]
  #user_data         		= filebase64("./userdata.sh")
  key_name      		= aws_key_pair.key_name
  
  metadata_options {
    http_tokens   = "optional"
    http_endpoint = "enabled"
  }

  tags = {
    Name = "On-Prem Server running Ubuntu"
  }
}



