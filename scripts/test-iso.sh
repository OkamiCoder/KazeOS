#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
OUT_DIR="${REPO_ROOT}/out"

ISO_FILE="$(find "${OUT_DIR}" -maxdepth 1 -name "kazeos-*.iso" -printf "%T@ %p\n" 2>/dev/null | sort -n | tail -n 1 | cut -d' ' -f2-)"

if [[ -z "${ISO_FILE}" || ! -f "${ISO_FILE}" ]]; then
    echo "[ERROR] ISO-образ не найден в ${OUT_DIR}. Сначала запустите ./scripts/build-iso.sh"
    exit 1
fi

# Для флага -bios в новых версиях edk2-ovmf требуется цельный образ OVMF.4m.fd (ровно 4 МБ)
OVMF_CANDIDATES=(
    "/usr/share/ovmf/x64/OVMF.4m.fd"
    "/usr/share/edk2/x64/OVMF.4m.fd"
    "/usr/share/ovmf/x64/OVMF.fd"
    "/usr/share/edk2/x64/OVMF.fd"
)

OVMF_BIOS=""
for candidate in "${OVMF_CANDIDATES[@]}"; do
    if [[ -f "${candidate}" ]]; then
        OVMF_BIOS="${candidate}"
        break
    fi
done

if [[ -z "${OVMF_BIOS}" ]]; then
    echo "[ERROR] Файл прошивки OVMF не найден! Убедитесь, что установлен пакет edk2-ovmf."
    exit 1
fi

echo "[INFO] Используем ISO:  ${ISO_FILE}"
echo "[INFO] Используем UEFI: ${OVMF_BIOS}"
echo "[INFO] Запускаем QEMU (KVM, 4G RAM)..."

qemu-system-x86_64 \
    -enable-kvm \
    -cpu host \
    -smp 2 \
    -m 4G \
    -bios "${OVMF_BIOS}" \
    -cdrom "${ISO_FILE}" \
    -boot d
