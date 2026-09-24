# My Omarchy setup

On 11 September 2026 I installed [Omarchy](https://github.com/basecamp/omarchy) on my laptop.
Omarchy is DHH's opinionated Arch Linux + Hyprland setup. Out of the box it gives you a
keyboard-driven desktop with a theme, a bar, a launcher and a lot of preinstalled apps, so most of
what I've done since is small tweaks on top.

This repo holds those tweaks and a journal of why I made each one. Everything under `config/`
mirrors `~/.config/`, and it only contains files I actually changed. Omarchy's own defaults live in
`/usr/share/omarchy/config/` and update with the package, so I don't copy them here.

## The machine

| | |
|---|---|
| Laptop | Lenovo IdeaPad L3 15IML05 |
| CPU | Intel Core i5-10210U, 4 cores / 8 threads |
| RAM | about 11.4 GiB usable |
| Screens | built-in 1920×1080 panel, plus an HP V214a 1080p monitor over HDMI |
| Omarchy | 4.0.3, Tokyo Night theme |
| Projects drive | a separate NTFS partition, mounted at `/run/media/oll/Linux` |

## Journal

### 11 September: install day

Omarchy went onto a fresh Arch base: btrfs, the Limine bootloader and Snapper snapshots, all set up
by the installer. I kept the default Tokyo Night theme.

**Display scale.** The first thing I fought with was scaling. Omarchy picks a scale for you, and I
went through 2, 1 and 1.25 before settling on **1.6**. At 1.6 a 1080p screen works out to 1200×675
logical pixels. It applies to every monitor, so the HP monitor
gets the same scale. `GDK_SCALE` stays at Omarchy's 2 for GTK apps.
([`config/hypr/monitors.lua`](config/hypr/monitors.lua))

**Terminal font size.** At 1.6 scale the default 9pt terminal font was too big. I dropped it to
**7pt** in all four terminals Omarchy ships configs for (Alacritty, foot, Ghostty and Kitty), so
it's the same whichever one opens. 7pt at 1.6 scale looks about like 11pt at 1×.
([`config/alacritty/`](config/alacritty/alacritty.toml), [`config/foot/`](config/foot/foot.ini),
[`config/ghostty/`](config/ghostty/config), [`config/kitty/`](config/kitty/kitty.conf))

**My name on the screensaver.** Omarchy's screensaver draws ASCII art from
`~/.config/omarchy/branding/screensaver.txt`. I added my name above the Omarchy logo.
([`config/omarchy/branding/screensaver.txt`](config/omarchy/branding/screensaver.txt))

**Dev tools.** Omarchy comes with [mise](https://mise.jdx.dev) for language runtimes, so I used it
for my own tools too: Node 26.8.1, the GitHub CLI and Codex. Claude Code came from pacman.
([`config/mise/config.toml`](config/mise/config.toml), [`packages.txt`](packages.txt))

### 12 September: making it mine

**Zen browser.** I installed Zen with Omarchy's own browser installer
(`omarchy install browser zen`). It pulls Zen from the AUR and writes `MOZ_ENABLE_WAYLAND=1` into
`~/.config/environment.d/`. Hyprland already sets that variable for apps it launches, and the
environment.d copy covers anything the systemd user session starts, so Firefox-based browsers
always run on Wayland.
([`config/environment.d/`](config/environment.d/omarchy-firefox-wayland.conf))

**The NTFS projects drive.** My projects live on a separate NTFS partition, so I installed the NTFS
tools and changed two git settings to go with it. NTFS has no Unix permission bits, so every file
looks executable and git reports a mode change on all of them. `core.filemode = false` stops that.
`core.autocrlf = input` turns any CRLF line endings into LF when I commit. I left out the
credential-helper lines: `gh auth setup-git` writes those.
([`config/git/config`](config/git/config))

**"Open in Terminal" in Nautilus.** `nautilus-open-any-terminal` adds a right-click entry that
opens the current folder in my terminal, not only in GNOME Terminal.

**VPN and Kubernetes.** I added Tailscale, WireGuard and kubectl. `systemd-resolvconf` is there
because `wg-quick` needs a `resolvconf` binary to apply a tunnel's DNS settings, and Arch doesn't
ship one by default.

**Thunderbird and Firefox.** Thunderbird for mail, and plain Firefox next to Zen for sites that
misbehave in Zen.

**Brave, set up like Omarchy's Chromium.** Omarchy tunes Chromium through `chromium-flags.conf`,
and Brave reads the same flags from `brave-flags.conf`. Mine is an exact copy of Omarchy's
Chromium flags, which is also what `omarchy install browser brave` puts there. Brave runs natively
on Wayland, saves passwords to the GNOME keyring, supports swipe-to-go-back on the touchpad, and
loads Omarchy's bundled extensions (copy URL, yt-dlp and a slimmer WhatsApp).
([`config/brave-flags.conf`](config/brave-flags.conf))

**Telegram.** I installed the native desktop app instead of a web app.

### 14 September: small daily annoyances

**Opening links in foot.** foot never makes URLs clickable with the mouse. Instead it has a hint
mode: **Ctrl+Shift+O** labels every URL on screen, and typing a label opens that link. I bound
**Ctrl+Shift+Y** to copy a link instead of opening it. The labels use home-row letters, so I don't
have to look at the keyboard, and they cover OSC-8 hyperlinks too, not only bare URLs.
(Ctrl+Shift+U was my first choice, but foot already uses it for Unicode input.)
([`config/foot/foot.ini`](config/foot/foot.ini))

**Brave as the default browser.** Links from other apps now open in Brave. Omarchy's
Setup > Defaults > Browser menu sets this with `xdg-settings`, which writes `mimeapps.list`.
([`config/mimeapps.list`](config/mimeapps.list))

**A graphical system monitor.** btop is great, but sometimes I want graphs and a process list I can
click. I installed Mission Center and bound it to **Super+Shift+Ctrl+T**. **Super+Ctrl+T** still
opens btop, so both are one chord apart.
([`config/hypr/bindings.lua`](config/hypr/bindings.lua))

### 15 September

**FileZilla** for moving files to and from servers over SFTP.
