#!/bin/bash
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive

fail() {
  echo "Error: $*" >&2
  exit 1
}

echo "=== [1/4] 修改 apt 源 ==="
# 此刻 rootfs 里还没有 CA 证书，HTTPS 源不可用，先用默认 HTTP 源装 ca-certificates。
apt-get update
apt-get install -y ca-certificates openssl

cat > /etc/apt/sources.list <<'EOF'
deb https://deb.debian.org/debian trixie main contrib non-free non-free-firmware
deb https://deb.debian.org/debian trixie-updates main contrib non-free non-free-firmware
deb https://deb.debian.org/debian trixie-backports main contrib non-free non-free-firmware
deb https://security.debian.org/debian-security trixie-security main contrib non-free non-free-firmware
EOF
apt-get update

echo "=== [2/4] 全量升级 ==="
apt-get full-upgrade -y --no-install-recommends

echo "=== [3/4] 安装基础库 ==="
apt-get install -y libssl3t64 zlib1g libstdc++6 libgcc-s1 liblzma5 libbz2-1.0 tzdata

echo "=== [4/4] 清理与自检 ==="
apt-get autoremove --purge -y
apt-get clean