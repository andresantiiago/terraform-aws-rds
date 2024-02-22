locals {
  sg_rules = [for i in var.security_group_rules:
    {
        rule        = i["rule"]
        cidr_blocks = i["cidr_block"]
    }
  ]
}

resource "aws_kms_key" "db_kms" {
  description = var.db_name
  is_enabled  = true
}

resource "aws_kms_ciphertext" "password" {
  key_id = aws_kms_key.db_kms.key_id
  plaintext = var.password
}

resource "aws_kms_ciphertext" "username" {
  key_id = aws_kms_key.db_kms.key_id
  plaintext = var.username
}

data "aws_kms_ciphertext" "password" {
  key_id = aws_kms_key.db_kms.key_id
  plaintext = var.password
}

data "aws_kms_ciphertext" "username" {
  key_id = aws_kms_key.db_kms.key_id
  plaintext = var.username
}

data "aws_kms_secrets" "user_pass" {
  secret {
    name    = "username"
    payload = data.aws_kms_ciphertext.username.ciphertext_blob
  }

  secret {
    name    = "password"
    payload = data.aws_kms_ciphertext.password.ciphertext_blob
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = var.db_name
  subnet_ids = var.subnet_ids

  tags = var.tags
}

resource "aws_db_instance" "db_rds" {
  depends_on  = [ module.sg_rds ]

  db_name               = var.db_name
  identifier            = var.identifier

  engine                = var.engine
  engine_version        = var.engine_version

  username              = "${data.aws_kms_secrets.user_pass.plaintext["username"]}"
  password              = "${data.aws_kms_secrets.user_pass.plaintext["password"]}"
  # manage_master_user_password = true
  instance_class        = var.instance_class

  multi_az              = var.multi_az
  availability_zone     = var.availability_zone
  db_subnet_group_name  = aws_db_subnet_group.db_subnet_group.id

  storage_type          = var.storage_type
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_encrypted     = var.storage_encrypted

  skip_final_snapshot   = var.skip_final_snapshot

  customer_owned_ip_enabled = var.customer_owned_ip_enabled
  publicly_accessible       = var.publicly_accessible

  vpc_security_group_ids = [ module.sg_rds.security_group_id ]

  tags = var.tags
}

module "sg_rds" {
  source = "terraform-aws-modules/security-group/aws"

  name        = format("%s-sg",var.identifier)
  vpc_id      = var.vpc_id

  ingress_with_cidr_blocks = local.sg_rules

  tags = var.tags
}