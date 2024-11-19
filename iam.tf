resource "aws_iam_role" "this" {
  name = var.role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = [
            "codepipeline.amazonaws.com",
            "codebuild.amazonaws.com"
          ]
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodePipeline_FullAccess"
}

resource "aws_iam_role_policy" "ecr_policy" {
  name = "ecr_policy"
  role = aws_iam_role.this.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability"
        ]
        Resource = "arn:aws:ecr:us-east-1:269629789070:repository/devops-fullstack-demo"
      },
      {
        Effect   = "Allow",
        Action   = "ecr:GetAuthorizationToken",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "codestar_connections_policy" {
  name = "codestar_connections_policy"
  role = aws_iam_role.this.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "codestar-connections:*"
        ]
        Resource = "arn:aws:codeconnections:us-east-1:830701124395:connection/b2c5c292-5fb3-41e1-b0d5-deacc5f6f6cb"
      }
    ]
  })
}

resource "aws_iam_role_policy" "fullstack_policy" {
  name = "fullStackPolicy"
  role = aws_iam_role.this.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:GetBucketVersioning",
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:DeleteObject",
          "ecr:*",
          "codebuild:*",
          "codepipeline:*",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:CreateLogGroup",
          "iam:PassRole",
        ]
        Resource = [
          "arn:aws:s3:::${var.project_name}-artifacts/*",
          "arn:aws:s3:::${var.project_name}-artifacts",
          "arn:aws:ecr:us-east-1:269629789070:repository/devops-fullstack-demo",
          "arn:aws:codebuild:us-east-1:830701124395:project/${var.project_name}-build",
          "arn:aws:codepipeline:us-east-1:830701124395:${var.project_name}-pipeline",
          "arn:aws:logs:us-east-1:830701124395:log-group:*",
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy" "s3_policy" {
  name = "s3_policy"
  role = aws_iam_role.this.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:GetBucketVersioning",
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:DeleteObject"
        ]
        Resource = [
          "arn:aws:s3:::${var.project_name}-artifacts/*",
          "arn:aws:s3:::${var.project_name}-artifacts"
        ]
      }
    ]
  })
}