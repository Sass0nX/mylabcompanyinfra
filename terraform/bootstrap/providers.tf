provider "helm" {
  kubernetes = {
    host = data.aws_eks_cluster.eks_cluster.endpoint
    cluster_ca_certificate = base64decode(
      data.aws_eks_cluster.eks_cluster.certificate_authority[0].data
    )

    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"

      args = [
        "eks",
        "get-token",
        "--cluster-name",
        data.aws_eks_cluster.eks_cluster.name
      ]
    }
  }
}

provider "kubernetes" {
  host = data.aws_eks_cluster.eks_cluster.endpoint

  cluster_ca_certificate = base64decode(
    data.aws_eks_cluster.eks_cluster.certificate_authority[0].data
  )

  exec {
    api_version = "client.authentication.k8s.io/v1"
    command     = "aws"

    args = [
      "eks",
      "get-token",
      "--cluster-name",
      data.aws_eks_cluster.eks_cluster.name,
      "--region",
      "eu-central-1"
    ]
  }
}