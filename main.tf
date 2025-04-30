module "vpc"{
source = "./Modules/VPC"
}

module "SecurityGroup"{
source = "./Modules/SecurityGroup"
vpc_id=module.vpc.vpc_id
}


module "IAM"{
source = "./Modules/IAM Role"
}

module "K8Cluster"{
source = "./Modules/KubernetesCluster"
eks_subnet1 = module.vpc.eks_subnet1
eks_subnet2 = module.vpc.eks_subnet2
eks_nodegroup_role = module.IAM.eks_nodegroup_role
eks_role = module.IAM.eks_role
sg_eksCluster = module.SecurityGroup.sg_eksCluster
workernode_sg = module.SecurityGroup.workernode_sg
}

module "rds"{
source = "./Modules/RDS"
rds_subnet1 = module.vpc.rds_subnet1
rds_subnet2 = module.vpc.rds_subnet2
rds_sg = module.SecurityGroup.rds_sg
}

module "redis"{
source = "./Modules/Redis"
redis_subnet1 = module.vpc.rds_subnet1
redis_subnet2 = module.vpc.rds_subnet2
redis_sg = module.SecurityGroup.redis_sg
}

module "ECR"{
source = "./Modules/ECR"
}
module "S3"{
source = "./Modules/S3"
}
