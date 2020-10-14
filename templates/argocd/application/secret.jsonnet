local kap = import "lib/kapitan.libjsonnet";
local inventory = kap.inventory();

if std.objectHas(inventory.parameters.application,"secret") then

  local name      = inventory.parameters.target_name;
  local namespace = inventory.parameters.application.destination.namespace;
  local data      = inventory.parameters.application.secret;

  {
    "secret": {
      "apiVersion": "v1",
      "kind": "Secret",
      "type": "Opaque",
      "metadata": {
        "name": name,
        "namespace": namespace,
        "labels": {
          "tesoro.kapicorp.com": "enabled"
        }
      },
      "stringData": data
    }
  }
else {}
