![E2B Infra Preview Light](/readme-assets/infra-light.png#gh-light-mode-only)
![E2B Infra Preview Dark](/readme-assets/infra-dark.png#gh-dark-mode-only)

# E2B Infrastructure

[E2B](https://e2b.dev) is an open-source infrastructure for AI code interpreting. In our main repository [e2b-dev/e2b](https://github.com/e2b-dev/E2B) we are giving you SDKs and CLI to customize and manage environments and run your AI agents in the cloud.

## 🛡️ Pre-deployment Firewall Checklist (GCP)
Before starting the deployment, ensure your local/corporate network allows communication to your GCP project on the following ports:
- **443 (HTTPS)**: Essential for API and Sandbox interactions.
- **80 (HTTP)**: Nomad UI and redirects.
- **22 (SSH)**: Direct instance access (restricted to your IP).
- **3002, 5000, 8800**: Session proxy, Docker registry, and Ingress dashboard access.

See [firewall_request_doc.md](./firewall_request_doc.md) for full details.

This repository contains the infrastructure that powers the E2B platform.

## Self-hosting

Read the [self-hosting guide](./self-host.md) to learn how to set up the infrastructure on your own. The infrastructure is deployed using Terraform.

Supported cloud providers:
- 🟢 GCP
- 🟢 AWS (Beta)
- [ ] Azure
- [ ] General linux machine
