with (import <nixpkgs> {});

stdenv.mkDerivation {

  KUBECONFIG = "kube_config.yml";

  name = "k8s-simple";
  buildInputs = [
    terraform
    kubectl
    kind
    kubernetes-helm-wrapped
    argocd
    jq
  ];
}