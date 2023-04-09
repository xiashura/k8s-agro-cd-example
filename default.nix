with (import <nixpkgs> { });
let
  kind-cluster-install = pkgs.writeShellScriptBin "kind-cluster-install" ''
    kind create cluster --name=k8s-agro-cd-example --config=kind/config.yml
    kind get kubeconfig --name k8s-agro-cd-example > kube_config.yml 
  '';
  kind-cluster-delete = pkgs.writeShellScriptBin "kind-cluster-delete" ''
    kind delete clusters k8s-agro-cd-example
  '';
in stdenv.mkDerivation {

  KUBECONFIG = "k8s-agro-cd-example";

  name = "k8s-simple";
  buildInputs = [
    kind
    kind-cluster-install
    kind-cluster-delete
    terraform
    kubectl
    kind
    kubernetes-helm-wrapped
    argocd
    jq
  ];
}
