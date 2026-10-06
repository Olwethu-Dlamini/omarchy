# My Omarchy setup

On 11 September 2026 I installed [Omarchy](https://github.com/basecamp/omarchy) on my laptop.
Omarchy is DHH's opinionated Arch Linux + Hyprland setup. Out of the box it gives you a
keyboard-driven desktop with a theme, a bar, a launcher and a lot of preinstalled apps, so most of
what I've done since is small tweaks on top.

This repo holds those tweaks and a journal of why I made each one. Everything under `config/`
mirrors `~/.config/` and everything under `etc/` mirrors `/etc`, and they only contain files I
actually changed. Omarchy's own defaults live in
`/usr/share/omarchy/config/` and update with the package, so I don't copy them here.

## The machine

| | |
|---|---|
| Laptop | Lenovo IdeaPad L3 15IML05 |
| CPU | Intel Core i5-10210U, 4 cores / 8 threads |
| RAM | about 11.4 GiB usable |
| Screens | built-in 1920×1080 panel, plus an HP V214a 1080p monitor over HDMI |
| Omarchy | 4.0.3, Tokyo Night theme |
| Projects drive | a separate NTFS partition on a 5400rpm hard disk, mounted at `/run/media/oll/Linux` |

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

### Mid-September: the bar

Omarchy 4's bar and idle settings live in `~/.config/omarchy/shell.json`. I changed three things:

- **Transparent bar**, so the wallpaper shows through behind it.
- **Workspaces first**, before the Omarchy menu button, on the left side. My eyes go to the top-left
  corner to see where I am.
- **Lock after 30 minutes instead of 5.** The screensaver still starts after 150 seconds, but I'm
  not typing my password every time I look away to read something.

([`config/omarchy/shell.json`](config/omarchy/shell.json))

### 23 September: RAM in the bar

With about 11 GiB of RAM and a couple of browsers open, memory is what runs out first on this
laptop, so I wanted it visible all the time. I added a custom module to the right side of the bar.
It shows RAM use as a percentage and the exact GiB in the tooltip, and clicking it opens btop.

The script reads `/proc/meminfo` and counts "used" as `MemTotal - MemAvailable`, the same number
`free` and btop show. Counting `MemFree` instead would look scary, because Linux fills spare RAM
with cache. The bar runs it every 3 seconds.
([`config/omarchy/bar/scripts/ram-usage`](config/omarchy/bar/scripts/ram-usage))

### 2 October: looking for a free coding agent

I wanted a coding agent that runs on free models. My first try was **Qwen Code**, but the free
Qwen sign-in it was built around has ended, so it needs an API key from somewhere else. I
uninstalled it and switched to **OpenCode**. OpenCode keeps several providers at once, and `/models`
switches between them mid-session, so when one free tier runs out I can move to another.

`opencode auth login` saves each provider's key to `~/.local/share/opencode/auth.json`. That file is
outside `~/.config`, so it stays out of this repo.

I timed a one-word reply ("Reply with exactly: OK") on the two free providers I signed up for:

| Provider | Model | Through OpenCode |
|---|---|---|
| NVIDIA | `gpt-oss-20b` | 25s |
| NVIDIA | `glm-5.3-flash` | 79s |
| NVIDIA | `kimi-k3` | 126–146s |
| NVIDIA | `glm-5.3`, `deepseek-v4.1-flash` | no reply within 150s |
| NVIDIA | `kimi-k2.6` | failed straight away with "Unexpected server error" |
| Groq | `gpt-oss-120b`, `gpt-oss-20b`, `qwen3.8-27b` | rejected: "Request too large" |

**NVIDIA** works, but its big models are slow on the free tier. `gpt-oss-20b` answered in 1.4s when
called directly, so the waits come from NVIDIA queueing its large models, not from my key or
OpenCode. A coding task takes many steps, and each one waits that long again. Two models that
OpenCode lists for NVIDIA, `qwen3-coder-480b` and `deepseek-v4-pro`, aren't offered to my key.

**Groq** is fast, about 0.7s for the same prompt sent directly, but OpenCode can't use it at all.
The free tier allows 8,000 tokens per minute (7,000 input tokens on `qwen3.8-27b`). Every OpenCode
request carries its instructions and tool descriptions, about 9,900–10,800 tokens before any of my
code, so Groq rejects each one. The key still works for quick questions sent straight to Groq.

So far neither gives me a big model without lag. Cerebras, Google and Mistral are next to try.

### 5 October: why the laptop felt slow

Some days the laptop crawled even with the RAM bar at 60%, and Brave and Firefox seemed to crash
all the time. I went through the logs, and running out of RAM wasn't it: nothing had been killed
for lack of memory since the last boot.

**The projects drive is a hard disk.** It's a 1 TB WD laptop drive spinning at 5400rpm, not an
SSD. Since the last boot it had been busy for about 7½ hours, around seven times longer than the
NVMe that holds the system, even though it handled fewer requests. The kernel's pressure stats
showed every task stalled on disk 4–6% of the time. Anything that reads a lot of small files in a
project, like git, `node_modules` or an agent scanning the repo, waits on that disk. I'm leaving my
projects there for now.

**The crashes.** On 3 October two Brave tabs crashed, not the whole browser. Brave doesn't publish
debug symbols, so the exact cause can't be seen. On 4 October Brave closed at 20:29 with no crash
record, so that one looks like a normal exit. Firefox hasn't recorded a crash since August. Codex
0.154.0 crashed twice at exactly the same point in its database code, which makes it a Codex bug.

**Power-saver on the charger.** This was the biggest one. Omarchy remembers one power profile for
AC and one for battery, in `~/.local/state/omarchy/powerprofiles/`. Power-saver was picked for AC on
install day and stuck, so for three weeks the CPU barely sped up even while plugged in.
`omarchy-powerprofiles-set ac balanced` changes the remembered AC profile and applies it straight
away. The same Python loop took 18–23s before and 4.4–5.6s after, about four times faster. Battery
stays on power-saver.

**Crash dumps.** When a program crashes, systemd saves a copy of its memory and works out a
backtrace from it, with no size limit by default. Cypress crashed seven times on 30 September, and
each dump ran for five minutes, used up to 4.3 GB of RAM and about three minutes of CPU, then timed
out. The two Brave tab crashes took 4.2–4.6 GB each. With Brave already holding 5 GB of my 11, a
crash was enough to make everything else crawl for a few minutes. Now a dump over 1 GiB is cut off
with no backtrace, and all saved dumps share 1 GiB of disk. The file goes in `/etc`, so it needs
sudo. systemd-coredump reads it on every crash, so nothing needs restarting.
([`etc/systemd/coredump.conf.d/size-limits.conf`](etc/systemd/coredump.conf.d/size-limits.conf))

**Codex.** `mise upgrade codex` moved it from 0.154.0 to 0.160.0. My mise config already says
`latest`, so the config didn't change. The 40 MB download took about 25 minutes from GitHub.
`auto_prune` is off, so 0.154.0 is still installed if I need to go back.

### 6 October: Teams wouldn't share my whole screen

In Teams meetings in Brave I could share a window or a tab, but there was no way to share the
whole screen.

**Brave and Teams weren't the problem.** On Wayland, Brave doesn't list screens itself. It asks
the desktop portal, and on Hyprland that's `xdg-desktop-portal-hyprland` (xdph). Brave's log
showed every request timing out: `Failed to request session: Timeout was reached`, then
`ScreenCastPortal failed`. With no answer from the portal, Brave's **Entire Screen** tab had
nothing in it, so Teams had nothing to offer.

**xdph was stuck.** It had been running since 29 September with its main thread spinning at 100%
of one core: 7½ hours of CPU in a week. It hadn't logged anything since start-up, and it didn't
answer even a simple D-Bus question. I couldn't get a stack trace to see where it was stuck,
because Arch's `ptrace_scope=1` blocks that without sudo. `systemctl --user restart
xdg-desktop-portal-hyprland xdg-desktop-portal` brought it back straight away. Omarchy's share
picker then opened with both monitors, and sharing my entire screen in a real Teams meeting
worked.

**A watchdog so it can't happen silently again.** A small systemd user timer asks xdph for its
screen-share source types every 5 minutes. A healthy xdph answers in milliseconds. If there's no
answer within 10 seconds, the timer restarts both portal services and logs why. To test it, I
froze xdph with `kill -STOP`. The watchdog restarted it on the next check, and the new process
answered straight away. A restart would cut a share that's in progress, but by then the portal
isn't working anyway.
([`config/systemd/user/`](config/systemd/user/portal-watchdog.service))

**Two picks per share.** Chromium-based browsers ask the portal twice for every share: once for
the preview in their own dialog and once for the real share. Omarchy's `xdph.conf` sets
`allow_token_by_default = true`, so after the first pick the second one happens on its own. In
one of my tests the share ended right after I picked a screen, with Brave logging
`PipeWireThreadLoop already exists`. Others describe the same race between the preview and the
real share
([write-up](https://gist.github.com/MasonRhodesDev/088703c61c3f1ac67b1424a193965445)), and their
workaround is to wait a second or two after picking a screen before clicking Brave's **Share**.

## What's in this repo

| File | Goes to | What I changed |
|---|---|---|
| [`config/hypr/monitors.lua`](config/hypr/monitors.lua) | `~/.config/hypr/monitors.lua` | scale 1.6 on every display |
| [`config/hypr/bindings.lua`](config/hypr/bindings.lua) | `~/.config/hypr/bindings.lua` | Super+Shift+Ctrl+T opens Mission Center |
| [`config/omarchy/shell.json`](config/omarchy/shell.json) | `~/.config/omarchy/shell.json` | transparent bar, workspaces first, RAM module, lock after 30 min |
| [`config/omarchy/bar/scripts/ram-usage`](config/omarchy/bar/scripts/ram-usage) | `~/.config/omarchy/bar/scripts/ram-usage` | the RAM module's script |
| [`config/omarchy/branding/screensaver.txt`](config/omarchy/branding/screensaver.txt) | `~/.config/omarchy/branding/screensaver.txt` | my name on the screensaver |
| [`config/alacritty/alacritty.toml`](config/alacritty/alacritty.toml) | `~/.config/alacritty/alacritty.toml` | 7pt font |
| [`config/foot/foot.ini`](config/foot/foot.ini) | `~/.config/foot/foot.ini` | 7pt font, keyboard URL hints |
| [`config/ghostty/config`](config/ghostty/config) | `~/.config/ghostty/config` | 7pt font |
| [`config/kitty/kitty.conf`](config/kitty/kitty.conf) | `~/.config/kitty/kitty.conf` | 7pt font |
| [`config/brave-flags.conf`](config/brave-flags.conf) | `~/.config/brave-flags.conf` | Omarchy's Chromium flags, for Brave |
| [`config/mimeapps.list`](config/mimeapps.list) | `~/.config/mimeapps.list` | Brave as the default browser |
| [`config/environment.d/omarchy-firefox-wayland.conf`](config/environment.d/omarchy-firefox-wayland.conf) | `~/.config/environment.d/` | Firefox and Zen on native Wayland |
| [`config/git/config`](config/git/config) | `~/.config/git/config` | my name, NTFS-friendly `core` settings |
| [`config/mise/config.toml`](config/mise/config.toml) | `~/.config/mise/config.toml` | Node, gh, Codex and OpenCode |
| [`config/opencode/opencode.json`](config/opencode/opencode.json) | `~/.config/opencode/opencode.json` | autoupdate off |
| [`config/systemd/user/portal-watchdog.service`](config/systemd/user/portal-watchdog.service) | `~/.config/systemd/user/` | restarts the screen-share portal if it stops answering |
| [`config/systemd/user/portal-watchdog.timer`](config/systemd/user/portal-watchdog.timer) | `~/.config/systemd/user/` | runs that check every 5 minutes |
| [`etc/systemd/coredump.conf.d/size-limits.conf`](etc/systemd/coredump.conf.d/size-limits.conf) | `/etc/systemd/coredump.conf.d/` | crash dumps capped at 1 GiB |
| [`packages.txt`](packages.txt) | — | everything I installed on top of Omarchy |

## Using these files

Copy a file into place, then reload whatever reads it:

```bash
cp config/omarchy/shell.json ~/.config/omarchy/shell.json
omarchy-restart-shell        # the bar picks up shell.json and bar scripts
```

Files under `etc/` belong in `/etc` and need sudo:

```bash
sudo install -Dm644 etc/systemd/coredump.conf.d/size-limits.conf /etc/systemd/coredump.conf.d/size-limits.conf
```

The systemd user units need reloading, and the timer needs enabling once:

```bash
cp config/systemd/user/portal-watchdog.* ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable --now portal-watchdog.timer
```

`hyprctl reload` reloads Hyprland after a change under `~/.config/hypr/`. Terminals read their
config when they start. `config/environment.d/` only applies after logging out and back in.

To see what I changed compared with Omarchy's version of a file:

```bash
diff /usr/share/omarchy/config/foot/foot.ini config/foot/foot.ini
```

To go back to Omarchy's default for a file, run `omarchy-refresh-config <path under ~/.config>`,
for example `omarchy-refresh-config foot/foot.ini`. It saves your version as `.bak.<timestamp>`
before replacing it.

To install the packages:

```bash
yay -S --needed $(grep -v '^#' packages.txt | awk NF)
```

## Lessons so far

- **Change your own file, not Omarchy's.** Everything under `/usr/share/omarchy` belongs to the
  package and gets replaced on update. The files in `~/.config` load after the defaults, so
  anything I set there wins.
- **Pick the display scale first.** Other settings follow from it. Once I settled on 1.6, the
  terminal fonts had to shrink to match.
- **Omarchy already ships most of what I need.** mise, btop, the bar, the screensaver and the
  keybinding helper (`o.bind`) were all there, and its browser installer set up Zen's Wayland
  variable for me. Most of my changes are a line or two in the right file.
- **For a coding agent, check a free tier's tokens-per-minute limit first.** An agent sends
  thousands of tokens of instructions with every request, before any code. If the per-minute limit
  is smaller than that, the provider can't run the agent at all, however fast it is.
- **When the laptop feels slow, check the power profile first.** `powerprofilesctl get` takes a
  second. Omarchy remembers a profile for AC and one for battery, so a choice made once quietly
  sticks.
- **A high RAM percentage isn't the same as running out.** Before blaming RAM, check
  `/proc/pressure/memory` and `/proc/pressure/io`, and look in the journal for OOM kills. On this
  laptop the stalls came from the CPU profile, the hard disk and crash dumps, not from memory.
- **When screen sharing is missing an option, check the portal before the app.** On Wayland the
  browser only shows what the portal tells it about. One `busctl --user get-property` call
  against xdph shows whether it's answering, and should print `u 7`.
