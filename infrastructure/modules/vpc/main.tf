# creating a VPC resource with the specified CIDR block and name tag (terraform reference)
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  # adding a tag to the vpc resource so it displays the name in the AWS console
  tags = {
    Name = var.vpc_name
  }
}
# creating a public subnet resource with the specified CIDR block and availability zone
resource "aws_subnet" "public1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.publicsubnet1_cidr
  availability_zone = var.publicsubnet1_az
}

# creating a public subnet resource with the specified CIDR block and availability zone
resource "aws_subnet" "public2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.publicsubnet2_cidr
  availability_zone = var.publicsubnet2_az
}

# creating a private subnet resource with the specified CIDR block and availability zone
resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.privatesubnet1_cidr
  availability_zone = var.privatesubnet1_az
}

# creating a private subnet resource with the specified CIDR block and availability zone
resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.privatesubnet2_cidr
  availability_zone = var.privatesubnet2_az
}

# creating an internet gateway resource and associating it with the VPC
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

# creating a route table resource and associating it with the VPC
# creating one route table because both public subnets use the same route to the Internet Gateway
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  # creating a route in the route table that directs all traffic (IPv4) to the internet gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

# associating the public subnet 1 with the route table so that it can access the internet
resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}
# associating the public subnet 2 with the route table so that it can access the internet
resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}

# creating private route tables for each private subnet so that they can route traffic through the NAT Gateway
resource "aws_route_table" "private1" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main1.id
  }
}

# associating the private subnet 1 with the route table so that it can route traffic through the NAT Gateway
resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private1.id
}

# creating private route tables for each private subnet so that they can route traffic through the NAT Gateway
resource "aws_route_table" "private2" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main2.id
  }
}

# associating the private subnet 2 with the route table so that it can route traffic through the NAT Gateway
resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private2.id
}

# creating a NAT gateway resource and associating it with the public subnet 1
resource "aws_nat_gateway" "main1" {
  allocation_id = aws_eip.main1.id
  subnet_id     = aws_subnet.public1.id
}

# creating an Elastic IP resource for the NAT gateway in public subnet 1
resource "aws_eip" "main1" {
  domain = "vpc"
}


# creating a NAT gateway resource and associating it with the public subnet 2
resource "aws_nat_gateway" "main2" {
  allocation_id = aws_eip.main2.id
  subnet_id     = aws_subnet.public2.id
}

# creating an Elastic IP resource for the NAT gateway in public subnet 2
resource "aws_eip" "main2" {
  domain = "vpc"
}
