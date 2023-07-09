provider "aws" {
  region = "ap-northeast-1"
}

variable "name" {
  description = "各種リソースの命名"
  default     = "vpc-handson"
}




## VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "${var.name}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.main.id # `resource "aws_vpc" "main"` が作成したVPCのIDを取得

  tags = {
    Name = "${var.name}"
  }
}

# Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name}_public"
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}


# Public Subnet
resource "aws_subnet" "public_1a" {
  vpc_id = aws_vpc.main.id

  cidr_block        = "10.0.0.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "${var.name}_public_1a"
  }
}

resource "aws_route_table_association" "public_1a" {
  subnet_id      = aws_subnet.public_1a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "public_1c" {
  vpc_id = aws_vpc.main.id

  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "${var.name}_public_1c"
  }
}

resource "aws_route_table_association" "public_1c" {
  subnet_id      = aws_subnet.public_1c.id
  route_table_id = aws_route_table.public.id
}

# Route Table
resource "aws_route_table" "private_1a" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name}"
  }
}

resource "aws_route_table" "private_1c" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name}"
  }
}

# NAT Gateway
resource "aws_eip" "nat_1a" {
  domain = "vpc"

  tags = {
    Name = "${var.name}_1a"
  }
}

resource "aws_eip" "nat_1c" {
  domain = "vpc"

  tags = {
    Name = "${var.name}_1c"
  }
}

resource "aws_nat_gateway" "nat_1a" {
  allocation_id = aws_eip.nat_1a.id
  subnet_id     = aws_subnet.public_1a.id

  tags = {
    Name = "${var.name}_1a"
  }
}

resource "aws_route" "private_natgw_1a" {
  route_table_id         = aws_route_table.private_1a.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_1a.id
}

resource "aws_nat_gateway" "nat_1c" {
  allocation_id = aws_eip.nat_1c.id
  subnet_id     = aws_subnet.public_1c.id

  tags = {
    Name = "${var.name}_1c"
  }
}

resource "aws_route" "private_natgw_1c" {
  route_table_id         = aws_route_table.private_1c.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_1c.id
}

# Private Subnet
resource "aws_subnet" "private_1a" {
  vpc_id = aws_vpc.main.id

  cidr_block        = "10.0.10.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "${var.name}_private_1a"
  }
}

resource "aws_route_table_association" "private_1a" {
  subnet_id      = aws_subnet.private_1a.id
  route_table_id = aws_route_table.private_1a.id
}

resource "aws_subnet" "private_1c" {
  vpc_id = aws_vpc.main.id

  cidr_block        = "10.0.11.0/24"
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "${var.name}_private_1c"
  }
}

resource "aws_route_table_association" "private_1c" {
  subnet_id      = aws_subnet.private_1c.id
  route_table_id = aws_route_table.private_1c.id
}

