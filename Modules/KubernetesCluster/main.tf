resource "aws_kms_key" "eks_secrets" {
  description = "KMS key for EKS secrets encryption"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}


resource "aws_eks_cluster" "EKS" {
  name     = "eks-cluster"
  role_arn = "arn:aws:iam::851765306105:role/K8_ClusterRole"

  vpc_config {
    subnet_ids = [
      var.eks_subnet1,
      var.eks_subnet2
    ]
    security_group_ids = [var.sg_eksCluster]
    endpoint_private_access = true
    endpoint_public_access  = false
  }

  kubernetes_network_config {
    service_ipv4_cidr = "172.20.0.0/16"
  }

  enabled_cluster_log_types = ["api", "audit", "authenticator"]

  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
  }

  encryption_config {
  resources = ["secrets"]

  provider {
    key_arn = aws_kms_key.eks_secrets.arn
  }
}



  tags = {
    Environment = "dev"
    Name        = "eks-cluster"
    "kubernetes.io/cluster/eks-cluster" = "owned"
  }
}

resource "aws_eks_addon" "vpc-cni" {
  cluster_name = aws_eks_cluster.EKS.name
  addon_name   = "vpc-cni"
}

resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.EKS.name
  addon_name   = "coredns"
}

resource "aws_eks_addon" "ebs" {
  cluster_name = aws_eks_cluster.EKS.name
  addon_name   = "EBS CSI"
}

resource "aws_launch_template" "eks_node_lt" {
  name_prefix   = "eks-node-lt"
  image_id      = "ami-0b86aaed8ef90e45f"
  instance_type = "t2.micro"

  vpc_security_group_ids = [var.workernode_sg]

  key_name = "K8_Workernode"
}

resource "aws_eks_node_group" "worker_nodes" {
  depends_on = [aws_eks_cluster.EKS]
  cluster_name    = aws_eks_cluster.EKS.name
  node_group_name = "worker-group"
  node_role_arn   = var.eks_nodegroup_role
  subnet_ids      = [var.eks_subnet1, var.eks_subnet2]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  launch_template {
    id      = aws_launch_template.eks_node_lt.id
    version = "$Latest"
  }
  tags = {
    "k8s.io/cluster-autoscaler/enabled" = "true"
    "k8s.io/cluster-autoscaler/eks-cluster" = "owned"
  }
}


data "tls_certificate" "irsa" {
  depends_on = [aws_eks_node_group.worker_nodes]
  url = aws_eks_cluster.EKS.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "irsa" {
  depends_on = [aws_eks_node_group.worker_nodes]
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.irsa.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.EKS.identity[0].oidc[0].issuer
}
