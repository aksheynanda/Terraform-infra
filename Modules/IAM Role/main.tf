# Creating IAM role for eks Cluster
resource "aws_iam_role" "K8_Cluster" {
  name               = "K8_ClusterRole"
  assume_role_policy = jsonencode({
  Version = "2012-10-17"
  Statement = [
    {
      Action = ["sts:AssumeRole","sts:TagSession"]
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "eks.amazonaws.com"
      }
    },
  ]
})
}

resource "aws_iam_role_policy_attachment" "eks-cluster" {
  role       = aws_iam_role.K8_Cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks-cluster1" {
  role       = aws_iam_role.K8_Cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSBlockStoragePolicy"
}

resource "aws_iam_role_policy_attachment" "eks-cluster2" {
  role       = aws_iam_role.K8_Cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSComputePolicy"
}

resource "aws_iam_role_policy_attachment" "eks-cluster3" {
  role       = aws_iam_role.K8_Cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSLoadBalancingPolicy"
}

resource "aws_iam_role_policy_attachment" "eks-cluster4" {
  role       = aws_iam_role.K8_Cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSNetworkingPolicy"
}


#Creating IAM role or EKS NodeGroup
resource "aws_iam_role" "K8_nodegroup" {
  name               = "K8_nodegroup"
  assume_role_policy = jsonencode({
  Version = "2012-10-17"
  Statement = [
    {
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    },
  ]
})
}

resource "aws_iam_role_policy_attachment" "eks-nodegroup1" {
  role       = aws_iam_role.K8_nodegroup.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "eks-nodegroup2" {
  role       = aws_iam_role.K8_nodegroup.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "eks-nodegroup3" {
  role       = aws_iam_role.K8_nodegroup.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}


#Creating IAM role or IRSA
/*
resource "aws_iam_role" "IRSA" {
  name               = "IRSA_K8"
}

resource "aws_iam_role_policy" "IRSA_policy_1" {
  name = "IRSA_Policy"
  role = aws_iam_role.IRSA_K8.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue",
        ]
        Effect   = "Allow"
        Resource = "arn:aws:secretsmanager:us-east-1a:851765306105:secret:your-secret-name-*"
      },
    ]
  })
}
*/
