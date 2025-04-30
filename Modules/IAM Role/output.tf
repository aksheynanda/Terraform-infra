output "eks_nodegroup_role" {
  value = aws_iam_role.K8_nodegroup.id
}

output "eks_role" {
  value = aws_iam_role.K8_Cluster.id
}
