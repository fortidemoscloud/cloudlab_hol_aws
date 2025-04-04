# ------------------------------------------------------------------
# Create Security Groups for each FGT NI
# ------------------------------------------------------------------
# SG Public Subnets
resource "aws_security_group" "sg_public" {
  for_each = { for k, v in var.fgt_subnet_tags : k => v if strcontains(k, local.tag_public) }

  name        = "${var.prefix}-sg-${each.key}"
  description = "Allow all traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8 # the ICMP type number for 'Echo'
    to_port     = 0 # the ICMP code
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 0 # the ICMP type number for 'Echo Reply'
    to_port     = 0 # the ICMP code
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    { Name = "${var.prefix}-sg-${each.key}" },
  var.tags)
}
# SG Private Subnets
resource "aws_security_group" "sg_private" {
  for_each = { for k, v in var.fgt_subnet_tags : k => v if strcontains(k, local.tag_private) }

  name        = "${var.prefix}-sg-${each.key}"
  description = "Allow all connections from RFC1918"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow all traffic inbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["192.168.0.0/16", "10.0.0.0/8", "172.16.0.0/12"]
  }
  egress {
    description = "Allow all traffic outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    { Name = "${var.prefix}-sg-${each.key}" },
    var.tags
  )
}
# SG MGMT and HA NI
resource "aws_security_group" "sg_mgmt_ha" {
  for_each = { for k, v in var.fgt_subnet_tags : k => v if strcontains(k, local.tag_mgmt) || strcontains(k, local.tag_ha) }

  name        = "${var.prefix}-sg-${each.key}"
  description = "Allow MGMT SSH, HTTPS and ICMP traffic and all between FGT"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.admin_cidr}"]
  }
  ingress {
    from_port   = var.admin_port
    to_port     = var.admin_port
    protocol    = "tcp"
    cidr_blocks = ["${var.admin_cidr}"]
  }
  ingress {
    description = "Allow all from FGT subnets"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = local.mgmt_cidrs
  }
  ingress {
    from_port   = 8 # the ICMP type number for 'Echo'
    to_port     = 0 # the ICMP code
    protocol    = "icmp"
    cidr_blocks = ["${var.admin_cidr}"]
  }
  ingress {
    from_port   = 0 # the ICMP type number for 'Echo Reply'
    to_port     = 0 # the ICMP code
    protocol    = "icmp"
    cidr_blocks = ["${var.admin_cidr}"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    { Name = "${var.prefix}-sg-${each.key}" },
    var.tags
  )
}