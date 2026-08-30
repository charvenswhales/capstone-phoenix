#!/bin/bash

echo "Installing ArgoCD..."

# Create ArgoCD namespace
kubectl create namespace argocd

# Install ArgoCD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for ArgoCD to be ready
echo "Waiting for ArgoCD pods to be ready..."
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=argocd-server -n argocd --timeout=300s

# Get ArgoCD initial admin password
echo "ArgoCD initial admin password:"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
echo ""

# Apply taskapp application
echo "Deploying TaskApp via ArgoCD..."
kubectl apply -f taskapp-application.yml

echo "ArgoCD setup complete!"
echo "Access ArgoCD UI by port-forwarding:"
echo "kubectl port-forward svc/argocd-server -n argocd 8080:443"

