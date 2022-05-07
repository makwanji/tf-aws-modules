data "template_file" "bastion_cloudinit" {
  template = file("${path.module}/bastion-cloudinit.sh.template")

  vars = {
    bastion_users = local.authorized_keys
    public_key    = var.public_key
    private_key   = var.private_key
  }
}

resource "aws_security_group" "bastion_access" {
  name        = "bastion-access-${var.dept}"
  description = "Terminal access for ${var.dept}"
  vpc_id      = var.vpc_id

  ingress {
    # allow all traffic from inside VPC
    self      = true
    from_port = 0
    to_port   = 0
    protocol  = "-1"
  }

  ingress {
    # allow ssh traffic from all IPs since we can't allow by IP yet
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "bastion-access-${var.dept}"
    dept        = "${var.billing_dept}"
    environment = "${var.billing_environment}"
    owner       = "${var.billing_owner}"
    product     = "${var.billing_product}"
  }
}

resource "aws_instance" "bastion" {
  availability_zone = var.availability_zone
  instance_type     = "t2.micro"

  root_block_device {
    volume_type = "gp2"
    volume_size = "20"
  }

  ami                    = var.ami
  vpc_security_group_ids = concat(["${aws_security_group.bastion_access.id}"], var.attached_security_groups)
  key_name               = var.key_name
  user_data              = data.template_file.bastion_cloudinit.rendered
  tags = {
    Name        = "bastion-access-${var.dept}"
    dept        = "${var.billing_dept}"
    environment = "${var.billing_environment}"
    owner       = "${var.billing_owner}"
    product     = "${var.billing_product}"
  }
}

# // Below code is to create entry in DNS Zone record

# resource "aws_route53_zone" "dns_zone" {
#   name          = var.dns_zone
#   force_destroy = false
#   comment       = ""
# }

# resource "aws_route53_record" "bastion_dns" {
#   zone_id = aws_route53_zone.dns_zone.zone_id
#   name    = "bastion-${var.dept}"
#   type    = "CNAME"
#   ttl     = "300"
#   records = [
#     aws_instance.bastion.public_dns
#   ]
# }

