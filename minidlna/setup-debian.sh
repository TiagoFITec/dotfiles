#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
PACKAGE_NAME="minidlna"

MEDIA_HOME="/home/tiago"
MEDIA_DIR="/home/tiago/Videos"

if [[ "${EUID}" -eq 0 ]]; then
    echo "Run this script as your regular user, not as root."
    exit 1
fi

if [[ ! -d "${DOTFILES_DIR}/${PACKAGE_NAME}" ]]; then
    echo "Could not find the ${PACKAGE_NAME} package inside ${DOTFILES_DIR}."
    exit 1
fi

if [[ ! -d "${MEDIA_DIR}" ]]; then
    echo "Expected media directory ${MEDIA_DIR} was not found."
    echo "Edit MEDIA_DIR in ${SCRIPT_DIR}/setup-debian.sh if you changed paths."
    exit 1
fi

sudo apt update
sudo apt install -y acl minidlna stow systemd

sudo stow --dir="${DOTFILES_DIR}" --target=/ "${PACKAGE_NAME}"
sudo systemd-sysusers

# Allow the service account to traverse /home/tiago and read the media library.
sudo setfacl -m u:minidlna:--x "${MEDIA_HOME}"
sudo setfacl -R -m u:minidlna:rX "${MEDIA_DIR}"
sudo setfacl -dR -m u:minidlna:rX "${MEDIA_DIR}"

sudo systemctl daemon-reload
sudo systemctl enable --now minidlna.service

echo
echo "MiniDLNA restored."
echo "Check status with: sudo systemctl status minidlna.service"
echo "Follow logs with: journalctl -u minidlna.service -f"