resource "aws_vpc" "vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "sn1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Main- 1a"
  }
}

resource "aws_subnet" "sn2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Main-1b"
  }
}

resource "aws_subnet" "sn3" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "Main-1c"
  }
}

resource "aws_security_group" "sg" {
  name        = "sg"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "sg_tf_vpc"
  }

  ingress {
    from_port        = 5678
    to_port          = 5678
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    description = "containerPort"
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    description = "http"
  }
  
  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    description = "https"
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "vpcmain"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  
}

resource "aws_route_table_association" "route1" {
  subnet_id      = aws_subnet.sn1.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "route2" {
  subnet_id      = aws_subnet.sn2.id
  route_table_id = aws_route_table.rt.id
}


resource "aws_route_table_association" "route3" {
  subnet_id      = aws_subnet.sn3.id
  route_table_id = aws_route_table.rt.id
}