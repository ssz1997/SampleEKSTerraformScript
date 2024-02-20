# Sample EKS Terraform Script

## Prerequisites:
  0. A machine that will be used as k8s control plane
  1. Install terraform. See https://learn.hashicorp.com/tutorials/terraform/install-cli.
  2. Install aws cli. See https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html.
  3. Configure aws by running `aws configure` and put in correct information
  4. Generate ssh key by running ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa

## Create EKS cluster
  0. Download the files in this repo
  1. Run `terraform init`
  2. Run `terraform apply -auto-approve`. This step takes around 10-12 minutes
  3. After the cluster is created, run `aws eks update-kubeconfig --region us-east-1 --name <test-eks-xxxxxxxx>`. The name is at the end of the stdout of step 2, in the form of `test-eks-xxxxxxx`

## Destroy cluster
  4. Run `terraform destroy -auto-approve`

## EKS configuration
  1. Cluster version: modify main.tf line 114
  2. ec2 instance type: modify main.tf line 129
  3. Launch on-demand ec2 instances instead of spot instances: comment out main.tf line 130, 131, and 132
  4. Launch different ec2 instance types: add another worker group in the form of main.tf line 127 - 141

## If the control plane is an ec2 instance
  Above commands are in ec2-setup.sh
