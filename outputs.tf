output "workers_asg_names" {
  description = "names of the autoscaling groups"
  value       = module.eks_cluster.workers_asg_names
}
output "cluster_name" {
  description = "eks cluster name"
  value       = module.eks_cluster.cluster_id
}
