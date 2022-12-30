# resource "kubernetes_namespace" "msa" {
#   metadata {
#     # annotations = {
#     # }

#     labels = {
#       istio-injection = "enabled"
#     }

#     name = "msa"
#   }

# }