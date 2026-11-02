# LinkedIn series: six weeks with Omarchy

Six posts, one every two or three days. Each post lists its images in the order to upload them.
LinkedIn shows plain text only, so there's no markdown below the `---` lines: paste as is.
All numbers come from the journal in https://github.com/Olwethu-Dlamini/omarchy.

---

## Post 1: Six weeks with Omarchy

Images: `images/omarchy-official/tokyo-night-preview.png`, `images/omarchy-official/navigation-fourway-tiling.png`, `images/github-repo.png`

On 11 September I installed Omarchy on my laptop. On 23 October I wiped it.

The whole time I kept a journal in a public GitHub repo: 80 commits, every tweak and every fix, each with the reason I made it.

Omarchy is DHH's opinionated Arch Linux + Hyprland setup. You run one installer and get a finished, keyboard-driven desktop: disk encryption, btrfs with snapshots, a themed bar, a launcher, four ready-made terminals and the dev tools already in place.

My first impression: the best out-of-the-box Linux desktop I've used. Everything happens from the keyboard. Super+Return opens a terminal, Super+Shift+Return a browser, and they tile side by side on their own, no dragging. Super+J stacks them, Super+Arrow moves between them, Super+1 to 0 jumps workspaces. And when you forget a shortcut, Super+K lists every one of them.

Then October came. The laptop froze solid four times: screen stuck, keyboard dead, only the power button worked.

This series covers what I liked, what broke, and what I learned fixing it:

1. Six weeks with Omarchy (this post)
2. A line or two in the right file
3. The slow laptop that wasn't short of RAM
4. Screen sharing, a missing mic, and two innocent apps
5. The freezes
6. Why I left, and what I took with me

The machine: a Lenovo IdeaPad L3, Core i5-10210U, about 11 GiB of RAM.

Repo: https://github.com/Olwethu-Dlamini/omarchy

Screenshots: Omarchy Manual, omarchy.org

#Linux #ArchLinux #Omarchy #Hyprland #OpenSource

---

## Post 2: A line or two in the right file

Image: `images/2-a-line-or-two.png`

Part 2 of my Omarchy series: making it mine.

What I liked most about Omarchy is how it splits its files from yours. Its defaults live in /usr/share/omarchy and get replaced on every update. Your files in ~/.config load after them, so yours always win and an update never undoes your changes.

That meant almost every change I made was a line or two:

→ Display scale 1.6. I tried 2, 1 and 1.25 first. At 1.6 a 1080p screen works out to 1200×675.
→ Terminal font down to 7pt in all four terminals Omarchy ships with. At 1.6 scale that looks about like 11pt.
→ A transparent bar with the workspaces first, and the screen locking after 30 minutes instead of 5.
→ RAM usage in the bar, because with 11 GiB, memory is what runs out first.
→ Brave reading the same flags as Omarchy's Chromium: native Wayland, passwords in the GNOME keyring, swipe to go back.
→ Ctrl+Shift+O in the foot terminal to open any link on screen from the keyboard.
→ My name above the Omarchy logo on the ASCII screensaver.

Lesson: pick the display scale first. Everything else follows from it.

Every one of those files is in the repo, with the reason next to it: https://github.com/Olwethu-Dlamini/omarchy

#Linux #Omarchy #Hyprland #Dotfiles

---

## Post 3: It wasn't the RAM

Image: `images/3-not-the-ram.png`

Part 3 of my Omarchy series: "the laptop is slow".

Some days it crawled with the RAM bar at 60%, and the browsers kept crashing. Easy answer: buy more RAM. The logs said no. Nothing had been killed for lack of memory since the last boot.

What it actually was:

1. Power-saver on the charger. Omarchy remembers one power profile for AC and one for battery. Power-saver was picked for AC on install day and stuck for three weeks. One command, omarchy-powerprofiles-set ac balanced, and the same Python loop went from 18–23 seconds to 4.4–5.6. About four times faster.

2. Crash dumps. When a program crashes, systemd saves its memory and works out a backtrace, with no size limit by default. One Cypress crash dump used up to 4.3 GB of RAM and three minutes of CPU, and there were seven that day. I capped dumps at 1 GiB.

3. My projects live on a 5400rpm hard disk. Every task was stalled waiting on it 4–6% of the time.

Lessons:
→ Check the power profile before blaming RAM. powerprofilesctl get takes a second.
→ A high RAM percentage isn't the same as running out. Check /proc/pressure/memory and the journal for OOM kills first.

#Linux #Performance #Debugging #Omarchy

---

## Post 4: Both times, the app was innocent

Image: `images/4-the-app-was-innocent.png`

Part 4 of my Omarchy series: two bugs where the app was blamed and wasn't at fault.

Teams in Brave could share a window, but not my whole screen. Brave's log: "Failed to request session: Timeout was reached".
On Wayland a browser doesn't list your screens itself. It asks the desktop portal, and on Hyprland that's xdg-desktop-portal-hyprland. Mine had been stuck at 100% of one CPU core for a week and wasn't answering anyone. One restart fixed it. Then I wrote a small systemd timer that asks the portal a question every 5 minutes and restarts it if it doesn't answer within 10 seconds. I tested it by freezing the portal on purpose with kill -STOP.

A few days later Brave said I had no microphone. The mic was fine: I recorded from it. The cause was that PipeWire, the audio server, had crashed at 08:01 and systemd restarted it within a second. Everything reconnected, so nothing looked wrong. Except Brave's audio helper process was older than the restart and still held the old device list.
The fix was to stop that one helper process. Not Brave, not PipeWire. Every tab stayed open.

Lessons:
→ When screen sharing is missing an option, check the portal before the app.
→ When an app can't find a device the system can see, ask whether the daemon restarted.
→ Restart the smallest thing that's stale.

To be fair to Omarchy: both of these are upstream bugs. It just took me a while to learn what Omarchy had set up for me.

#Linux #Wayland #PipeWire #Debugging #Omarchy

---

## Post 5: The freezes

Images: `images/5-the-freezes.png`, `images/github-commits-freezes.png`

Part 5 of my Omarchy series: the part that ended it.

Four times in October the laptop froze solid. Screen stuck, keyboard dead, only the power button worked. The RAM bar said 58%.

I read the journal of every boot since September. Three of the four crashes ended the same way:

zram: Decompression failed!
Read-error on swap-device
Oops: ... zram_slot_free_notify
Fixing recursive fault but reboot is needed!

zram is compressed swap that lives in RAM, and Omarchy turns it on sized to all of your memory. I only found out it existed when it showed up in my crash logs.

My commit on 21 October said: "it is zram". So I turned zram off.

The next evening the kernel crashed again. Ten oopses in unrelated parts of the kernel: file lookups, btrfs, memory compaction. Brave died with SIGILL, which means the CPU was handed something that isn't an instruction.

A kernel bug usually crashes in the same place each time. Crashes all over the place look like memory that doesn't hold what was written to it. zram was only the messenger: it checks every page when it decompresses it, so it was the first to notice the damage.

The main suspect is now the no-name 8 GiB RAM stick I added: blank part number, unknown maker. Memtest86+ overnight is what will prove it either way.

Lessons:
→ A kernel crash isn't something a program can catch. The RAM bar and the OOM killer watch for running out of memory, not for bad memory.
→ Turning off the part that reports an error doesn't remove the cause.

#Linux #Kernel #Debugging #Hardware #Omarchy

---

## Post 6: Why I left Omarchy

Images: `images/my-arch/sway-tiling.png`, `images/my-arch/sway-super-k.png`, `images/omarchy-official/navigation-fourway-tiling.png`

Last part of my Omarchy series: leaving.

On 23 October, six weeks after installing it, I wiped Omarchy for a plain Arch install that I set up myself.

The freezes weren't Omarchy's fault. If my RAM stick is bad, plain Arch will freeze too. So why leave?

What Omarchy gave me: a finished desktop on day one. Encryption, btrfs snapshots, Hyprland, a themed bar, a launcher, four terminals, mise, btop. In six weeks almost every change I made was a line or two.

Where my time went: every problem I chased started with finding out what had already been set up for me. A power profile that had quietly stuck. A screen-share portal I didn't know I had. zram I only met in a crash log. On top of Arch, Omarchy also has its own layer to learn: a Lua Hyprland config, a shell.json for the bar, and a set of omarchy-* commands. None of that carries over.

I want an Arch where I put everything there myself. Then whatever is running is something I chose and know how to change.

The thing I refused to give up was the keyboard. Omarchy taught me to stop reaching for the mouse, so the day after, the new install was up with Sway, Waybar and Wofi and the same keys: Super+Return for a terminal, Super+Space for the launcher, Super+W to close, Super+J to flip the split, Super+Arrow to move between tiled windows, Super+1 to 0 for workspaces, and Super+K for a searchable list of every binding, just like Omarchy's. Windows still tile on their own.

The fixes that weren't tied to Omarchy, like the mic filter, the crash-dump cap, the drive fix and the git settings, work on any Arch, so they come with me.

Would I recommend Omarchy? If you want a beautiful Linux desktop that works on the first day, yes. Just know that a lot has been chosen for you, and one day you'll need to know what.

The full journal, every fix and the troubleshooting steps: https://github.com/Olwethu-Dlamini/omarchy

First two screenshots: my Arch + Sway. Third: Omarchy, from the Omarchy Manual at omarchy.org

#Linux #ArchLinux #Omarchy #Sway #OpenSource
