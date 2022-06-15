variable "region" {
  default = "us-east-1"
}

variable "ssh_public_key_file" {
  description = "update description to The file path of OpenSSH public key to enable ssh access to emr instances. Overridden by on_prem_key_file or cloud_compute_key_file."
  default     = "~/.ssh/id_rsa.pub"
}

variable "ssh_private_key_file" {
  description = "update description to The file path of OpenSSH public key to enable ssh access to emr instances. Overridden by on_prem_key_file or cloud_compute_key_file."
  default     = "~/.ssh/id_rsa"
}

variable "key_file" {
  description = "The path to the key file for the EKS cluster."
  default     = ""
}

variable "map_accounts" {
  description = "Additional AWS account numbers to add to the aws-auth configmap."
  type        = list(string)

  default = [
    "777777777777",
    "888888888888",
  ]
}

variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      rolearn  = "arn:aws:iam::66666666666:role/role1"
      username = "role1"
      groups   = ["system:masters"]
    },
  ]
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      userarn  = "arn:aws:iam::66666666666:user/user1"
      username = "user1"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::66666666666:user/user2"
      username = "user2"
      groups   = ["system:masters"]
    },
  ]
}
