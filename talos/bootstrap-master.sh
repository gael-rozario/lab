#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

CLUSTER_NAME="lab"
CONTROL_PLANE="192.168.0.172"
CONFIG_DIR="${SCRIPT_DIR}/config"
TALOS_VERSION="v1.12.4"
SCHEMATIC_ID="613e1592b2da41ae5e265e8789429f22e121aab91cb4deb6bc3c0b6262961245"
INSTALL_IMAGE="factory.talos.dev/installer/${SCHEMATIC_ID}:${TALOS_VERSION}"

gen_config() {
  echo "==> Generating Talos configs in ${CONFIG_DIR}/"
  mkdir -p "${CONFIG_DIR}"
  talosctl gen config "${CLUSTER_NAME}" "https://${CONTROL_PLANE}:6443" \
    --output-dir "${CONFIG_DIR}" \
    --install-image "${INSTALL_IMAGE}" \
    --config-patch-worker @"${SCRIPT_DIR}/worker-patch.yaml" \
    --force
  talosctl config endpoint "${CONTROL_PLANE}" --talosconfig "${CONFIG_DIR}/talosconfig"
  talosctl config node "${CONTROL_PLANE}" --talosconfig "${CONFIG_DIR}/talosconfig"
}

apply() {
  echo "==> Applying control plane config to ${CONTROL_PLANE}"
  talosctl apply-config --insecure \
    --nodes "${CONTROL_PLANE}" \
    --file "${CONFIG_DIR}/controlplane.yaml"
}

wait_for_api() {
  echo "==> Waiting for Talos API on ${CONTROL_PLANE}:50000"
  until talosctl version --talosconfig "${CONFIG_DIR}/talosconfig" --nodes "${CONTROL_PLANE}" &>/dev/null; do
    echo "  not ready, retrying in 5s..."
    sleep 5
  done
  echo "  Talos API is up"
}

upgrade() {
  echo "==> Upgrading control plane to ${INSTALL_IMAGE}"
  talosctl upgrade \
    --talosconfig "${CONFIG_DIR}/talosconfig" \
    --nodes "${CONTROL_PLANE}" \
    --image "${INSTALL_IMAGE}" \
    --wait
  echo "==> Control plane upgraded"
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
  echo "  gen-config    Generate Talos machine configs (run first)"
  echo "  apply         Apply config to the control plane node"
  echo "  wait-for-api  Wait for Talos API to become available"
  echo "  upgrade       Upgrade control plane to the image with extensions"
  echo "  bootstrap     Bootstrap etcd (run once after apply)"
  echo "  kubeconfig    Fetch kubeconfig"
  echo "  all           Run full sequence: gen-config → apply → wait-for-api → upgrade → bootstrap → kubeconfig"
}

case "${1:-}" in
  gen-config)    gen_config ;;
  apply)         apply ;;
  wait-for-api)  wait_for_api ;;
  upgrade)       upgrade ;;
  bootstrap)     bootstrap ;;
  kubeconfig)    kubeconfig ;;
  all)
    gen_config
    apply
    wait_for_api
    upgrade
    bootstrap
    kubeconfig
    echo "==> Done. Run: export KUBECONFIG=${CONFIG_DIR}/kubeconfig"
    ;;
  *) usage; exit 1 ;;
esac
