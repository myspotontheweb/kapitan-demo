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
│   ├── app1-deploy2
│   │   ├── application.yaml
│   │   └── secret.yaml
│   └── app2-deploy1
│       ├── application.yaml
│       └── secret.yaml
├── components
│   └── application
│       └── main.jsonnet
├── inventory
│   ├── classes
│   │   ├── application.yml
│   │   ├── common.yml
│   │   └── myorg
│   │       └── apps
│   │           ├── app1.yml
│   │           └── app2.yml
│   └── targets
│       ├── app1-deploy1.yml
│       ├── app1-deploy2.yml
│       └── app2-deploy1.yml
├── Makefile
├── README.md
└── refs
    └── global
        ├── staging
        │   └── database
        │       ├── hostname
        │       ├── password
        │       └── username
        └── us
            └── database
                ├── hostname
                ├── password
                └── username

```

## compiled directory

Contains the generated the YAML output that can be synced against the K8s cluster (using ```kubectl apply``` or ArgoCD)

## inventory directory

Kapitan will render the files contained in **targets** subdirectory. 

* [inventory/targets/app1-deploy1.yml](inventory/targets/app1-deploy1.yml)
* [inventory/targets/app1-deploy2.yml](inventory/targets/app1-deploy2.yml)
* [inventory/targets/app2-deploy1.yml](inventory/targets/app2-deploy1.yml)

In these examples there are 3 different deployments of app1. 

The following files are worthy of mention:

* [inventory/classes/common.yml](inventory/classes/common.yml) Contains shared configuration, like for example the vault settings
* [inventory/classes/application.yml](inventory/classes/application.yml) Contains the configuration that controls how the output YAML is generated
* [inventory/classes/myorg/apps/app1.yml](inventory/classes/myorg/apps/app1.yml) Base class for 'app1' deployments
* [inventory/classes/myorg/apps/app2.yml](inventory/classes/myorg/apps/app1.yml) Base class for 'app2' deployments

## components directory

Holds the jsonnet logic that generates the artifacts associated with an application

* [components/application/main.jsonnet](components/application/main.jsonnet)

## refs directory

This is where references to secrets are stored.

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

* [inventory/classes/myorg/apps/app1.yml](inventory/classes/myorg/apps/app1.yml)
* [inventory/classes/myorg/apps/app2.yml](inventory/classes/myorg/apps/app2.yml)

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

