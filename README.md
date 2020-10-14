# kapitan-demo
Demo repo to try out Kapitan

## Structure

```
├── compiled                           # Compiled output YAML
│   ├── crmcore-staging
│   │   └── application.yaml
│   └── crmcore-us
│       └── application.yaml
├── inventory
│   ├── classes                        
│   │   ├── argocd
│   │   │   └── application.yml        # Class that defines how an application is generated 
│   │   ├── common.yml
│   │   └── teamwork
│   │       └── apps
│   │           ├── crmcore.yml
│   │           ├── staging
│   │           │   └── crmcore.yml    # Application deployed to staging
│   │           └── us
│   │               └── crmcore.yml    # Application deployed to us
│   └── targets
│       ├── crmcore-staging.yml        # Each generated application is represented as a target
│       └── crmcore-us.yml
├── Makefile
├── README.md
└── templates                          
    └── argocd
        └── application.jsonnet        # Logic for generating output
```
