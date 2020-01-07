variable "eks_cluster_name" {
  type = string
}

variable "eks_node_group_name" {
  type = string
}

variable "eks_iam_role_name" {
  type = string
}

variable "eks_subnet_ids" {
  type = list
}
