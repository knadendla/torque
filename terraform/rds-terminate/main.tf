
locals {
  sizeMap = {
    "small" = "db.t2.small"
    "medium" = "db.t2.medium"
    "large" = "db.t2.large"
  }
  instance_class = lookup(local.sizeMap, lower(var.size), "db.t4g.medium")
  # sandbox_id = "sb${substr( uuid() , 0 ,6)}"
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

data "aws_vpc" "default" {
  default = true
} 

data "aws_subnets" "apps_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# data "aws_subnet_ids" "apps_subnets" {
#   vpc_id = "${aws_default_vpc.default.id}"
#   # filter {
#   #   name = "tag:Name"
#   #   values = ["app-rds*"]
#   # }
# }

resource "aws_db_subnet_group" "rds" {
  name = "rds-${var.sandbox_id}-subnet-group"
  subnet_ids = data.aws_subnets.apps_subnets.ids

  tags = {
    Name = "RDS-subnet-group"
  }
}

resource "aws_security_group" "rds" {
  name        = "rds-${var.sandbox_id}_sg"
  description = "Allow all inbound traffic"
  vpc_id      = "${data.aws_vpc.default.id}"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_db_instance" "default" {
  allocated_storage    = var.allocated_storage
  storage_type         = var.storage_type
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = local.instance_class
  identifier           = "rds1-${var.sandbox_id}"
  db_name              = "${var.db_name}"
  username             = "${var.username}"
  password             = "${random_password.password.result}"
  publicly_accessible  = true
  db_subnet_group_name = "${aws_db_subnet_group.rds.id}"
  vpc_security_group_ids    = ["${aws_security_group.rds.id}"]
  skip_final_snapshot       = true
  final_snapshot_identifier = "Ignore"
  deletion_protection  = true
}

resource "null_resource" "torque_delete_env" {
  depends_on = [ aws_db_instance.default ]
  triggers = {
    region = var.region
    dbid  = aws_db_instance.default.identifier
  }

  provisioner "local-exec" {
    on_failure  = fail
    command     = "/bin/bash ./scripts/remove-db-protection.sh"
    when = destroy


    environment = {
      REGION           = self.triggers.region
      DBID             = self.triggers.dbid

    }
  }
}