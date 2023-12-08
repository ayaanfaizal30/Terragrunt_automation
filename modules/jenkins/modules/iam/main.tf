# IAM Policy for Secrets Manager Access
resource "aws_iam_policy" "secrets_manager_access" {
  name        = "Jenkins_SecretsManagerAccessPolicy"
  description = "Policy for accessing AWS Secrets Manager"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowJenkinsToGetSecretValues",
            "Effect": "Allow",
            "Action": "secretsmanager:GetSecretValue",
            "Resource": "*"
        },
        {
            "Sid": "AllowJenkinsToListSecrets",
            "Effect": "Allow",
            "Action": "secretsmanager:ListSecrets",
            "Resource": "*"
        }
    ]
})
}

# IAM Policy for ECR Access
resource "aws_iam_policy" "ecr_access" {
  name        = "ECRAccessPolicyForJenkins"
  description = "Policy for Jenkins to access and push to AWS ECR"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "ecr:GetAuthorizationToken",    # Necessary for Docker login
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:PutImage",                 # Necessary for pushing images
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:DescribeRepositories",
          "ecr:CreateRepository",         # If Jenkins needs to create repositories
          "ecr:ListImages"
        ],
        Effect   = "Allow",
        Resource = "*"  # Specify ARNs of specific repositories if you want to restrict access
      },
    ]
  })
}

# IAM Role for the EC2 Instance
resource "aws_iam_role" "ec2_ssm_role" {
  name = "Jenkins_EC2SSMRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
      },
    ]
  })
}

# Attach Secrets Manager Access Policy to the Role
resource "aws_iam_role_policy_attachment" "secrets_manager_attach" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = aws_iam_policy.secrets_manager_access.arn
}

# Attach ECR Access Policy to the Role
resource "aws_iam_role_policy_attachment" "ecr_attach" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = aws_iam_policy.ecr_access.arn
}

# New IAM Policy for SSM Access
resource "aws_iam_policy" "ssm_access" {
  name        = "SSMAccessPolicyForEC2"
  description = "Policy for EC2 instances to access AWS Systems Manager"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "ssm:DescribeAssociation",
          "ssm:GetDeployablePatchSnapshotForInstance",
          "ssm:GetDocument",
          "ssm:DescribeDocument",
          "ssm:GetManifest",
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:ListAssociations",
          "ssm:ListInstanceAssociations",
          "ssm:PutInventory",
          "ssm:PutComplianceItems",
          "ssm:PutConfigurePackageResult",
          "ssm:UpdateAssociationStatus",
          "ssm:UpdateInstanceAssociationStatus",
          "ssm:UpdateInstanceInformation"
        ],
        Effect   = "Allow",
        Resource = "*"
      },
    ]
  })
}

# Attach SSM Access Policy to the Role
resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = aws_iam_policy.ssm_access.arn
}

# Create an Instance Profile for the EC2 Instance
resource "aws_iam_instance_profile" "ec2_ssm_profile" {
  name = "EC2SSMInstanceProfile_Jenkins"
  role = aws_iam_role.ec2_ssm_role.name
}

