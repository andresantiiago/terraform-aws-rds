# Módulo do RDS para o outpost

## Variáveis
A documentação para o uso das variáveis se encontra na doc oficial do terraform:
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance

## Security Group
https://github.com/terraform-aws-modules/terraform-aws-security-group/blob/master/rules.tf

## Exemplo

```go
provider "aws" {
  region = "sa-east-1"
}

module "rds" {
  depends_on  = [ module.sg_mysql ]
  source      = ""
  db_name                   = "mydb"
  identifier                = "teste-mysql"
  engine                    = "mysql"
  engine_version            = "8.0"
  username                  = "foo"
  password                  = "foobarbaz"
  instance_class            = "db.m5.large"
  multi_az                  = false
  availability_zone         = "sa-east-1a"
  storage_type              = "gp2"
  allocated_storage         = 10
  max_allocated_storage     = 20
  storage_encrypted         = true
  skip_final_snapshot       = true
  customer_owned_ip_enabled = true
  publicly_accessible       = false
  subnet_ids                = ["subnet-123"]
  security_group_rules      = {rule = mysql-tcp, cidr-block = 10.0.0.0/8}
  
  tags = {
    env = "development"
  }
}
```
