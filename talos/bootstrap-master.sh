#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

CLUSTER_NAME="lab"
CONTROL_PLANE="192.168.0.172"
CONFIG_DIR="${SCRIPT_DIR}/config"

gen_config() {
  echo "==> Generating Talos configs in ${CONFIG_DIR}/"
  mkdir -p "${CONFIG_DIR}"
  talosctl gen config "${CLUSTER_NAME}" "https://${CONTROL_PLANE}:6443" \
    --output-dir "${CONFIG_DIR}" \
    --config-patch @"${SCRIPT_DIR}/extensions-patch.yaml" \
    --config-patch-worker @"${SCRIPT_DIR}/worker-patch.yaml" \
    --force
}

apply() {
  echo "==> Applying control plane config to ${CONTROL_PLANE}"
  talosctl apply-config --insecure \
    --nodes "${CONTROL_PLANE}" \
    --file "${CONFIG_DIR}/controlplane.yaml"
}

bootstrap() {
  echo "==> Bootstrapping etcd on ${CONTROL_PLANE}"
  talosctl bootstrap \
    --talosconfig "${CONFIG_DIR}/talosconfig" \
    --nodes "${CONTROL_PLANE}"
}

kubeconfig() {
  echo "==> Fetching kubeconfig"
  talosctl kubeconfig \
    --talosconfig "${CONFIG_DIR}/talosconfig" \
    --nodes "${CONTROL_PLANE}" \
    --force
}

usage() {
  echo "Usage: $0 <command>"
  echo ""
  echo "Commands:"
  echo "  gen-config   Generate Talos machine configs (run first)"
  echo "  apply        Apply config to the control plane node"
  echo "  bootstrap    Bootstrap etcd (run once after apply)"
  echo "  kubeconfig   Fetch kubeconfig"
  echo "  all          Run full sequence: gen-config → apply → bootstrap → kubeconfig"
}

case "${1:-}" in
  gen-config) gen_config ;;
  apply)      apply ;;
  bootstrap)  bootstrap ;;
  kubeconfig) kubeconfig ;;
  all)
    gen_config
    apply
    bootstrap
    kubeconfig
    echo "==> Done. Run: export KUBECONFIG=${CONFIG_DIR}/kubeconfig"
    ;;
  *) usage; exit 1 ;;
esac
