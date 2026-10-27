#!/bin/bash
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive

fail() {
  echo "Error: $*" >&2
  exit 1
}

echo "=== [1/4] 修改 apt 源 ==="
apt-get update
apt-get ca-certificates

cat > /etc/apt/sources.list <<'EOF'
deb https://deb.debian.org/debian trixie main contrib non-free non-free-firmware
deb https://deb.debian.org/debian trixie-updates main contrib non-free non-free-firmware
deb https://deb.debian.org/debian trixie-backports main contrib non-free non-free-firmware
deb https://security.debian.org/debian-security trixie-security main contrib non-free non-free-firmware
EOF
apt-get update

echo "=== [2/4] 全量升级 ==="
apt-get full-upgrade -y --no-install-recommends

echo "=== [3/4] 清理与自检 ==="
apt-get autoremove --purge -y
apt-get clean