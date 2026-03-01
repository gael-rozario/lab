#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

WORKERS=("192.168.0.117" "192.168.0.190" "192.168.0.106")
CONFIG_DIR="${SCRIPT_DIR}/config"
TALOS_VERSION="v1.12.4"
SCHEMATIC_ID="613e1592b2da41ae5e265e8789429f22e121aab91cb4deb6bc3c0b6262961245"
INSTALL_IMAGE="factory.talos.dev/installer/${SCHEMATIC_ID}:${TALOS_VERSION}"

apply() {
  for ip in "${WORKERS[@]}"; do
    echo "==> Applying worker config to ${ip}"
    talosctl apply-config --insecure \
      --nodes "${ip}" \
      --file "${CONFIG_DIR}/worker.yaml"
  done
}

wait_for_api() {
  local ip="${1}"
  echo "==> Waiting for Talos API on ${ip}:50000"
  until talosctl version --talosconfig "${CONFIG_DIR}/talosconfig" --nodes "${ip}" &>/dev/null; do
    echo "  ${ip} not ready, retrying in 5s..."
    sleep 5
  done
  echo "  ${ip} Talos API is up"
}

upgrade() {
  for ip in "${WORKERS[@]}"; do
    wait_for_api "${ip}"
    echo "==> Upgrading ${ip} to ${INSTALL_IMAGE}"
    talosctl upgrade \
      --talosconfig "${CONFIG_DIR}/talosconfig" \
      --nodes "${ip}" \
      --image "${INSTALL_IMAGE}" \
      --wait
    echo "==> ${ip} upgraded"
  done
}

usage() {
  echo "Usage: $0 <command>"
  echo ""
  echo "Commands:"
  echo "  apply    Apply config to all worker nodes"
  echo "  upgrade  Upgrade all worker nodes to the image with extensions"
  echo "  all      Run full sequence: apply → upgrade"
}

case "${1:-}" in
  apply)   apply ;;
  upgrade) upgrade ;;
  all)
    apply
    upgrade
    ;;
  *) usage; exit 1 ;;
esac
