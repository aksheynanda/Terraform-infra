resource "aws_s3_bucket" "app_bucket" {
  bucket = "docker-artifact-s3"  # Must be globally unique

  tags = {
    Name        = "AppBucket"
    Environment = "dev"
  }
}
