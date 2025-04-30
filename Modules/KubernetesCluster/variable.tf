variable "eks_role" {
  type = string
}
variable "eks_subnet1" {
  type = string
}
variable "eks_subnet2" {
  type = string
}

variable "sg_eksCluster" {
  type = string
}

variable "eks_nodegroup_role" {
  type = string
}

variable "workernode_sg" {
  type = string
}
