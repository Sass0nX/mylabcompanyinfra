resource "aws_iam_policy" "external_dns_policy" {
  name = "ExternalDNSRoute53Policy"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "route53:ChangeResourceRecordSets"
        ]

        Resource = [
          "arn:aws:route53:::hostedzone/*"
        ]
      },
      {
        Effect = "Allow"

        Action = [
          "route53:ListHostedZones",
          "route53:ListResourceRecordSets",
          "route53:ListTagsForResource"
        ]

        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "external_dns_role" {
  name = "external-dns"

  assume_role_policy = file("${path.module}/assume_external_dns_role.json")
}

resource "aws_iam_role_policy_attachment" "external_dns_policy_attachment" {
  role       = aws_iam_role.external_dns_role.name
  policy_arn = aws_iam_policy.external_dns_policy.arn
}

resource "aws_eks_pod_identity_association" "external_dns_pod_identity_association" {
  cluster_name    = data.aws_eks_cluster.eks_cluster.name

  namespace       = "external-dns"
  service_account = "external-dns"

  role_arn = aws_iam_role.external_dns_role.arn
}