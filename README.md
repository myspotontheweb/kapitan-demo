Table of Contents
=================

   * [Table of Contents](#table-of-contents)
   * [kapitan-demo](#kapitan-demo)
   * [Project Structure](#project-structure)
      * [compiled directory](#compiled-directory)
      * [inventory directory](#inventory-directory)
      * [templates directory](#templates-directory)
   * [Secrets](#secrets)
      * [Vault](#vault)
         * [Setup](#setup)
         * [Reveal](#reveal)

Created by [gh-md-toc](https://github.com/ekalinin/github-markdown-toc)

# kapitan-demo

Demo repo to try out [Kapitan](https://kapitan.dev/)

# Project Structure

```
├── compiled
│   ├── app1-deploy1
│   │   ├── application.yaml
│   │   └── secret.yaml
│   └── app2-deploy1
│       ├── application.yaml
│       └── secret.yaml
│
├── components
│   └── ..
│
├── inventory
│   ├── classes
│   │   ├── ..
|   |
│   └── targets
│       ├── app1-deploy1.yml
│       ├── app2-deploy1.yml
│       └── ..
│
└── refs
    └── ..
```

[Kapitan](kapitan.dev) is a templating engine which takes takes in the inventory directory

* [inventory/targets](inventory/targets)

and generates outputs in the following directory

* [compiled](compiled)

These files can then be synced with the target cluster using a tool like ArgoCD

## Application modelling

The inventory directory contains a set of files for modelling each target deployment

```
│   ├── classes
│   │   ├── application
│   │   │   ├── app1.yml
│   │   │   └── app2.yml
│   │   ├── project
│   │   │   ├── proj1.yml
│   │   │   └── proj2.yml
│   │   └── region
│   │       ├── eu.yml
│   │       ├── staging.yml
│   │       └── us.yml
```

For example, "app1" is deployed to the namespace operated by the "proj1" team and deployed using the staging branch and staging secrets.
These detail deploy details are abstracted using classes.

```
classes:
  - common
  - application.app1
  - project.proj1
  - region.staging

parameters:
  target_name: app1-deploy1
```


# Secrets 

## Vault 

### Setup

The vault details are configured here:

* [inventory/classes/common.yml](inventory/classes/common.yml)

Create the kapitan references to secrets in vault

```
echo "shared-creds/staging/global/vars:GLOBAL_DB_HOST" | kapitan refs --write "vaultkv:global/staging/database/hostname" -t app1-deploy1 -f -
echo "shared-creds/staging/global/vars:GLOBAL_DB_USER" | kapitan refs --write "vaultkv:global/staging/database/username" -t app1-deploy1 -f -
echo "shared-creds/staging/global/vars:GLOBAL_DB_PASS" | kapitan refs --write "vaultkv:global/staging/database/password" -t app1-deploy1 -f -

echo "shared-creds/us/global/vars:GLOBAL_DB_HOST" | kapitan refs --write "vaultkv:global/us/database/hostname" -t app1-deploy2 -f -
echo "shared-creds/us/global/vars:GLOBAL_DB_USER" | kapitan refs --write "vaultkv:global/us/database/username" -t app1-deploy2 -f -
echo "shared-creds/us/global/vars:GLOBAL_DB_PASS" | kapitan refs --write "vaultkv:global/us/database/password" -t app1-deploy2 -f -
```

and you can see the secret referenced in the application classes

* [inventory/classes/application/app1.yml](inventory/classes/application/app1.yml)
* [inventory/classes/application/app2.yml](inventory/classes/application/app2.yml)

### Reveal

The generated K8s secret contains embedded references to secrets located in vault

* [compiled/app1-deploy1/secret.yaml](compiled/app1-deploy1/secret.yaml)
* [compiled/app1-deploy2/secret.yaml](compiled/app1-deploy2/secret.yaml)
* [compiled/app2-deploy1/secret.yaml](compiled/app2-deploy1/secret.yaml)

To decode locally you first need to login to vault (details may vary)

```
vault login -no-print -method=github token=XXXXXXXXXXXXXXXX
```

And then run the reveal command

```
kapitan refs --reveal -f compiled/app1-deploy1/secret.yaml
kapitan refs --reveal -f compiled/app1-deploy2/secret.yaml
kapitan refs --reveal -f compiled/app2-deploy1/secret.yaml
```

Note:

* This will only work if you are authorized to access the configured vault server

