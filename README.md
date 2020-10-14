# kapitan-demo
Demo repo to try out Kapitan

## Project Structure

```
── compiled                       # Compiled output YAML
│   ├── app1-deploy1
│   │   └── application.yaml
│   ├── app1-deploy2
│   │   └── application.yaml
│   └── app1-deploy3
│       └── application.yaml
├── inventory
│   ├── classes
│   │   ├── argocd
│   │   │   └── application.yml   # Class that defines how an application is generated 
│   │   ├── common.yml
│   │   └── myorg
│   │       └── apps
│   │           ├── app1.yml
│   │           ├── staging
│   │           │   └── app1.yml  # Describes app deployed to staging
│   │           └── us
│   │               └── app1.yml  # Describes app deployed to us
│   └── targets
│       ├── app1-deploy1.yml      # Apps to generated
│       ├── app1-deploy2.yml
│       └── app1-deploy3.yml
├── Makefile
├── README.md
└── templates
    └── argocd
        └── application.jsonnet   # Logic for generating YAML
```
