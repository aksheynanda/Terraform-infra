output "eks_subnet1" {
  value = aws_subnet.main_subnet_prieks_A.id
}

output "eks_subnet2" {
  value = aws_subnet.main_subnet_prieks_B.id
}

output "rds_subnet1" {
  value = aws_subnet.main_subnet_prirds_A.id
}

output "rds_subnet2" {
  value = aws_subnet.main_subnet_prirds_B.id
}

output "vpc_id" {
  value = aws_vpc.main_vpc.id
}
