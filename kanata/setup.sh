#!/usr/bin/env bash
set -euo pipefail

user=${SUDO_USER:-$USER}
repo_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

command -v kanata_cmd_allowed >/dev/null || {
  printf 'kanata_cmd_allowed missing; install kanata-bin first.\n' >&2
  exit 1
}
kanata_cmd_allowed --check --cfg "$repo_dir/kanata.kbd"

if ! getent group uinput >/dev/null; then
  sudo groupadd --system uinput
fi
sudo usermod --append --groups input,uinput "$user"

sudo install -Dm644 /dev/stdin /etc/modules-load.d/kanata.conf <<'EOF'
uinput
EOF
sudo install -Dm644 /dev/stdin /etc/udev/rules.d/99-kanata.rules <<'EOF'
KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
EOF

sudo modprobe uinput
sudo udevadm control --reload-rules
sudo udevadm trigger --subsystem-match=misc --action=change

systemctl --user daemon-reload
systemctl --user enable kanata.service

if id -nG | grep -qw input && id -nG | grep -qw uinput; then
  systemctl --user restart kanata.service
else
  printf 'Kanata enabled. Log out and back in once, then it starts automatically.\n'
  omarchy-state set reboot-required
fi
