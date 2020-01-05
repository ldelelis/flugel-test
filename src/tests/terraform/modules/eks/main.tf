resource "aws_iam_role" "demo_cluster" {
  name               = var.eks_iam_role_name
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role" "demo_node_group" {
  name               = "${var.eks_iam_role_name}-node-group"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "demo_cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.demo_cluster.name
}

resource "aws_iam_role_policy_attachment" "demo_cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.demo_cluster.name
}

resource "aws_iam_role_policy_attachment" "demo_node_group-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.demo_node_group.name
}

resource "aws_iam_role_policy_attachment" "demo_node_group-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.demo_node_group.name
}

resource "aws_iam_role_policy_attachment" "demo_node_group-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.demo_node_group.name
}

resource "aws_eks_cluster" "demo_cluster" {
  name     = var.eks_cluster_name
  role_arn = aws_iam_role.demo_cluster.arn

  vpc_config {
    subnet_ids              = [for s in var.eks_subnet_ids : tostring(s)]
    endpoint_private_access = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.demo_cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.demo_cluster-AmazonEKSServicePolicy,
  ]
}

resource "aws_eks_node_group" "demo_cluster" {
  cluster_name    = aws_eks_cluster.demo_cluster.name
  node_group_name = var.eks_node_group_name
  node_role_arn   = aws_iam_role.demo_node_group.arn
  subnet_ids      = var.eks_subnet_ids

  instance_types = ["t3.micro"]
  disk_size      = 10

  scaling_config {
    min_size     = 1
    desired_size = 2
    max_size     = 3
  }

  remote_access {
    ec2_ssh_key = "delete"
  }

  depends_on = [
    aws_iam_role_policy_attachment.demo_node_group-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.demo_node_group-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.demo_node_group-AmazonEC2ContainerRegistryReadOnly,
  ]
}
