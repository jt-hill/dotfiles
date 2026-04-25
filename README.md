# dotfiles to make things the way I like them

## neovim + lazyvim

lazyvim has some requirements, of which the most important is tree-sitter

```bash
sudo pacman -S neovim
sudo pacman -S git rg fd fzf curl unzip tar
sudo pacman -S lazygit tree-sitter tree-sitter-cli
```

```bash
# launch neovim with minimal config 
nvim

# launch neovim with lazyvim config
lvim 
```

## sway + breeze

### Sway setup

```bash
# Core Sway
sudo pacman -S sway waybar swaybg swaylock swayidle kitty rofi

# System utilities
sudo pacman -S network-manager-applet blueman pavucontrol brightnessctl
sudo pacman -S pamixer playerctl grim slurp dunst

# Breeze theme + Qt bridge
sudo pacman -S breeze breeze-gtk breeze-icons
sudo pacman -S qt5ct qt6ct kvantum

# XDG portal for theme switching
sudo pacman -S xdg-desktop-portal-gtk xdg-desktop-portal-wlr

# Polkit agent (for password prompts)
sudo pacman -S polkit-gnome

# Optional but recommended
sudo pacman -S wl-clipboard noto-fonts noto-fonts-emoji
```

**Make theme-toggle executable:**

   ```bash
   chmod +x ~/.local/bin/theme-toggle
   ```

## ASUS PG278Q via Thunderbolt dock (EDID override)

### The problem

The PG278Q shows up at 640x480 (small centered box) when connected through a
Thunderbolt dock, even though the same dock + monitor + cable works fine on
Windows. The kernel detects the DP connector as `connected` but reads zero bytes
of EDID.

### Why this happens

The dock hardware is not at fault — it passes EDID correctly (confirmed by
testing with a Windows laptop through the same dock). The issue is the i915
driver's DDC/I2C-over-AUX transaction failing silently when tunneled through
Thunderbolt. Evidence:

- `CONFIG_DRM_I915_DP_TUNNEL=y` is set and the TB link is established at full
  speed (40 Gb/s USB4), so the tunnel infrastructure is present.
- The DP connector shows `status: connected` in sysfs, meaning link training
  succeeds — only the EDID read fails.
- The kernel produces zero log messages about EDID failures; the AUX read
  returns empty rather than erroring.
- The DP AUX devices (`/dev/drm_dp_aux*`) exist and map correctly to DDI
  outputs.

This appears to be a known class of i915 bugs with Comet Lake (CML) and
Thunderbolt DP tunneling. Relevant upstream references:

- i915 DP tunnel support was added in kernel 6.9 (see `CONFIG_DRM_I915_DP_TUNNEL`)
- Ongoing TB DP tunnel work: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues?label_name=Thunderbolt
- General EDID-over-TB issues: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues?label_name=EDID

This may be fixed in a future kernel. Adding `drm.debug=0x1e` to the kernel
cmdline will produce verbose DP AUX transaction logs if you want to file a bug.

### The workaround

Force-load a custom EDID via kernel parameter. A pre-built EDID binary lives at
`hyprland/.config/hypr/edid/pg278q.bin` with DTDs for 120Hz (primary) and 60Hz
(fallback), generated using standard CVT Reduced Blanking timings.

```bash
# Install the EDID firmware where the kernel can find it
sudo mkdir -p /lib/firmware/edid
sudo cp hyprland/.config/hypr/edid/pg278q.bin /lib/firmware/edid/pg278q.bin

# Add the kernel parameter (adjust DP-1 if your connector differs)
# Append to /etc/kernel/cmdline:
#   drm.edid_firmware=DP-1:edid/pg278q.bin

# Rebuild UKI and reboot
sudo mkinitcpio -P
systemctl reboot
```

### Regenerating the EDID

If the display is blank after reboot but `hyprctl monitors` shows it active, the
timing is wrong. The PG278Q has a dedicated G-Sync module (not a standard scaler)
that is very picky about signal timings. Rules:

- DTDs **must** use exact CVT Reduced Blanking values from `cvt <w> <h> <hz> -r`
- Sync polarity **must** be +H -V (flag byte `0x1A`). Using +H +V causes a
  completely blank screen even though the compositor reports the mode as active.
- V blanking must match CVT-R exactly — close-but-wrong values also blank out.

Working CVT-R timings (from `cvt -r`):

| Rate  | Pixel clock | H total | V total | Feasible through dock? |
|-------|-------------|---------|---------|------------------------|
| 60Hz  | 241.50 MHz  | 2720    | 1481    | Yes                    |
| 120Hz | 497.25 MHz  | 2720    | 1525    | Yes (DP 1.2 HBR2 max ~540 MHz) |
| 144Hz | 808.75 MHz  | 3584    | 1568    | No (exceeds DP 1.2 bandwidth)  |

The EDID was generated with a Python script (see git history). The PG278Q is not
in the [linuxhw/EDID](https://github.com/linuxhw/EDID) database. Always verify
with `edid-decode` after regenerating.

### Without a fallback display

This is still fixable from a headless state. The 640x480 fallback (no EDID
override) does produce a visible picture, and TTY/SSH both work. The dangerous
case is a timing the G-Sync module fully rejects (blank screen) — have SSH
access ready when experimenting with new timings.

## joplin TUI

```bash
# requires npm
sudo pacman -S npm

#install through npm
NPM_CONFIG_PREFIX=~/.joplin-bin npm install --loglevel=error -g joplin
# symlink to bin dir
sudo ln -s ~/.joplin-bin/bin/joplin /usr/local/bin/joplin
```
