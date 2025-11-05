
# 🌐 Multi-Tenant Website Hosting on Kubernetes  
### Automated CI/CD + Kafka Events + TLS + Autoscaling

This project is a complete multi-tenant web hosting platform built on top of Kubernetes, designed to deploy multiple isolated websites dynamically.
It demonstrates how modern SaaS hosting platforms work by giving each tenant their own secure and scalable environment.

---

## ✅ Key Features

| Feature | What it does |
|--------|--------------|
| 🏗️ Multi-Tenant Namespaces | Each website gets its own namespace in Kubernetes |
| 🔐 Security | Network isolation and resource quotas per tenant |
| 🌍 Automatic Domain Mapping | `tenant.example.com` generated for every deployment |
| 🔒 TLS & HTTPS | Cert-Manager automatically creates SSL certificates |
| 🚀 CI/CD Automation | GitHub Actions builds & deploys dynamically |
| 📈 Auto-Scaling | HPA scales pods based on CPU and memory |
| 🔁 Rollback Support | Deployment automatically reverts on failures |
| 📩 Kafka Integration | Sends deployment notifications as events |
| 📊 Full Observability | Prometheus + Grafana dashboards |

---

## Architecture Flow

```
Developer Commit / Pull Request / Manual 
        ↓
GitHub Actions CI/CD
        ↓
Docker Build → Azure Container Registry
        ↓
Kubernetes Deployment per Tenant Namespace
        ↓
Ingress + TLS created automatically
        ↓
Kafka publishes deployment event
        ↓
Prometheus & Grafana visualize metrics and scaling
```

---

## Repository Layout

```
app/                       # Flask application
k8s/templates/             # Deployment/Ingress/HPA/Quotas/PDB
k8s/kafka/                 # Kafka setup
k8s/monitoring/            # Prometheus + Grafana setup
scripts/                   # Helper scripts
.github/workflows/         # CI/CD pipelines
```

---

## How CI/CD Works

1. Code is pushed → workflow runs automatically  
2. Docker image is built → pushed to ACR  
3. Namespace is created dynamically if new tenant  
4. Deployment + Service applied  
5. TLS ingress configured using Cert-Manager  
6. Kafka receives a `WebsiteCreated` event  
7. Grafana dashboards show metrics + scaling  

Rollback automatically triggers if deployment fails ✅

---

## Setup Requirements

- Kubernetes Cluster 
- Ingress Controller
- Cert-Manager installed
- Azure Container Registry (or modify the registry config)
- Kafka + Prometheus + Grafana installed

### Required GitHub Secrets

| Secret | Description |
|--------|-------------|
| KUBE_CONFIG | Base64 kubeconfig for kubectl |
| ACR_NAME | Azure Container Registry name |
| ACR_USERNAME | Registry username |
| ACR_PASSWORD | Registry password |
| BASE_DOMAIN | Your domain e.g. example.com |

---

## Validation Commands

```
kubectl get ns
kubectl get pods -A
kubectl get ingress -A
```

To view Kafka events:
```
kubectl logs -l app=kafka-consumer -n kafka
```

Grafana Dashboard URL:
```
kubectl port-forward svc/grafana 3000:3000 -n monitoring
```

➡ Open http://localhost:3000  
Login → admin / admin

---




