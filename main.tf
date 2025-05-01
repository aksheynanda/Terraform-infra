terraform {
  required_version = ">= 1.0"
  backend "s3" {
    bucket = "test-k8-backend"
    key    = "terraform/terraform.tfstate"
    region = "us-east-1"
  }
}



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
