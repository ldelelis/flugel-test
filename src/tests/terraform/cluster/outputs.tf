
output "k8s_load_balancer_ip" {
  value = kubernetes_service.hello_world.load_balancer_ingress[0].hostname
}
