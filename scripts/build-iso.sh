#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"

ISO_DIR="${REPO_ROOT}/iso"
WORK_DIR="${REPO_ROOT}/workdir"
OUT_DIR="${REPO_ROOT}/out"

if [[ ! -f "${ISO_DIR}/profiledef.sh" ]]; then
    echo "[ERROR] Профиль не найден в ${ISO_DIR}. Сначала запустите ./scripts/bootstrap-profile.sh"
    exit 1
fi

mkdir -p "${WORK_DIR}" "${OUT_DIR}"

HOST_UID="$(id -u)"
HOST_GID="$(id -g)"

echo "[INFO] Запускаем сборку KazeOS внутри изолированного контейнера..."
sudo podman run --rm --privileged \
    --network=host \
    --dns=77.88.8.8 \
    --dns=8.8.8.8 \
    -v "${ISO_DIR}:/iso:ro" \
    -v "${WORK_DIR}:/workdir" \
    -v "${OUT_DIR}:/out" \
    archlinux:latest \
    bash -c "
        set -euo pipefail
        echo 'Server = https://mirror.yandex.ru/archlinux/\$repo/os/\$arch' > /etc/pacman.d/mirrorlist
        echo 'Server = https://mirror.truenetwork.ru/archlinux/\$repo/os/\$arch' >> /etc/pacman.d/mirrorlist

        echo '==> Установка archiso внутри контейнера...'
        pacman -Sy --noconfirm archiso

        echo '==> Очистка рабочей директории от прошлых сборок...'
        rm -rf /workdir/*

        echo '==> Запуск mkarchiso...'
        mkarchiso -v -w /workdir -o /out /iso

        echo '==> Передача прав на собранный ISO пользователю хоста...'
        chown -R ${HOST_UID}:${HOST_GID} /out
    "

echo "[OK] Сборка завершена! Готовый образ находится в ${OUT_DIR}:"
ls -lh "${OUT_DIR}"/*.iso
