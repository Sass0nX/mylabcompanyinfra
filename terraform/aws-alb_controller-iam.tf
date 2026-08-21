resource "aws_iam_role" "alb_controller_role" {
  name = "alb_controller_role"
  assume_role_policy = file("${path.module}/assume_alb_controller_role.json")
}

resource "aws_iam_policy" "alb_controller_policy" {
  name = "alb_controller-policy"

  policy = file("${path.module}/iam_policy.json")
}
  
resource "aws_iam_role_policy_attachment" "alb_controller_policy_attachment" {
  role       = aws_iam_role.alb_controller_role.name
  policy_arn = aws_iam_policy.alb_controller_policy.arn
}

resource "aws_eks_pod_identity_association" "alb_controller_pod_identity_association" {
  cluster_name = aws_eks_cluster.eks_cluster.name

  namespace       = "kube-system"
  service_account = "kube-system"

  role_arn = aws_iam_role.alb_controller_role.arn
}