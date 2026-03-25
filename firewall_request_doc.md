# Firewall Request Document - E2B Infrastructure (GCP)

## 🎯 **STEP 1: Management Access (Your Network → GCP)**
Before running `terraform apply`, your network must allow outbound traffic to **Google Cloud API endpoints**.

- **Endpoints**: `*.googleapis.com`, `*.gcr.io`, `*.pkg.dev`
- **Ports**: 443 (HTTPS)
- **Protocol**: TCP
- **IP Ranges**: Google publishes its official ranges here: [Google IP Ranges JSON](https://www.gstatic.com/ipranges/goog.json)

---

## 🛡️ **STEP 2: Accessing the E2B Infrastructure (Local Computer → GCP)**
Once the deployment starts, Terraform will reserve **Static IPs**. You must whitelist these on your corporate firewall to interact with the system.

| Target | Description | Ports | Protocol | How to find the IP |
| :--- | :--- | :--- | :--- | :--- |
| **Global Load Balancer** | API, SDK, and Sandbox access | 443, 80 | TCP | `gcloud compute addresses describe e2b-lb-static-ip --global` |
| **API Nodes (Dev only)** | Direct access to API instances | 22, 3002, 5000, 8800 | TCP | `gcloud compute instances list --filter="tags:orch"` |
| **GCP IAP** | Secure SSH Proxy (Required for Prod) | 22 | TCP | `35.235.240.0/20` (Standard GCP Range) |

---

## 🏗️ **Internal GCP Infrastructure Rules**

### Inbound Rules (GCP VPC Ingress)
These rules are implemented in Terraform via `local_pc_ingress` and other rules.

| Port | Protocol | Source | Target | Purpose |
|------|----------|--------|--------|---------|
| 443 | TCP | Any | LB | HTTPS API & Session Proxy |
| 80 | TCP | Any | LB | HTTP Redirect / Nomad UI |
| 3002 | TCP | YOUR_LOCAL_IP/32 | API Nodes | Sandbox Session Proxy |
| 5000 | TCP | YOUR_LOCAL_IP/32 | API Nodes | Docker Reverse Proxy |
| 8800 | TCP | YOUR_LOCAL_IP/32 | API Nodes | Traefik Ingress |
| 22 | TCP | 35.235.240.0/20 | All Nodes | SSH via Identity-Aware Proxy (IAP) |
| 22 | TCP | YOUR_LOCAL_IP/32 | All Nodes | Direct SSH access (Dev only) |

### Outbound Rules (GCP VPC Egress)
**IMPORTANT**: All outbound traffic from the internal nodes (API, Orchestrator, ClickHouse) is routed through the **Cloud NAT** gateway with a **Reserved Static IP**.

| Port | Protocol | Destination | Purpose |
|------|----------|-------------|---------|
| 80, 443 | TCP | Any | General Internet (Package Managers, Git, GCS, APIs) |
| 53 | UDP/TCP | Any | DNS Resolution |
| 22 | TCP | Any | Git SSH access (Clone repositories) |

**Reserved Outbound IP**: Find it with `gcloud compute addresses describe e2b-nat-ip --region=YOUR_REGION`.

### Internal Cluster Communication (VPC Internal)
Nodes within the cluster (`orch` tag) require full communication on the following ports:
- Nomad: 4646-4648 (TCP)
- Consul: 8500, 8300-8302 (TCP), 8600 (UDP)
- ClickHouse: 9000, 8123 (TCP)
- Loki: 3100 (TCP)
- Orchestrator: 5007-5008 (TCP)
