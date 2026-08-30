# Runbook — Capstone Phoenix

## Prerequisites
- AWS CLI configured with access keys
- Terraform installed (v1.15+)
- Ansible installed (v2.16+)
- kubectl installed
- SSH key: ~/.ssh/bincom-key.pem

## Step 1 — Provision Infrastructure with Terraform

```bash
cd infra/terraform
terraform init
terraform plan -var="my_ip=$(curl -s ifconfig.me)"
terraform apply -var="my_ip=$(curl -s ifconfig.me)" -auto-approve
```

Note the output IPs:
- control_plane_public_ip
- worker1_public_ip
- worker2_public_ip

## Step 2 — Update Ansible Inventory

Edit infra/ansible/inventory/hosts.ini and replace:
- CONTROL_PLANE_IP with control_plane_public_ip
- WORKER1_IP with worker1_public_ip
- WORKER2_IP with worker2_public_ip

## Step 3 — Configure Kubernetes with Ansible

```bash
cd infra/ansible
ansible-playbook -i inventory/hosts.ini site.yml
```

This will:
- Install k3s on the control plane
- Join both worker nodes to the cluster

## Step 4 — Verify Cluster

```bash
ssh -i ~/.ssh/bincom-key.pem ubuntu@<CONTROL_PLANE_IP>
kubectl get nodes
```

All 3 nodes should show Ready status.

## Step 5 — Install ArgoCD

```bash
cd gitops/argocd
bash install-argocd.sh
```

## Step 6 — Deploy TaskApp via ArgoCD

ArgoCD automatically syncs from the manifests folder in GitHub.
Access ArgoCD UI:

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Open https://localhost:8080
Username: admin
Password: (printed during install-argocd.sh)

## Step 7 — Verify Deployment

```bash
kubectl get pods -n taskapp
kubectl get svc -n taskapp
kubectl get ingress -n taskapp
```

All pods should show Running status with 2/2 replicas.

## Step 8 — Access the Application

Open browser and go to:
http://<CONTROL_PLANE_IP>.nip.io

## Failover Demo

To demonstrate self-healing:

```bash
# Delete a pod and watch Kubernetes recreate it
kubectl delete pod -l app=frontend -n taskapp
kubectl get pods -n taskapp -w
```

## Teardown

```bash
cd infra/terraform
terraform destroy -var="my_ip=$(curl -s ifconfig.me)" -auto-approve
```

This removes all AWS resources.

