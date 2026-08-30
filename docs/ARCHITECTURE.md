# Architecture Documentation — Capstone Phoenix

## 1. Diagram


Internet ──DNS──▶ <CONTROL_PLANE_IP>.nip.io
│
▼
Traefik Ingress Controller (node: control-plane) ──TLS──┐
│ │
▼ ▼
frontend Service ──▶ frontend Pods (worker1, worker2) backend Service ──▶ backend Pods (worker1, worker2)
│ /api proxy │
└────────────────────────────────────────▶│
▼
postgres Service ──▶ postgres-0 (PVC on control-plane)



## 2. Node & Network
- **Nodes:** 3 x t3.micro, Ubuntu 22.04, us-east-1a
  - control-plane: runs Traefik ingress, ArgoCD, k3s server
  - worker1: runs frontend and backend replicas
  - worker2: runs frontend and backend replicas
- **CIDR:** 10.0.0.0/16 VPC, 10.0.1.0/24 public subnet
- **Firewall:**
  - Port 80/443 open to internet
  - Port 22 open to my IP only
  - Port 6443 internal only (k3s API)
  - Port 5432 internal only (PostgreSQL)
  - Port 8472 UDP internal only (Flannel VXLAN)

## 3. Request Flow
DNS resolves the nip.io domain to the control plane public IP. Traffic hits Traefik ingress on port 80/443 where cert-manager handles TLS termination. Traefik routes requests to the frontend Service on port 80, which serves the React app. API calls to /api are proxied to the backend Service on port 5000, which connects to the PostgreSQL Service on port 5432, routing to the postgres-0 pod with a persistent volume claim.

## 4. Single-Server Assumptions Fixed

| Single-server assumption | Why it breaks at scale | How you fixed it |
|---|---|---|
| migrate-on-boot in entrypoint | 2+ replicas race on alembic upgrade head | Removed migration from entrypoint, run as a one-time Kubernetes Job |
| Named volume on the host | Pods reschedule across nodes | Used PersistentVolumeClaim with local-path storage class |
| ports: published on the host | Many pods, many nodes, one front door needed | Used Kubernetes Service and Traefik Ingress |
| Single process crash = downtime | No recovery without manual restart | Kubernetes liveness and readiness probes auto-restart unhealthy pods |
| Manual deployments | Error-prone, no rollback | ArgoCD GitOps — Git is source of truth, auto-sync on every push |
| Hardcoded secrets in code | Security risk | Kubernetes Secrets injected as environment variables |

## 5. Choices & Trade-offs
- **Raw YAML vs Helm vs Kustomize:** Used raw YAML for simplicity and transparency at this scale.
- **Traefik vs ingress-nginx:** Used k3s built-in Traefik to avoid installing additional components.
- **CNI:** k3s uses Flannel by default with VXLAN mode, sufficient for a 3-node cluster.
- **Secrets approach:** Used Kubernetes native Secrets. In production would use External Secrets Operator with AWS Secrets Manager.
