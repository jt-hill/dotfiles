# Fedora workstation dotfiles

Personal configuration for a Fedora 44 workstation running COSMIC. Fedora and
COSMIC provide almost all of the desktop defaults; this repository now mainly
contains shell/editor configuration, TPM-backed root-disk unlock, and the ASUS
PG278Q dock workaround.

The `hyprland/`, `sway/`, and related desktop directories are retained as legacy
configuration. They are not required for the current COSMIC setup.

## Bootstrap

Install the small set of tools used by the active configuration:

```bash
sudo dnf install git stow zsh neovim ripgrep fd-find fzf tree-sitter-cli
```

Clone the repository into `~/.dotfiles`, then use GNU Stow for only the packages
needed on the machine:

```bash
git clone git@github.com:jt-hill/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

stow zsh shell nvim lazyvim
```

Other directories can be stowed individually when their corresponding
application is installed; for example, `stow ghostty`.

The two Neovim configurations can coexist:

```bash
nvim  # minimal configuration
lvim  # LazyVim via NVIM_APPNAME=lazyvim
```

## Boot Fedora without the GRUB delay

Install the tracked GRUB defaults and regenerate Fedora's real GRUB
configuration. `GRUB_DEFAULT=0` selects the first entry (Fedora's latest
kernel), while a hidden zero-second timeout boots it immediately:

```bash
sudo install -Dm644 etc/default/grub /etc/default/grub
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
```

Use the computer's UEFI boot menu if another operating system needs to be
started. To restore the visible GRUB menu, change `GRUB_TIMEOUT` to a positive
number and regenerate `/boot/grub2/grub.cfg`.

## Unlock the encrypted root disk with TPM2

This workstation's root file system is in the LUKS2 volume on
`/dev/nvme0n1p3`. Enroll an additional key sealed to PCR 7
(`secure-boot-policy`). The TPM will release it while Secure Boot is enabled
with the same UEFI trust databases. Disabling Secure Boot, clearing the TPM, or
changing PK, KEK, db, or dbx will fall back to the existing LUKS passphrase.

Do not remove the passphrase slot. It is the recovery path if the TPM or Secure
Boot policy changes.

### Check and enroll

Confirm the assumptions first:

```bash
mokutil --sb-state
systemd-cryptenroll --tpm2-device=list
lsblk -f
sudo cryptsetup luksDump /dev/nvme0n1p3
```

The expected results are Secure Boot enabled, one TPM2 device, and LUKS version
2 with at least one passphrase key slot. Back up the LUKS header before adding a
token, install the dracut rule, and enroll PCR 7 explicitly:

```bash
luks_header_backup="/root/luks-root-header-before-tpm-$(date +%F-%H%M%S).img"
sudo cryptsetup luksHeaderBackup /dev/nvme0n1p3 \
  --header-backup-file "$luks_header_backup"
sudo chmod 600 "$luks_header_backup"
printf 'LUKS header backup: %s\n' "$luks_header_backup"

sudo install -Dm644 etc/dracut.conf.d/20-tpm2-root.conf \
  /etc/dracut.conf.d/20-tpm2-root.conf

sudo systemd-cryptenroll \
  --wipe-slot=tpm2 \
  --tpm2-device=auto \
  --tpm2-pcrs=secure-boot-policy \
  /dev/nvme0n1p3
```

`systemd-cryptenroll` asks for the current LUKS passphrase. `--wipe-slot=tpm2`
only replaces an older systemd TPM token; it does not wipe passphrase slots.

Install the tracked root-volume configuration. It preserves the Fedora
installer's existing options and adds `tpm2-device=auto`:

```bash
sudo install -m600 etc/crypttab /etc/crypttab
```

The installed entry is:

```text
luks-73990c49-c04a-4212-b1fb-2357d7e1ab8f UUID=73990c49-c04a-4212-b1fb-2357d7e1ab8f none discard,x-initrd.attach,tpm2-device=auto
```

The PCR selection is stored in the LUKS2 token metadata, so it does not need to
be repeated in `crypttab`. Rebuild the current initramfs only after both the
dracut rule and `crypttab` are in place:

```bash
sudo dracut --force --kver "$(uname -r)"
```

### Verify and test

Before rebooting, verify that the token is bound to PCR 7 and that the initramfs
contains TPM support and the updated `crypttab`:

```bash
sudo cryptsetup luksDump /dev/nvme0n1p3
sudo lsinitrd /boot/initramfs-"$(uname -r)".img | \
  grep -E 'crypttab|systemd-tpm2|tpm2-tss|systemd-cryptsetup'
```

Reboot normally. Root should unlock without a prompt. To test the recovery path,
disable Secure Boot temporarily in UEFI: TPM unlock should fail and the normal
LUKS passphrase prompt should appear. Re-enable Secure Boot afterward; PCR 7
should return to its enrolled value and automatic unlock should resume.

PCR 7 deliberately tracks Secure Boot policy rather than individual Fedora
kernels, so normal signed kernel and initramfs updates do not require
re-enrollment. This is convenient but does not authenticate the separately
stored initramfs; protecting that too requires a measured/signed UKI policy and
update integration.

### Remove TPM unlock

Boot normally or unlock with the recovery passphrase, then remove only the TPM
slot:

```bash
sudo systemd-cryptenroll --wipe-slot=tpm2 /dev/nvme0n1p3
sudoedit /etc/crypttab  # remove only tpm2-device=auto
sudo rm /etc/dracut.conf.d/20-tpm2-root.conf
sudo dracut --force --kver "$(uname -r)"
```

## ASUS PG278Q through the Thunderbolt dock

### Problem

The PG278Q appears as a 640x480 display when connected through the Thunderbolt
dock. The kernel detects DisplayPort as connected, but the i915 driver reads a
zero-byte EDID through the Thunderbolt DisplayPort tunnel. The same dock,
monitor, and cable work correctly on Windows.

Confirm the failure with:

```bash
cat /sys/class/drm/card*-DP-1/status
wc -c /sys/class/drm/card*-DP-1/edid
cat /sys/class/drm/card*-DP-1/modes
```

The affected workstation reports `connected`, an EDID size of `0`, and only
fallback display modes.

### Fedora workaround

The repository contains a custom 128-byte EDID with exact CVT Reduced Blanking
timings for 2560x1440 at 120 Hz and 60 Hz. Install it as firmware, make dracut
include it in future initramfs images, and tell the kernel to use it for DP-1:

```bash
cd ~/.dotfiles

sudo install -Dm644 hyprland/.config/hypr/edid/pg278q.bin \
  /usr/lib/firmware/edid/pg278q.bin
sudo install -Dm644 etc/dracut.conf.d/10-pg278q-edid.conf \
  /etc/dracut.conf.d/10-pg278q-edid.conf

sudo grubby --update-kernel=ALL \
  --args='drm.edid_firmware=DP-1:edid/pg278q.bin'

sudo dracut --force --kver "$(uname -r)"
systemctl reboot
```

The dracut rule keeps the firmware embedded when Fedora builds initramfs images
for later kernel updates.

### Verify after reboot

```bash
grep -o 'drm.edid_firmware=[^ ]*' /proc/cmdline
wc -c /sys/class/drm/card*-DP-1/edid
cat /sys/class/drm/card*-DP-1/modes
```

The kernel command line should contain
`drm.edid_firmware=DP-1:edid/pg278q.bin`, the connector EDID should be 128 bytes,
and `2560x1440` should be among its modes.

### Timing details

The PG278Q has a dedicated G-Sync module that rejects timings a normal scaler
might accept. Its detailed timing descriptors must use exact CVT Reduced
Blanking values and `+H -V` sync polarity (`0x1A`).

| Rate | Pixel clock | H total | V total | Through DP 1.2 dock |
|------|-------------|---------|---------|---------------------|
| 60 Hz | 241.50 MHz | 2720 | 1481 | Yes |
| 120 Hz | 497.25 MHz | 2720 | 1525 | Yes |
| 144 Hz | 808.75 MHz | 3584 | 1568 | No |

Regenerate and validate the committed binary with:

```bash
python3 hyprland/.config/hypr/edid/generate-pg278q.py
edid-decode hyprland/.config/hypr/edid/pg278q.bin
```

`edid-decode` is optional and may need to be installed separately. The generator
itself checks the EDID length and checksum.

If a modified timing produces a blank screen, use the laptop panel, a TTY, or
SSH to recover. The no-override state still produces a visible 640x480 fallback.

### Remove the workaround

```bash
sudo grubby --update-kernel=ALL \
  --remove-args='drm.edid_firmware=DP-1:edid/pg278q.bin'
sudo rm /etc/dracut.conf.d/10-pg278q-edid.conf
sudo rm /usr/lib/firmware/edid/pg278q.bin
sudo dracut --force --kver "$(uname -r)"
```
