# Layer Definition
resource "aws_security_group" "app_sg" {
    name                        = "${var.project}-app-sg-${var.environment}"
    vpc_id                      = var.vpc_id
    description                 = "APP SG"
    tags = {
        Name = "${var.project}-app-${var.environment}-sg"
    }
}

resource "aws_security_group" "efs_sg" {
  name                          = "${var.project}-efs-sg-${var.environment}"
  vpc_id                        = var.vpc_id
  description                   = "EFS SG"
  tags = {
      Name  = "${var.project}-efs-sg-${var.environment}" 
  }
}

resource "aws_security_group" "packer_sg" {
  name                          = "${var.project}-packer-sg-${var.environment}"
  vpc_id                        = var.vpc_id
  description                   = "Packer SG"
  tags = {
      Name  = "${var.project}-Packer-sg-${var.environment}" 
  }
}

resource "aws_security_group" "elasticache_sg" {
    vpc_id                      = var.vpc_id 
    name                        = "${var.project}-elasticache-sg-${var.environment}"
    description                 = "ElastiCache SG"
    tags = {
        Name = "${var.project}-elasticache-sg-${var.environment}"
    }
}

resource "aws_security_group" "aurora_sg" {
    vpc_id                      = var.vpc_id
    name                        = "${var.project}-aurora-sg-${var.environment}"
    description                 = "Aurora Security Group"
    tags = {
        Name = "${var.project}-aurora-sg-${var.environment}"
    }
}

resource "aws_security_group" "bastion_sg" {
    name                        = "${var.project}-bastion-${var.environment}-sg"
    vpc_id                      = var.vpc_id
    description                 = "Bastion SG"
    tags = {
        Name = "${var.project}-bastion-${var.environment}-sg"
    }
}

resource "aws_security_group" "alb_sg" {
    name = "${var.project}-frontend-lb-${var.environment}-sg"
    vpc_id = var.vpc_id
    description = "Application Load Balancer"
    tags = {
        Name = "${var.project}-frontend-lb-${var.environment}-sg"
    }
}

# Security Group Rule

resource "aws_security_group_rule" "packer_ingress_port_ssh" {
    type                        = "ingress"
    description                 = "Inbound from internet"
    from_port                   = 22
    to_port                     = 22 
    protocol                    = "tcp"
    security_group_id           = aws_security_group.packer_sg.id
    cidr_blocks                 = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "app_ingress_port_webbserver" {
    type                        = "ingress"
    description                 = "Inbound from Webserver"
    from_port                   = 80
    to_port                     = 80 
    protocol                    = "tcp"
    security_group_id           = aws_security_group.app_sg.id
    source_security_group_id    = aws_security_group.alb_sg.id
}

resource "aws_security_group_rule" "app_ingress_ssh_from_bastion" {
    type                        = "ingress"
    description                 = "Inbbound SSH from Bastion"
    from_port                   = 22
    to_port                     = 22
    protocol                    = "tcp"
    security_group_id           = aws_security_group.app_sg.id
    source_security_group_id    = aws_security_group.bastion_sg.id
}

resource "aws_security_group_rule" "elasticache_ingress_from_app" {
    type                        = "ingress"
    protocol                    = "tcp"
    from_port                   = 6379
    to_port                     = 6379
    security_group_id           = aws_security_group.elasticache_sg.id
    source_security_group_id    = aws_security_group.app_sg.id
}

resource "aws_security_group_rule" "elasticache_ingress_from_bastion" {
    type                        = "ingress"
    protocol                    = "tcp"
    from_port                   = 6379
    to_port                     = 6379
    security_group_id           = aws_security_group.elasticache_sg.id
    source_security_group_id    = aws_security_group.bastion_sg.id
}

resource "aws_security_group_rule" "aurora_inbound_3306_from_app" {
    type                        = "ingress"
    from_port                   = 3306
    to_port                     = 3306
    protocol                    = "tcp"
    #cidr_blocks                 = ["0.0.0.0/0"]
    security_group_id           = aws_security_group.aurora_sg.id
    source_security_group_id    = aws_security_group.app_sg.id
}

resource "aws_security_group_rule" "efs_ingress_from_app" {
    type                        = "ingress"
    protocol                    = "tcp"
    from_port                   = 2049
    to_port                     = 2049
    security_group_id           = aws_security_group.efs_sg.id
    source_security_group_id    = aws_security_group.app_sg.id
}

resource "aws_security_group_rule" "efs_ingress_from_packer" {
    type                        = "ingress"
    protocol                    = "tcp"
    from_port                   = 2049
    to_port                     = 2049
    security_group_id           = aws_security_group.efs_sg.id
    source_security_group_id    = aws_security_group.packer_sg.id
}

resource "aws_security_group_rule" "aurora_inbound_3306_from_bastion" {
    type                        = "ingress"
    from_port                   = 3306
    to_port                     = 3306
    protocol                    = "tcp"
    # cidr_blocks                 = ["0.0.0.0/0"]
    security_group_id           = aws_security_group.aurora_sg.id
    source_security_group_id    = aws_security_group.bastion_sg.id
}

resource "aws_security_group_rule" "alb_ingresss_internet_http" {
    type                        = "ingress"
    description                 = "Inbound HTTP from Internet"
    from_port                   = 80
    to_port                     = 80
    protocol                    = "tcp"
    security_group_id           = aws_security_group.alb_sg.id
    cidr_blocks                 = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "alb_ingresss_internet_https" {
    type                        = "ingress"
    description                 = "Inbound HTTPS from Internet"
    from_port                   = 443
    to_port                     = 443
    protocol                    = "tcp"
    security_group_id           = aws_security_group.alb_sg.id
    cidr_blocks                 = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "bastion_ingress_ssh" {
    type                        = "ingress"
    description                 = "Allow SSH from Internet"
    from_port                   = 22
    to_port                     = 22
    protocol                    = "tcp"
    security_group_id           = aws_security_group.bastion_sg.id
    cidr_blocks                 = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "bastion_egress_ssh_to_app" {
    type                        = "egress"
    description                 = "Outbound SSH to APP"
    from_port                   = 22
    to_port                     = 22
    protocol                    = "tcp"
    security_group_id           = aws_security_group.bastion_sg.id
    source_security_group_id    = aws_security_group.app_sg.id
}

resource "aws_security_group_rule" "bastion_egress_internet_http" {
    type                        = "egress"
    description                 = "Outbound to Internet"
    from_port                   = 80
    to_port                     = 80
    protocol                    = "tcp"
    security_group_id           = aws_security_group.bastion_sg.id
    cidr_blocks                 = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "packer_egress_port_http" {
    type                        = "egress"
    description                 = "Outbound to internet"
    from_port                   = 80
    to_port                     = 80 
    protocol                    = "tcp"
    security_group_id           = aws_security_group.packer_sg.id
    cidr_blocks                 = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "packer_egress_port_https" {
    type                        = "egress"
    description                 = "Outbound to internet"
    from_port                   = 443
    to_port                     = 443
    protocol                    = "tcp"
    security_group_id           = aws_security_group.packer_sg.id
    cidr_blocks                 = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "packer_egress_port_efs" {
    type                        = "egress"
    description                 = "Outbound to efs"
    from_port                   = 2049
    to_port                     = 2049
    protocol                    = "tcp"
    security_group_id           = aws_security_group.packer_sg.id
    source_security_group_id    = aws_security_group.efs_sg.id
}

resource "aws_security_group_rule" "bastion_egress_internet_https" {
    type                        = "egress"
    description                 = "Outbound to Internet"
    from_port                   = 443
    to_port                     = 443
    protocol                    = "tcp"
    security_group_id           = aws_security_group.bastion_sg.id
    cidr_blocks                 = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "alb_egress_to_webserver" {
    type                        = "egress"
    description                 = "Outbound HTTP to Webserver"
    from_port                   = 80
    to_port                     = 80
    protocol                    = "tcp"
    security_group_id           = aws_security_group.alb_sg.id
    source_security_group_id    = aws_security_group.app_sg.id
}

resource "aws_security_group_rule" "aurora_outbound_all" {
    type                        = "egress"
    from_port                   = 0
    to_port                     = 0
    protocol                    = "-1"
    cidr_blocks                 = ["0.0.0.0/0"]
    security_group_id           = aws_security_group.aurora_sg.id
}

resource "aws_security_group_rule" "app_egress_aurora" {
    type                        = "egress"
    description                 = "Outbound to Aurora"
    from_port                   = 3306
    to_port                     = 3306
    protocol                    = "tcp"
    security_group_id           = aws_security_group.app_sg.id
    source_security_group_id    = aws_security_group.aurora_sg.id 
}

resource "aws_security_group_rule" "app_egress_elasticache" {
    type                        = "egress"
    description                 = "Outbound to ElastiCache"
    from_port                   = 6379
    to_port                     = 6379
    protocol                    = "tcp"
    security_group_id           = aws_security_group.app_sg.id
    source_security_group_id    = aws_security_group.elasticache_sg.id
}

resource "aws_security_group_rule" "app_egress_efs" {
    type                        = "egress"
    description                 = "Outbound to EFS"
    from_port                   = 2049
    to_port                     = 2049
    protocol                    = "tcp"
    security_group_id           = aws_security_group.app_sg.id
    source_security_group_id    = aws_security_group.efs_sg.id  
}

resource "aws_security_group_rule" "app_egress_internet_http" {
    type                        = "egress"
    description                 = "Outbound to Internet"
    from_port                   = 80
    to_port                     = 80
    protocol                    = "tcp"
    security_group_id           = aws_security_group.app_sg.id
    cidr_blocks                 = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "app_egress_internet_https" {
    type                        = "egress"
    description                 = "Outbound to Internet"
    from_port                   = 443
    to_port                     = 443
    protocol                    = "tcp"
    security_group_id           = aws_security_group.app_sg.id
    cidr_blocks                 = ["0.0.0.0/0"]
}
