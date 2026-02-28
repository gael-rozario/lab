#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

WORKERS=("192.168.0.117" "192.168.0.190" "192.168.0.106")
CONFIG_DIR="${SCRIPT_DIR}/config"

apply() {
  for ip in "${WORKERS[@]}"; do
    echo "==> Applying worker config to ${ip}"
    talosctl apply-config --insecure \
      --nodes "${ip}" \
      --file "${CONFIG_DIR}/worker.yaml"
  done
}

usage() {
  echo "Usage: $0 <command>"
  echo ""
  echo "Commands:"
  echo "  apply   Apply config to all worker nodes"
}

case "${1:-}" in
  apply) apply ;;
  *) usage; exit 1 ;;
esac
