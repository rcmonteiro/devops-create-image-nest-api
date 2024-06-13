resource "aws_ecr_repository" "rcmonteiro_devops_nest_api" {
  name = "rcmonteiro_devops_nest_ci"

  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    IaC = "True"
  }
}
