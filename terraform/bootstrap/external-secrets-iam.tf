resource "aws_iam_role" "external_secrets_role" {
  name               = "external-secrets-role"
  assume_role_policy = file("${path.module}/assume_external_secret_role.json")
}

resource "aws_iam_policy" "external_secrets_policy" {
  name = "external-secrets-policy"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]

        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "external_secrets_policy_attachment" {
  role       = aws_iam_role.external_secrets_role.name
  policy_arn = aws_iam_policy.external_secrets_policy.arn
}

resource "aws_eks_pod_identity_association" "external_secrets_pod_identity_association" {
  cluster_name = data.aws_eks_cluster.eks_cluster.name

  namespace       = "external-secrets"
  service_account = "external-secrets"

  role_arn = aws_iam_role.external_secrets_role.arn
}