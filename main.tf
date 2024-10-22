# Create VPC
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-vpc"
    }
  )
}

# Create Internet Gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-igw"
    }
  )
}

# DMZ Subnets (Public)
resource "aws_subnet" "dmz" {
  count                   = 3
  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 4, count.index)
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-dmz-${count.index + 1}",
      Tier = "DMZ"
    }
  )
}

# Logic Subnets (Private)
resource "aws_subnet" "logic" {
  count             = 3
  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 4, count.index + 3)
  availability_zone = var.availability_zones[count.index]

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-logic-${count.index + 1}",
      Tier = "Logic"
    }
  )
}

# Data Subnets (Private)
resource "aws_subnet" "data" {
  count             = 3
  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 4, count.index + 6)
  availability_zone = var.availability_zones[count.index]

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-data-${count.index + 1}",
      Tier = "Data"
    }
  )
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-public-rt"
    }
  )
}

# Associate Public Route Table with DMZ Subnets
resource "aws_route_table_association" "dmz" {
  count          = length(aws_subnet.dmz)
  subnet_id      = aws_subnet.dmz[count.index].id
  route_table_id = aws_route_table.public.id
}

# NAT Gateways
resource "aws_eip" "nat" {
  count = length(var.availability_zones)
  vpc   = true

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-nat-eip-${count.index + 1}"
    }
  )
}

resource "aws_nat_gateway" "this" {
  count         = length(var.availability_zones)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.dmz[count.index].id

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-nat-${count.index + 1}"
    }
  )
}

# Private Route Tables for Logic Subnets
resource "aws_route_table" "logic" {
  count  = length(var.availability_zones)
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this[count.index].id
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-logic-rt-${count.index + 1}"
    }
  )
}

resource "aws_route_table_association" "logic" {
  count          = length(aws_subnet.logic)
  subnet_id      = aws_subnet.logic[count.index].id
  route_table_id = aws_route_table.logic[count.index].id
}

# Private Route Tables for Data Subnets
resource "aws_route_table" "data" {
  count  = length(var.availability_zones)
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this[count.index].id
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-data-rt-${count.index + 1}"
    }
  )
}

resource "aws_route_table_association" "data" {
  count          = length(aws_subnet.data)
  subnet_id      = aws_subnet.data[count.index].id
  route_table_id = aws_route_table.data[count.index].id
}
