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
