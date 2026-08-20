resource "aws_iam_role" "eks_cluster_role" {
  name = "eks_cluster_role"

  assume_role_policy = file("${path.module}/assume_cluster_role.json")

  tags = {
    tag-key = "tag-value"
  }
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role" "ec2_workers_role" {
  name = "eks_workers_role"

  assume_role_policy = file("${path.module}/assume_workers_role.json")

  tags = {
    tag-key = "tag-value"
  }
}

resource "aws_iam_role_policy_attachment" "eks_workers_node_policy" {
  role       = aws_iam_role.ec2_workers_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_workers_ecr_policy" {
  role       = aws_iam_role.ec2_workers_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"
}

resource "aws_iam_role_policy_attachment" "eks_workers_CNI_Policy" {
  role       = aws_iam_role.ec2_workers_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

