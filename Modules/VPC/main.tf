
# Creating VPC
resource "aws_vpc" "main_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Dev"
  }
}
# Creating Public Subnet for ALB
resource "aws_subnet" "main_subnet_pub_A" {
  vpc_id     = aws_vpc.main_vpc.id
  availability_zone = "us-east-1a"
  cidr_block = "10.0.3.32/28"

  tags = {
    Name = "public_ALB_A"
    "kubernetes.io/role/elb"= "1"
    "kubernetes.io/cluster/eks-cluster" = "owned"
  }
}
# Creating Public Subnet for ALB
resource "aws_subnet" "main_subnet_pub_B" {
  vpc_id     = aws_vpc.main_vpc.id
  availability_zone = "us-east-1b"
  cidr_block = "10.0.3.48/28"

  tags = {
    Name = "pub_ALB_B"
    "kubernetes.io/role/elb"= "1"
    "kubernetes.io/cluster/eks-cluster"   = "owned"
  }
}

#creating route table for public subnet
resource "aws_route_table" "route_pub" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "10.0.0.0/24"
    gateway_id = "local"
  }

  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "route_pub"
  }
}

#Route table association
resource "aws_route_table_association" "route_pub_ass_A" {
  subnet_id      = aws_subnet.main_subnet_pub_A.id
  route_table_id = aws_route_table.route_pub.id
}

resource "aws_route_table_association" "route_pub_ass_B" {
  subnet_id      = aws_subnet.main_subnet_pub_B.id
  route_table_id = aws_route_table.route_pub.id
}

# Creating Private with NATgateway Subnet for EKS
resource "aws_subnet" "main_subnet_prieks_A" {
  vpc_id     = aws_vpc.main_vpc.id
  availability_zone = "us-east-1a"
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "pri_EKS_A"
  }
}
# Creating Private with NATgateway Subnet for EKS
resource "aws_subnet" "main_subnet_prieks_B" {
  vpc_id     = aws_vpc.main_vpc.id
  availability_zone = "us-east-1b"
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "pri_EKS_B"
  }
}



#creating route table for private subnet A
resource "aws_route_table" "route_prieks_A" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }

  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = aws_nat_gateway.eks_A.id
  }

  tags = {
    Name = "route_pri_eks_A"
  }
}

#creating route table for private subnet B
resource "aws_route_table" "route_prieks_B" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }

  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = aws_nat_gateway.eks_B.id
  }

  tags = {
    Name = "route_pri_eks_B"
  }
}

# association

resource "aws_route_table_association" "route_prieks_ass_A" {
  subnet_id      = aws_subnet.main_subnet_prieks_A.id
  route_table_id = aws_route_table.route_prieks_A.id
}


# association

resource "aws_route_table_association" "route_prieks_ass_B" {
  subnet_id      = aws_subnet.main_subnet_prieks_B.id
  route_table_id = aws_route_table.route_prieks_B.id
}

# Creating Private Subnet for RDS
resource "aws_subnet" "main_subnet_prirds_A" {
  vpc_id     = aws_vpc.main_vpc.id
  availability_zone = "us-east-1a"
  cidr_block = "10.0.3.0/28"

  tags = {
    Name = "pri_rds_A"
  }
}
# Creating Private  Subnet for RDS
resource "aws_subnet" "main_subnet_prirds_B" {
  vpc_id     = aws_vpc.main_vpc.id
  availability_zone = "us-east-1b"
  cidr_block = "10.0.3.16/28"

  tags = {
    Name = "pri_RDS_B"
  }
}

#creating route table for Private Subnet
resource "aws_route_table" "route_pri" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }

  tags = {
    Name = "route_pri"
  }
}

# association

resource "aws_route_table_association" "route_pri_ass_A" {
  subnet_id      = aws_subnet.main_subnet_prieks_A.id
  route_table_id = aws_route_table.route_pri.id
}
resource "aws_route_table_association" "route_pri_ass_B" {
  subnet_id      = aws_subnet.main_subnet_prieks_B.id
  route_table_id = aws_route_table.route_pri.id
}


#Creating EIP
resource "aws_eip" "nat_A" {}
resource "aws_eip" "nat_B" {}


#Creating Nat gateway in each public subnet

resource "aws_nat_gateway" "eks_A" {
  allocation_id = aws_eip.nat_A.id
  subnet_id     = aws_subnet.main_subnet_pub_A.id

  tags = {
    Name = "NAT_EKS_A"
  }
  depends_on = [aws_internet_gateway.gw,aws_eip.nat_A]
}

resource "aws_nat_gateway" "eks_B" {
  allocation_id = aws_eip.nat_B.id
  subnet_id     = aws_subnet.main_subnet_pub_B.id

  tags = {
    Name = "NAT_EKS_B"
  }
  depends_on = [aws_internet_gateway.gw,aws_eip.nat_B]
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "Dev"
  }
}
