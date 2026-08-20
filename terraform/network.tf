provider "aws" {
  region = "eu-central-1"
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "eks" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "eks-lab-vpc"
  }
}

resource "aws_subnet" "private1" {
  vpc_id     = aws_vpc.eks.id
  cidr_block = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "private_subnet1"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_subnet" "private2" {
  vpc_id     = aws_vpc.eks.id
  cidr_block = "10.0.2.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "private_subnet2"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_subnet" "public1" {
  vpc_id     = aws_vpc.eks.id
  cidr_block = "10.0.11.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "public_subnet1"
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "public2" {
  vpc_id     = aws_vpc.eks.id
  cidr_block = "10.0.12.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "public_subnet2"
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.eks.id

  tags = {
    Name = "eks-gw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.eks.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public-routes"
  }
}

resource "aws_route_table_association" "route_associoate_public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "route_associoate_public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "eks_eip" {
  domain   = "vpc"

  tags = {
    Name = "eip-nat"
  }
}

resource "aws_nat_gateway" "eks_nat" {
  allocation_id = aws_eip.eks_eip.id
  subnet_id     = aws_subnet.public1.id

  tags = {
    Name = "eks-nat"
  }

  depends_on = [aws_internet_gateway.gw]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.eks.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.eks_nat.id
  }

  tags = {
    Name = "private-routes"
  }
}

resource "aws_route_table_association" "route_associoate_private1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "route_associoate_private2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private.id
}