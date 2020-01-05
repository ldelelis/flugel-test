terraform {
  required_version = ">=0.12.0"
}

data "aws_eks_cluster_auth" "demo_cluster_auth" {
  name = module.test_cluster.cluster_id
}


provider "aws" {
  profile = var.aws_profile
  region  = "us-east-1"
}

provider "kubernetes" {
  host                   = module.test_cluster.endpoint
  cluster_ca_certificate = base64decode(module.test_cluster.kubeconfig-certificate-authority-data)
  token                  = data.aws_eks_cluster_auth.demo_cluster_auth.token
  load_config_file       = false
}

module "test_cluster_vpc" {
  source = "../modules/vpc"

  vpc_cidr_block = var.eks_vpc_cidr_block
  vpc_tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}" : "shared"
  }
}


module "test_cluster" {
  source = "../modules/eks"

  eks_cluster_name    = var.eks_cluster_name
  eks_node_group_name = var.eks_cluster_node_group_name
  eks_iam_role_name   = var.eks_iam_role_name
  eks_subnet_ids      = module.test_cluster_vpc.vpc_subnet_ids
}

resource "kubernetes_pod" "hello_world" {
  metadata {
    name = "hello-world"
    labels = {
      App = "helloworld"
    }
  }

  spec {
    container {
      image = "strm/helloworld-http"
      name  = "hello-world"

      port {
        container_port = 80
      }
    }
  }

  depends_on = [
    module.test_cluster.eks_node_group_id
  ]
}

resource "kubernetes_service" "hello_world" {
  metadata {
    name = "hello-world"
  }

  spec {
    selector = {
      App = kubernetes_pod.hello_world.metadata[0].labels.App
    }
    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}
