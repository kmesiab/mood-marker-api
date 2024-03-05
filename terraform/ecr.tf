resource "aws_ecr_repository" "ecr_repository" {
  name                 = "mood-marker-api"
  image_tag_mutability = "MUTABLE"
}

output "repository_url" {
  value = aws_ecr_repository.ecr_repository.repository_url
}