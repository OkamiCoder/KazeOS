#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
ISO_DIR="${REPO_ROOT}/iso"

if [[ -f "${ISO_DIR}/profiledef.sh" ]]; then
    echo "[INFO] Профиль в '${ISO_DIR}' уже существует. Пропускаем копирование (идемпотентность)."
    echo "[INFO] Если хотите пересоздать профиль с нуля, удалите папку 'iso/' вручную."
    exit 0
fi

echo "[INFO] Создаём директорию профиля: ${ISO_DIR}"
mkdir -p "${ISO_DIR}"

HOST_UID="$(id -u)"
HOST_GID="$(id -g)"

echo "[INFO] Запускаем контейнер archlinux:latest для извлечения свежего профиля releng..."
sudo podman run --rm \
    --network=host \
    --dns=77.88.8.8 \
    --dns=8.8.8.8 \
    -v "${ISO_DIR}:/iso:Z" \
    archlinux:latest \
    bash -c "
        set -euo pipefail
        echo 'Server = https://mirror.yandex.ru/archlinux/\$repo/os/\$arch' > /etc/pacman.d/mirrorlist
        echo 'Server = https://mirror.truenetwork.ru/archlinux/\$repo/os/\$arch' >> /etc/pacman.d/mirrorlist
        pacman -Sy --noconfirm archiso
        cp -r /usr/share/archiso/configs/releng/* /iso/
        chown -R ${HOST_UID}:${HOST_GID} /iso
    "

echo "[OK] Профиль releng успешно скопирован в ${ISO_DIR}"
