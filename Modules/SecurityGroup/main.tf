resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Allow inbound traffic to RDS from Kubernetes worker nodes"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [aws_security_group.add_pod_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-sg"
  }
}

resource "aws_security_group" "redis_sg" {
  name        = "redis_sg"
  description = "Allow Redis traffic from Kubernetes worker nodes"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    security_groups = [aws_security_group.add_pod_sg.id,aws_security_group.latest_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "redis-sg"
  }
}


resource "aws_security_group" "add_pod_sg" {
  name        = "add_pod_sg"
  description = "Allow inbound traffic to RDS from Kubernetes worker nodes"
  vpc_id      = var.vpc_id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "add-pod-sg"
  }
  }


resource "aws_security_group" "latest_sg" {
    name        = "latest_pod_sg"
    description = "Allow inbound traffic to RDS from Kubernetes worker nodes"
    vpc_id      = var.vpc_id
    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Name = "latest-pod-sg"
    }
    }

    resource "aws_security_group" "alb_sg" {
      name        = "alb-security-group"
      description = "Security group for ALB"
      vpc_id      = var.vpc_id

      ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }

      ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }

      egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    }

resource "aws_security_group" "worker_nodes_sg" {
      name        = "eks-worker-nodes-sg"
      description = "Security group for EKS worker nodes"
      vpc_id      = var.vpc_id

      ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        security_groups = [aws_security_group.alb_sg.id]  # Allow traffic from ALB
      }

      ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        security_groups = [aws_security_group.alb_sg.id]  # Allow traffic from ALB
      }

      ingress {
        from_port   = 5000
        to_port     = 5000
        protocol    = "tcp"
        cidr_blocks = ["10.0.0.0/16"]  # Allow internal traffic in VPC
      }

      egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    }

    resource "aws_security_group" "eks_cluster_sg" {
      name        = "eks-cluster-sg"
      description = "Security group for EKS cluster"
      vpc_id      = var.vpc_id

      ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["10.0.0.0/16"]  # Internal VPC traffic only
      }

      egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    }
