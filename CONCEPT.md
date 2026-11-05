# KazeOS — Concept

> "The essentials out of the box, the rest — you control."

## 1. What is KazeOS

KazeOS is a Linux distribution based on Arch Linux. It is not a fork and does not
maintain its own package repository. Instead, it is an **automation layer for
installing pure Arch** with a focus on minimalism and tiling window managers (WMs)
instead of full desktop environments (DEs).

**The sharp angle:** the thinnest Arch installer — kernel + WM + browser, nothing more.

## 2. Philosophy

1.  **Thinness.** In the ISO and the installed system — only the essentials.
    No DEs, office suites, games, or "managers for everything".
2.  **User control.** After installation — standard `pacman -Syu`.
    KazeOS does not force updates or maintain its own repo.
3.  **Automation, not replacement.** We don't patch the kernel or fork packages.
    We make the first step — installation — convenient.
4.  **WM over DE.** The user chooses a window manager, not a desktop environment.
    Configs are ready to use but remain the user's property.

## 3. Target User

An average Linux user with basic bash knowledge. Someone who wants Arch + WM
without spending an evening on the wiki and manual setup.

## 4. Technical Decisions

| Parameter | Decision | Rationale |
|---|---|---|
| Architecture | x86_64 | ARM is a separate beast, not for MVP |
| Firmware | UEFI-only (BIOS later) | Fewer tests, modern |
| Kernel | `linux` | Stable, default |
| Bootloader | GRUB | Universal, works with Calamares and LUKS |
| Filesystem | ext4 | Predictable, stable, Calamares-friendly |
| Encryption | LUKS (optional) | A checkbox in Calamares, not forced |
| Backups | Timeshift (rsync) | Works on ext4, reliable |
| **Default WM** | **AwesomeWM** | **Stable on NVIDIA, proven X11** |
| Future WMs | Hyprland, i3WM, Niri | Separate ISOs after MVP |
| Display manager | None | TTY login + WM autostart |
| Languages | RU + EN | Others — after installation |
| Minimum requirements | 2 GB RAM, 20 GB disk | Firefox needs it |

## 5. What's Included

**Base packages:**
- `base`, `base-devel`, `linux`, `linux-firmware`
- `grub`, `efibootmgr`, `os-prober`
- `networkmanager`, `network-manager-applet`
- `pipewire`, `pipewire-pulse`, `pipewire-alsa`, `wireplumber`
- `sudo`, `git`, `timeshift`
- `pciutils`, `util-linux` (for lspci/lscpu)

**User packages:**
- `firefox` — browser
- `nano`, `micro`, `neovim` — editors
- `htop`, `btop`, `less` — monitoring/reading

**Drivers (autodetected via `lspci`):**
- GPU: `mesa` + `xf86-video-amdgpu` / `xf86-video-intel` / `nvidia-open` (by vendor)
- Microcode: `intel-ucode` / `amd-ucode` (by CPU)

**What's NOT included (by design):**
- DEs (GNOME, KDE, XFCE, etc.)
- Office packages, games, messengers
- Own update repository
- Display manager
- Printers, scanners, other peripherals (user-installed)

## 6. Installer UX

1.  Live ISO boots → Calamares autostarts.
2.  Language (RU/EN), keyboard layout.
3.  Disk partitioning: automatic (LUKS optional) or manual.
4.  User creation.
5.  Installation: offline packages + GPU/microcode autodetection.
6.  Post-install: first Timeshift snapshot, timer setup, dotfiles copied from
    `/etc/skel` to `~/.config`.
7.  First login: TTY → WM autostart → welcome window with the project README.

## 7. Branding

- **Name:** KazeOS ("風" — wind).
- **Style:** dark theme, blue/cyan accents, lightweight, airy.
- **Logo:** TBD (by Okami).
- **Versioning:** `YYYY.MM` (e.g., `2026.11`).
- **License:** GPL-3.0.
- **Distribution:** GitHub Releases (+ SourceForge mirror).

## 8. Repository Architecture (Monorepo)

Three independent layers:

1.  **`iso/`** — archiso profile: live system + local offline package repo.
2.  **`installer/`** — Calamares config: `settings.conf`, branding, scripts
    (`detect-gpu.sh`, post-install, Timeshift setup).
3.  **`dotfiles/<wm>/`** — WM configs, copied to `/etc/skel`.

## 9. Roadmap (MVP)

- **Phase 1:** Base ISO with archiso, boots in QEMU.
- **Phase 2:** Calamares installs pure Arch (UEFI + GRUB + ext4).
- **Phase 3:** Local offline repo (installation without internet).
- **Phase 4:** GPU + microcode autodetection (with `nvidia-open` for Turing+).
- **Phase 5:** LUKS + Timeshift, post-install scripts.
- **Phase 6:** AwesomeWM + dotfiles, welcome window, release `2026.XX`.
- **Phase 7:** Other WMs (i3 → Hyprland → Niri), separate ISOs.

**MVP Target Date:** <!-- TBD, e.g., 2027.01 -->

## 10. Out of Scope for MVP (but possible later)

- BIOS/Legacy boot.
- Btrfs + Snapper (complex with Calamares).
- ARM.
- Own update repository.
- Display manager.
- Dotfiles auto-update.

### With <3 by OkamiCoder
