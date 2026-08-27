data "aws_eks_cluster" "eks_cluster" {
  name = "eks_cluster"
}

data "aws_vpc" "eks" {
  tags = {
    Name = "eks-lab-vpc"
  }
}