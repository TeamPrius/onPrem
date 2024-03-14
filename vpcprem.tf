# Create the VPC

resource "aws_vpc" "onprem" {
  cidr_block = "192.168.0.0/24"  
  tags = {
     Name = "On-prem VPC"
  }
}

#Create Public Subnet 

resource "aws_subnet" "public_subnet_prem" {
  vpc_id     = aws_vpc.onprem.id
  cidr_block = "192.168.0.0/25"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  
  tags = {
    Name = "Public Subnet On-Prem"
  }
}

#Create Route Table for the public subnet

resource "aws_route_table" "public_rt_prem" {
  vpc_id = aws_vpc.onprem.id
  tags = {
    Name = "Public Route Table On-Prem"
  }
}

resource "aws_route_table_association" "public_rta_prem" {
  subnet_id      = aws_subnet.public_subnet_prem.id
  route_table_id = aws_route_table.public_rt_prem.id
}

#need to populate public route table and connect it to internet gateway

#need to create customer gateway



