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
