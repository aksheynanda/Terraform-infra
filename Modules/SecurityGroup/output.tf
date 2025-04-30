output "sg_eksCluster" {
  value = "aws_security_group.eks_cluster_sg.id"
}
output "workernode_sg" {
  value = "aws_security_group.eks_cluster_sg.id"
}

output "redis_sg" {
  value = "aws_security_group.redis_sg.id"
}

output "rds_sg" {
  value = "aws_security_group.rds_sg.id"
}
