resource "kubernetes_manifest" "root_app" {
  manifest = yamldecode(
    file("${path.module}/bootstrap/root-app.yaml")
  )

  depends_on = [
    helm_release.argocd
  ]
}