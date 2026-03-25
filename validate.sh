#!/bin/bash
set -e

# Validation script for E2B Infrastructure (GCP Native)

# Check for gcloud command
if ! command -v gcloud &> /dev/null; then
  echo "Error: gcloud command not found. Install Google Cloud CLI first."
  exit 1
fi

# 1. Check reserved static IP for Load Balancer
echo "1. Checking Global Load Balancer IP..."
LB_IP=$(gcloud compute addresses describe e2b-lb-static-ip --global --format="value(address)" 2>/dev/null || echo "NOT_FOUND")
echo ">> LB IP: $LB_IP"
if [ "$LB_IP" != "NOT_FOUND" ]; then
  echo ">> Action: Whitelist outbound traffic to $LB_IP on ports 443 and 80 in your corporate firewall."
fi

# 2. Check reserved static IP for NAT
echo "2. Checking reserved static IP for NAT..."
NAT_IP=$(gcloud compute addresses list --filter="name~e2b-nat-ip" --format="value(address)" 2>/dev/null || echo "NOT_FOUND")
echo ">> NAT IP: $NAT_IP"
if [ "$NAT_IP" != "NOT_FOUND" ]; then
  echo ">> Action: This is the outbound IP for all sandboxes. Whitelist it in external services if needed."
fi

# 3. Check NAT Status
echo "3. Checking NAT Status..."
gcloud compute routers nats list --router=e2b-nat-router --format="table(name, natIpAllocateOption, sourceSubnetworkIpRangesToNat)" 2>/dev/null || echo "NAT Router not found."

# 4. Check API Instance IPs
echo "4. Checking API Instance External IPs..."
INSTANCES=$(gcloud compute instances list --filter="tags:orch" --format="table(name, networkInterfaces[0].accessConfigs[0].natIP)" 2>/dev/null)
echo "$INSTANCES"
if echo "$INSTANCES" | grep -v "NAME" | grep -q "[0-9]"; then
  echo ">> Action: Whitelist outbound traffic to these IPs on ports 22, 3002, 5000, and 8800 if you need direct access (Dev only)."
else
  echo ">> No public IPs found (Correct for Prod/Staging). Use IAP for SSH: 'gcloud compute ssh [INSTANCE] --tunnel-through-iap'"
fi

# 5. Check Cloud DNS Zones
echo "5. Checking Cloud DNS Zones..."
gcloud dns managed-zones list --format="table(name, dnsName, visibility)" | grep "e2b-" || echo "No E2B DNS zones found."

# 6. Check SSL Certificates status
echo "6. Checking GCP SSL Certificates status..."
gcloud certificate-manager certificates list --format="table(name, managed.domains, managed.status)" 2>/dev/null || echo "Certificate Manager not setup or no certs found."

echo "Validation complete."
