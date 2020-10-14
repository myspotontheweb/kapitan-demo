local kap = import "lib/kapitan.libjsonnet";
local inventory = kap.inventory();

local name        = inventory.parameters.target_name;
local namespace   = inventory.parameters.argocd.namespace;
local project     = inventory.parameters.application.project;
local source      = inventory.parameters.application.source;
local destination = inventory.parameters.application.destination;

{
  "application": {
    "apiVersion": "argoproj.io/v1alpha1",
    "kind": "Application",
    "metadata": {
      "finalizers": [
        "resources-finalizer.argocd.argoproj.io"
      ],
      "name": name,
      "namespace": namespace
    },
    "spec": {
      "project": project,
      "source": source,
      "destination": destination
    }
  }
}
