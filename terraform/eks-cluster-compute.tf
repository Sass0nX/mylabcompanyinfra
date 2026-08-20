resource "aws_eks_cluster" "eks_cluster" {
  name = "eks_cluster"

  access_config {
    authentication_mode = "API"
  }

  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = "1.35"

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = true

    subnet_ids = [
      aws_subnet.private1.id,
      aws_subnet.private2.id
    ]
  }
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
  ]
}

resource "aws_eks_node_group" "eks_workers_node" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "eks_workers_node"
  node_role_arn   = aws_iam_role.ec2_workers_role.arn
  subnet_ids      = [aws_subnet.private1.id, aws_subnet.private2.id]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_workers_node_policy,
    aws_iam_role_policy_attachment.eks_workers_ecr_policy,
    aws_iam_role_policy_attachment.eks_workers_CNI_Policy,
  ]
}

resource "aws_eks_addon" "pod_identity_agent" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "eks-pod-identity-agent"
}