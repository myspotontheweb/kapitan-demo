
Table of Contents
=================

   * [kapitan-demo](#kapitan-demo)
   * [Project Structure](#project-structure)
   * [Secrets](#secrets)
      * [Vault](#vault)
         * [Setup](#setup)
         * [Reveal](#reveal)

Created by [gh-md-toc](https://github.com/ekalinin/github-markdown-toc)

# kapitan-demo

Demo repo to try out [Kapitan](https://kapitan.dev/)

# Project Structure

```
── compiled                       
│   ├── app1-deploy1
│   │   ├── application.yaml      # Application YAML
│   │   └── secret.yaml           # Optional secret
│   ├── app1-deploy2
│   │   └── application.yaml
│   └── app1-deploy3
│       └── application.yaml
├── inventory
│   ├── classes
│   │   ├── argocd
│   │   │   └── application.yml   # Class that defines how YAML is generated 
│   │   ├── common.yml
│   │   └── myorg
│   │       └── apps
│   │           ├── app1.yml
│   │           ├── staging
│   │           │   └── app1.yml  # Describes app deployed to staging
│   │           └── us
│   │               └── app1.yml  # Describes app deployed to us
│   └── targets
│       ├── app1-deploy1.yml      # App to be generated
│       ├── app1-deploy2.yml
│       └── app1-deploy3.yml
├── Makefile
├── README.md
├── refs
│   └── apps
│       └── app1-deploy1
└── templates
    └── argocd
        ├── application
        │   └── secret.jsonnet
        └── application.jsonnet   # Logic for generating YAML
```

# Secrets 

## Vault 

### Setup

The vault details are configured here:

* [inventory/classes/common.yml](inventory/classes/common.yml)

Kapitan references to vault secrets are created as follows:

```
echo "shared-creds/us/ops/ping:USERNAME" | kapitan refs --write "vaultkv:us/database/username" -t app1-deploy2 -f -
echo "shared-creds/us/ops/ping:PASSWORD" | kapitan refs --write "vaultkv:us/database/password" -t app1-deploy2 -f -
```

### Reveal

To reveal the secrets (via vault API call):

```
export VAULT_TOKEN=<github-api-token-goes-here>

kapitan refs --reveal -f compiled/app1-deploy2/secret.yaml
```

