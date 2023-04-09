resource "random_password" "password" {
  length           = 12
  special          = false
  override_special = "_%@"
}

resource "bcrypt_hash" "password" {
  cleartext = random_password.password.result
  cost      = 10
}

resource "helm_release" "argo_cd" {
  name       = "argo"
  chart      = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  version    = "5.28.0"

  create_namespace = true
  namespace        = "argo-cd"

  values = [
    <<EOF
      redis-ha.enabled: true
      controller.replicas: 1
      server.replicas: 2
      repoServer.replicas: 2 
      applicationSet.replicaCount: 2
    EOF
  ]
}


resource "null_resource" "argo_cd_path_secrets" {
  depends_on = [
    helm_release.argo_cd
  ]
  provisioner "local-exec" {
    command = <<EOF
      KUBECONFIG=${path.cwd}/kube_config.yml kubectl -n argo-cd patch secret argocd-secret \
        -p '{"stringData": {
          "admin.password": "${bcrypt_hash.password.id}",
          "admin.passwordMtime": "'$(date +%FT%T%Z)'"
        }}'
    EOF
  }
}
