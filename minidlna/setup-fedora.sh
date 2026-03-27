#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
PACKAGE_NAME="minidlna"

MEDIA_HOME="/home/tiago"
MEDIA_DIR="/home/tiago/Videos"
BACKUP_SUFFIX=".pre-stow.$(date +%Y%m%d%H%M%S)"

backup_existing_target() {
    local target_path="$1"
    local backup_path

    if [[ ! -e "${target_path}" && ! -L "${target_path}" ]]; then
        return 0
    fi

    backup_path="${target_path}${BACKUP_SUFFIX}"
    echo "Backing up existing ${target_path} to ${backup_path}"
    sudo mv -- "${target_path}" "${backup_path}"
}

install_managed_file() {
    local source_path="$1"
    local target_path="$2"
    local owner="$3"
    local group="$4"
    local mode="$5"

    if [[ -e "${target_path}" && ! -L "${target_path}" ]] && cmp -s -- "${source_path}" "${target_path}"; then
        echo "Keeping existing ${target_path}; contents already match."
    else
        backup_existing_target "${target_path}"
        sudo install -D -m "${mode}" -o "${owner}" -g "${group}" -- "${source_path}" "${target_path}"
    fi

    if command -v restorecon >/dev/null 2>&1; then
        sudo restorecon -F -- "${target_path}"
    fi
}

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
    echo "Edit MEDIA_DIR in ${SCRIPT_DIR}/setup-fedora.sh if you changed paths."
    exit 1
fi

sudo dnf install -y acl minidlna

install_managed_file "${DOTFILES_DIR}/${PACKAGE_NAME}/etc/minidlna.conf" "/etc/minidlna.conf" root root 0644
install_managed_file "${DOTFILES_DIR}/${PACKAGE_NAME}/etc/systemd/system/minidlna.service" "/etc/systemd/system/minidlna.service" root root 0644
install_managed_file "${DOTFILES_DIR}/${PACKAGE_NAME}/usr/lib/sysusers.d/minidlna.conf" "/usr/lib/sysusers.d/minidlna.conf" root root 0644

sudo systemd-sysusers

# Allow the service account to traverse /home/tiago and read the media library.
sudo setfacl -m u:minidlna:--x "${MEDIA_HOME}"
sudo setfacl -R -m u:minidlna:rX "${MEDIA_DIR}"
sudo setfacl -dR -m u:minidlna:rX "${MEDIA_DIR}"

sudo systemctl daemon-reload
sudo systemctl enable --now minidlna.service

echo
echo "MiniDLNA restored on Fedora."
echo "Check status with: sudo systemctl status minidlna.service"
echo "Follow logs with: journalctl -u minidlna.service -f"