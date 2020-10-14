# kapitan-demo
Demo repo to try out [Kapitan](https://kapitan.dev/)

## Project Structure

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

### Secrets

The generated secret requires installation of the [tesoro](https://github.com/kapicorp/tesoro) admissions controller to decrypt/decode the data.

```
apiVersion: v1
kind: Secret
metadata:
  labels:
    tesoro.kapicorp.com: enabled
  name: app1-deploy1
  namespace: project1
stringData:
  ONE: ?{base64:eyJkYXRhIjogIlQwNUZPaUIxYm04S1ZFaFNSVVU2SUhSeVpYTUtWRmRQT2lCa2IzTUsiLCAiZW5jb2RpbmciOiAib3JpZ2luYWwiLCAidHlwZSI6ICJiYXNlNjQiLCAiZW1iZWRkZWRfc3VidmFyX3BhdGgiOiAiT05FIn0=:embedded}
  THREE: ?{base64:eyJkYXRhIjogIlQwNUZPaUIxYm04S1ZFaFNSVVU2SUhSeVpYTUtWRmRQT2lCa2IzTUsiLCAiZW5jb2RpbmciOiAib3JpZ2luYWwiLCAidHlwZSI6ICJiYXNlNjQiLCAiZW1iZWRkZWRfc3VidmFyX3BhdGgiOiAiVEhSRUUifQ==:embedded}
  TWO: ?{base64:eyJkYXRhIjogIlQwNUZPaUIxYm04S1ZFaFNSVVU2SUhSeVpYTUtWRmRQT2lCa2IzTUsiLCAiZW5jb2RpbmciOiAib3JpZ2luYWwiLCAidHlwZSI6ICJiYXNlNjQiLCAiZW1iZWRkZWRfc3VidmFyX3BhdGgiOiAiVFdPIn0=:embedded}
type: Opaque
```

