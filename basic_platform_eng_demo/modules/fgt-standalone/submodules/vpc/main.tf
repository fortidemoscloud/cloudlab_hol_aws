# ------------------------------------------------------------------------------------
# Create VPC
# ------------------------------------------------------------------------------------
# VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    { Name = "${var.prefix}-vpc" },
    var.tags
  )
}
# IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    { Name = "${var.prefix}-igw" },
    var.tags
  )
}
# Subnets peer AZ
resource "aws_subnet" "subnets" {
  for_each = local.subnets_map

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value["cidr"]
  availability_zone = each.value["az"]

  tags = merge(
    { Name = "${var.prefix}-${each.key}" },
    var.tags
  )
}
