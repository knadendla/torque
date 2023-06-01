# https://github.com/terraform-aws-modules/terraform-aws-eks/tree/v17.24.0

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.30.1"

  cluster_version = "1.23"
  cluster_name    = var.cluster-name
  vpc_id          = module.vpc.vpc_id
  subnet_ids        = module.vpc.private_subnets

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_enabled_log_types = var.cluster_enabled_log_types
  
  manage_aws_auth_configmap = var.manage_aws_auth_configmap

   eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
    instance_types = var.instance_types
  }

  eks_managed_node_groups = {
    ng-01 = {
      min_size     = var.min_size
      max_size     = var.max_size
      desired_size = var.desired_size
      instance_types = var.instance_types # ["t3.medium","t3.xlarge"...]
      capacity_type  = "ON_DEMAND"
    }
  }


  aws_auth_accounts = [
    # AWS account number must be provided in tf variables to allow RBAC to EKS for anyone in the account by default.
    # Must be changed to less permissive RBAC.
      var.account
  ]

  # Change the roleArn and username (which is actually the role name in IAM) to match required AWS account.
  # Should be the group IT assigns to the developers in order to keep it strictly IT prerogative.
  aws_auth_roles = [
    {
      rolearn  = var.role_arn
      username = var.role_username
      groups   = ["system:masters"]
    },
  ]

  aws_auth_users = [
    # {
    #   rolearn  = "arn:aws:iam::123456789:user/user"
    #   username = "PowerUsers"
    #   groups   = ["system:masters"]
    # },
  ]

  node_security_group_additional_rules = {
    CloudAMQP = {
      description      = "Connection to CloudAMQP"
      protocol         = "tcp"
      from_port        = 5672
      to_port          = 5672
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    },
    Postgres = {
      description      = "Connection to Postgres"
      protocol         = "tcp"
      from_port        = 5432
      to_port          = 5432
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    },
    Redis = {
      description      = "Connection to Redis"
      protocol         = "tcp"
      from_port        = 6379
      to_port          = 6379
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
    ingress_allow_access_from_control_plane = {
      type                          = "ingress"
      protocol                      = "tcp"
      from_port                     = 9443
      to_port                       = 9443
      source_cluster_security_group = true
      description                   = "Allow access from control plane to webhook port of AWS load balancer controller"
    }
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
    torque = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 80
      to_port          = 80
      type             = "ingress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }
}


resource "aws_eks_addon" "aws-ebs-csi-driver" {
  cluster_name = var.cluster-name
  addon_name   = "aws-ebs-csi-driver"
  depends_on = [
    module.eks
  ]
}

resource "aws_iam_policy_attachment" "ebs-csi-policyattachment" {
  name       = "ebs-csi-policyattachment"
  roles = [module.eks.eks_managed_node_groups.ng-01.iam_role_name] 
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}
