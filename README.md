# Sample EKS Terraform Script

## Prerequisites:
  1. Install terraform. See https://learn.hashicorp.com/tutorials/terraform/install-cli.
  2. Install aws cli. See https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html.
  3. Configure aws by running `aws configure` and put in correct information
  4. Generate ssh key by running ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa

## Create EKS cluster
  1. Run `terraform init`
  2. Run `terraform apply`
  3. After the cluster is created, run `aws eks update-kubeconfig --region us-east-1 --name <test-eks-xxxxxxxx>`

## Destroy cluster
  4. Run `terraform destroy`
