# KazeOS - Devlog

> A log of development progress, failures, and lessons learned.
> Newest entries on top.

---

## Template (copy for each new entry)

### YYYY-MM-DD - Phase N: Short title

**Done:**
- What actually works now.

**Broke / struggled with:**
- What didn't work, error messages, dead ends.

**Learned:**
- What I now understand that I didn't before.

**Next:**
- The immediate next step (one or two items).

---

## 2026-11-06 - Phase 1: Project scaffolding

**Done:**
- Finalized `CONCEPT.md`.
- Created monorepo structure: `iso/`, `installer/`, `dotfiles/`, `scripts/`.
- Started `DEVLOG.md`.

**Broke / struggled with:**
- Nothing yet - just planning.

**Learned:**
- That devlog ≠ changelog: one is for me, one is for users.

**Next:**
- Copy archiso `releng` profile into `iso/`.
- Build the first bare ISO and boot it in QEMU.

## Phase 1 — Isolated Build Environment and Basic UEFI ISO

### Done
- Set up an isolated build environment within a `podman` container based on the official `archlinux:latest` image (ensuring the CachyOS host does not influence the package base of the distribution being built).
- Created an idempotent script, `scripts/bootstrap-profile.sh`, which copies the reference `releng` profile from a fresh `archiso` package inside the container and adjusts ownership (`chown`) back to the host user.
- Configured `iso/profiledef.sh` for KazeOS branding (`iso_name="kazeos"`, `iso_label="KAZEOS_YYMM"`, `iso_version="linux-YYYY.MM"`).
- Developed a build script, `scripts/build-iso.sh` (utilizing `podman run --rm --privileged` and `mkarchiso`), with the profile mounted in `:ro` (read-only) mode.
- Created a test script, `scripts/test-iso.sh`, to launch the ISO in `qemu-system-x86_64` (configured with KVM, 4GB of RAM, and UEFI OVMF).
- Configured `.gitignore` to exclude `out/`, `workdir/`, `*.iso`, `*.qcow2`, and `*.img`.
- Successfully built the initial vanilla image, `kazeos-linux-2026.11-x86_64.iso` (1.3 GB), and verified that it boots via UEFI into a root shell (confirmed by the presence of `/sys/firmware/efi/efivars`).

!First distro ISO realese only in 2027 year (around the beginning)!

