# Step 1: Create an IAM identity provider for GitHub
resource "aws_iam_openid_connect_provider" "openid_connect_provider" {
  url = "https://token.actions.githubusercontent.com"
  client_id_list = [
    "sts.amazonaws.com",
  ]
  thumbprint_list = [
    "959CB2B52B4AD201A593847ABCA32FF48F838C2E",
  ]
  tags = {
    IaC = "True"
  }
}

# Step 2: Create an IAM role for the ECR repository
resource "aws_iam_role" "ecr_role" {
  name = "ecr_role"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Principal": {
                "Federated": "arn:aws:iam::381492262362:oidc-provider/token.actions.githubusercontent.com"
            },
            "Condition": {
                "StringEquals": {
                    "token.actions.githubusercontent.com:aud": [
                        "sts.amazonaws.com"
                    ],
                    "token.actions.githubusercontent.com:sub": [
                        "repo:rcmonteiro/devops-create-image-nest-api:ref:refs/heads/main"
                    ]
                }
            }
        }
    ]
  })

  # Step 3: Attach the AmazonEC2ContainerRegistryPowerUser managed policy to the IAM role
  inline_policy {
    name = "ecr-app-permission"

    # Step 5: Insert the Statement for the apprunner and IAM
    policy = jsonencode({
      "Version": "2012-10-17",
      "Statement": [
        {
         "Action": "apprunner:*" 
         "Effect": "Allow",
         "Resource": "*"
        },
        {
         "Action": [
            "iam:PassRole",
            "iam:CreateServiceLinkedRole"
         ],
         "Effect": "Allow",
         "Resource": "*"
        },
        {
          "Effect": "Allow",
          "Action": [
              "ecr:GetDownloadUrlForLayer",
              "ecr:BatchGetImage",
              "ecr:BatchCheckLayerAvailability",
              "ecr:PutImage",
              "ecr:InitiateLayerUpload",
              "ecr:UploadLayerPart",
              "ecr:CompleteLayerUpload",
              "ecr:GetAuthorizationToken"
          ],
          "Resource": "*"
        }
      ]
    })
  }

  tags = {
    IaC = "True"
  }
}

# Step 4: Create an IAM role for the App Runner
resource "aws_iam_role" "app_runner_role" {
  name = "app_runner_role"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "build.apprunner.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ]

  tags = {
    IaC = "True"
  }
}

  
