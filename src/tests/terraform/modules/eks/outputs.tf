output "endpoint" {
  value = aws_eks_cluster.demo_cluster.endpoint
}

output "cluster_id" {
  value = aws_eks_cluster.demo_cluster.id
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.demo_cluster.certificate_authority.0.data
}

output "eks_node_group_id" {
  value = aws_eks_node_group.demo_cluster.id
}
