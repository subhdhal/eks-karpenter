resource "aws_vpc" "vpc" {
    cidr_block = var.cidr_block
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = merge(var.tags, {
        Name = var.vpc_name
    }) 
    
}
data "aws_availability_zones" "available"{
    state = "available"
}
locals {
    azs = slice(data.aws_availability_zones.available.names, 0, 2)
}
resource "aws_subnet" "public"{
    for_each = {
        for idx, az in local.azs : az => idx
    }
    vpc_id = aws_vpc.vpc.id
    availability_zone = each.key
    cidr_block = cidrsubnet(var.cidr_block, 8, each.value)
    map_public_ip_on_launch = true
    tags = merge(var.tags, {
        Name = "${var.vpc_name}-public-${each.key}"
    })
}
resource "aws_subnet" "private"{
    for_each = {
        for idx, az in local.azs : az => idx
    }
    vpc_id = aws_vpc.vpc.id
    availability_zone = each.key
    cidr_block = cidrsubnet(var.cidr_block, 8, each.value + 10)
    tags = merge(var.tags, {
        Name = "${var.vpc_name}-private-${each.key}"
    })
}
resource "aws_internet_gateway" "igw"{
    vpc_id = aws_vpc.vpc.id
    tags = merge(var.tags, {
        Name = "${var.vpc_name}-igw"
    })
}  

resource "aws_route_table" "public"{
    vpc_id = aws_vpc.vpc.id
    tags = merge(var.tags, {
        Name = "${var.vpc_name}-public"
    })
}
resource "aws_route" "public_internet"{
    route_table_id = aws_route_table.public.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
}
resource "aws_route_table_association" "public"{
    for_each = aws_subnet.public
    subnet_id = each.value.id
    route_table_id = aws_route_table.public.id
}