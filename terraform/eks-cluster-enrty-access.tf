resource "aws_eks_access_entry" "devops" {
  cluster_name  = aws_eks_cluster.eks_cluster.name
  principal_arn = "arn:aws:iam::893089245803:role/aws-reserved/sso.amazonaws.com/eu-central-1/AWSReservedSSO_DevOps-Access_72393c0920ecdd3e"
}

resource "aws_eks_access_policy_association" "clyster_admins" {
  cluster_name  = aws_eks_cluster.eks_cluster.name
  principal_arn = aws_eks_access_entry.devops.principal_arn

  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }
}
