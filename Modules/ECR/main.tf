resource "aws_ecr_repository" "docker_image_repo" {
  name                 = "Docker_Image"
  image_tag_mutability = "MUTABLE"
  encryption_configuration{
  encryption_type = "KMS"
  }
}
