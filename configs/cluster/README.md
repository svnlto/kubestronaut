# Cluster Configurations

## Quick Start

**Single-node cluster (KCNA/KCSA/CKAD)**:

```bash
kind create cluster --config=kind-single-node.yaml
```

**Multi-node cluster (CKA/CKS)**:

```bash
kind create cluster --config=kind-multi-node.yaml
```

## Post-Setup

### Install Ingress Controller (optional)

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s
```

### Verify Cluster

```bash
kubectl get nodes
kubectl get pods -A
```

## Cleanup

```bash
kind delete cluster --name kubestronaut-single
# or
kind delete cluster --name kubestronaut-multi
```

## Advanced Configuration

### Storage Class

Both configs use the default kind storage class. For practice:

```bash
kubectl get storageclass
kubectl describe storageclass standard
```

### CNI

Default CNI (kindnet) is installed. For CKA practice with CNI installation:

1. Create cluster with `disableDefaultCNI: true` in config
2. Install Calico or other CNI manually

### Load Balancer

kind uses MetalLB for LoadBalancer services. Configure if needed:

```bash
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.12/config/manifests/metallb-native.yaml
```
