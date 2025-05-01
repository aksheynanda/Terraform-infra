resource "aws_ecr_repository" "docker_image_repo" {
  name                 = "dockerimage"
  image_tag_mutability = "MUTABLE"
  encryption_configuration{
  encryption_type = "KMS"
  }
}
resource "aws_ecr_repository" "docker_image_repo2" {
  name                 = "dockerimagelatest"
  image_tag_mutability = "MUTABLE"
  encryption_configuration{
  encryption_type = "KMS"
  }
}
resource "aws_ecr_repository" "docker_image_repo3" {
  name                 = "dockerimagenginix"
  image_tag_mutability = "MUTABLE"
  encryption_configuration{
  encryption_type = "KMS"
  }
}
