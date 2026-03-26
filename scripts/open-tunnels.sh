#!/bin/bash
set -e

JUMPHOST_IP="${JUMPHOST_IP:-$1}"

if [ -z "$JUMPHOST_IP" ]; then
  echo "Usage: ./scripts/open-tunnels.sh <jumphost-ip>"
  echo "   or: JUMPHOST_IP=1.2.3.4 ./scripts/open-tunnels.sh"
  exit 1
fi

echo "Opening SSH tunnels to GCP services via jumphost $JUMPHOST_IP ..."
echo ""
echo "Once connected, access services at:"
echo "  HTTPS         -> https://localhost:8443"
echo "  HTTP          -> http://localhost:8080"
echo "  Session proxy -> http://localhost:3002"
echo "  Docker        -> http://localhost:5000"
echo "  Ingress dash  -> http://localhost:8800"
echo "  Nomad UI      -> http://localhost:4646"
echo ""
echo "Press Ctrl+C to close all tunnels."
echo ""

ssh -i ~/.ssh/id_rsa \
  -L 8443:localhost:443 \
  -L 8080:localhost:80 \
  -L 3002:localhost:3002 \
  -L 5000:localhost:5000 \
  -L 8800:localhost:8800 \
  -L 4646:localhost:4646 \
  -N "user@${JUMPHOST_IP}" # replace 'user' with your GCP username
