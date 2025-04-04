resource "aws_security_group" "sg_allow_all" {
  name        = "${var.prefix}-sg-allow-all"
  description = "Allow ALL"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Allow all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    { Name = "${var.prefix}-sg-allow-all" },
  var.tags)
}


resource "aws_security_group" "sg_allow_admin_cidr_rfc1918" {
  name        = "${var.prefix}-sg-allow-admin-cidr-rfc1918"
  description = "Allow all traffic from RFC1918 and admin_cidr"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["${var.admin_cidr}", "192.168.0.0/16", "10.0.0.0/8", "172.16.0.0/12"]
  }
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = ["${var.admin_cidr}", "192.168.0.0/16", "10.0.0.0/8", "172.16.0.0/12"]
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
    { Name = "${var.prefix}-sg-allow-admin-cidr-rfc1918" },
  var.tags)
}