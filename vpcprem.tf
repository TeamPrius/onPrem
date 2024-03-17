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
  
  route {
    cidr_block = "10.0.0.0/24"
    gateway_id = aws_ec2_transit_gateway.transit_gateway.id
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.onpremigw.id
  }
  
  tags = {
    Name = "Public Route Table On-Prem"
  }
}

resource "aws_route_table_association" "public_rta_prem" {
  subnet_id      = aws_subnet.public_subnet_prem.id
  route_table_id = aws_route_table.public_rt_prem.id
}

#Create Internet Gateway 

resource "aws_internet_gateway" "onpremigw" {
  vpc_id = aws_vpc.onprem.id

  tags = {
    Name = "On-Prem IGW"
  }
}

# Create customer gateway
resource "aws_customer_gateway" "customer_gw" {
  bgp_asn    = 65000
  #ip_address = "x.x.x.x" # Public IP of the on-prem VPN device, need to set up
  type       = "ipsec.1"
}

# Define VPN connection
resource "aws_vpn_connection" "vpn_conn" {
  customer_gateway_id = aws_customer_gateway.customer_gw.id
  type                = "ipsec.1"
  transit_gateway_id  = aws_ec2_transit_gateway.transit_gateway.id

  static_routes_only = true
  tunnel1_inside_cidr = "192.168.0.0/24"
  tunnel1_preshared_key = "your_shared_key"
  tunnel2_inside_cidr = "192.168.0.0/24"
  tunnel2_preshared_key = "your_shared_key"
}

# Associate VPN connection with Transit Gateway
resource "aws_vpn_connection_route" "vpn_tgw" {
  destination_cidr_block = "192.168.0.0/24"
  vpn_connection_id      = aws_vpn_connection.vpn_conn.id
}

resource "aws_network_acl" "nacl_onprem" {
  vpc_id = aws_vpc.onprem.id

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  tags = {
    Name = "ON-Prem NACL"
  }
}

