provider "aws" {
  region = var.region
}

data "aws_eks_cluster" "cluster" {
  name = module.eks_cluster.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks_cluster.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
}

data "aws_availability_zones" "available" {
}

locals {
  cluster_name  = "test-eks-${random_string.suffix.result}"
  key_pair_name = trimsuffix(basename(var.key_file), ".pem")
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

resource "aws_key_pair" "key_pair" {
  count      = var.key_file == "" ? 1 : 0
  key_name   = "key_pair_eks${random_string.suffix.result}"
  public_key = file(var.ssh_public_key_file)
}

resource "aws_security_group" "worker_group_mgmt" {
  name_prefix = "worker_group_mgmt"
  vpc_id      = module.vpc.vpc_id

  // allow all inbound traffic within security group
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  // allow all outbound traffic to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // allow SSH inbound traffic from anywhere
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "all_worker_mgmt" {
  name_prefix = "all_worker_management"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/8",
      "172.16.0.0/12",
      "192.168.0.0/16",
    ]
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.47"

  name                 = "test-vpc"
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}

module "eks_cluster" {
  source          = "git::https://github.com/terraform-aws-modules/terraform-aws-eks.git?ref=v17.24.0"
  cluster_name    = local.cluster_name
  cluster_version = "1.22"
  // subnets         = module.vpc.private_subnets
  subnets = module.vpc.public_subnets // any problems of using public subnets?

  tags = {
    Environment = "test"
    GithubRepo  = "terraform-aws-eks"
    GithubOrg   = "terraform-aws-modules"
  }

  vpc_id = module.vpc.vpc_id

  worker_groups = [
    {
      name                          = "eks"
      instance_type                 = "r5.2xlarge"
      #capacity_type                 = "SPOT"
      #spot_price                    = 1
      #kubelet_extra_args            = "--node-labels=node.kubernetes.io/lifecycle=spot"
      additional_userdata           = "echo foo bar"
      asg_max_size                  = 10
      asg_desired_capacity          = 2
      root_volume_type              = "gp2"
      root_volume_size              = "256"
      additional_security_group_ids = [aws_security_group.worker_group_mgmt.id]
      public_ip                     = true
      key_name                      = var.key_file == "" ? aws_key_pair.key_pair[0].key_name : local.key_pair_name
    },
  ]

  worker_additional_security_group_ids = [aws_security_group.all_worker_mgmt.id]
  map_roles                            = var.map_roles
  map_users                            = var.map_users
  map_accounts                         = var.map_accounts
}
