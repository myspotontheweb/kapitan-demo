//
// Generate a ArgoCD Application object and an optional secret
//
local kap = import "lib/kapitan.libjsonnet";
local p   = kap.inventory().parameters;

{
  "application": {
    "apiVersion": "argoproj.io/v1alpha1",
    "kind": "Application",
    "metadata": {
      "finalizers": [
        "resources-finalizer.argocd.argoproj.io"
      ],
      "name": p.target_name,
      "namespace": p.argocd.namespace
    },
    "spec": {
      "project": p.application.project,
      "source": p.application.source,
      "destination": p.application.destination
    }
  },
  "secret": if std.objectHas(p.application,"secret") then {
    "apiVersion": "v1",
    "kind": "Secret",
    "type": "Opaque",
    "metadata": {
      "name": p.target_name,
      "namespace": p.application.destination.namespace,
      "labels": {
        "tesoro.kapicorp.com": "enabled"
      }
    },
    "stringData": p.application.secret
  }
  else {}
}
