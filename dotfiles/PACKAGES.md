# 📦 Required Packages

Everything your dotfiles depend on. Install these **before** running `install.sh`.

---

## 🐚 Shell

| Program | Purpose | Arch/CachyOS | Fedora |
|---------|---------|-------------|--------|
| `zsh` | Shell | `sudo pacman -S zsh` | `sudo dnf install zsh` |
| `starship` | Prompt | `sudo pacman -S starship` | `sudo dnf install starship` |
| `zsh-autosuggestions` | Fish-style suggestions | `sudo pacman -S zsh-autosuggestions` | `sudo dnf install zsh-autosuggestions` |
| `zsh-syntax-highlighting` | Command coloring | `sudo pacman -S zsh-syntax-highlighting` | `sudo dnf install zsh-syntax-highlighting` |

---

## 🔧 Modern CLI Replacements

| Program | Replaces | Arch/CachyOS | Fedora |
|---------|---------|-------------|--------|
| `eza` | `ls` | `sudo pacman -S eza` | `sudo dnf install eza` |
| `bat` | `cat` | `sudo pacman -S bat` | `sudo dnf install bat` |
| `ripgrep` (`rg`) | `grep` | `sudo pacman -S ripgrep` | `sudo dnf install ripgrep` |
| `fd` | `find` | `sudo pacman -S fd` | `sudo dnf install fd-find` |
| `fzf` | fuzzy finder | `sudo pacman -S fzf` | `sudo dnf install fzf` |
| `zoxide` | `cd` | `sudo pacman -S zoxide` | `sudo dnf install zoxide` |
| `delta` | `git diff` | `sudo pacman -S git-delta` | `sudo dnf install git-delta` |
| `btop` | `top` / `htop` | `sudo pacman -S btop` | `sudo dnf install btop` |
| `dust` | `du` | `sudo pacman -S dust` | `sudo dnf install dust` *(or via cargo)* |
| `xclip` | clipboard (fzf copy) | `sudo pacman -S xclip` | `sudo dnf install xclip` |

---

## 🖥️ Terminal & Launcher

| Program | Purpose | Arch/CachyOS | Fedora |
|---------|---------|-------------|--------|
| `kitty` | Terminal emulator | `sudo pacman -S kitty` | `sudo dnf install kitty` |
| `rofi` | App launcher | `sudo pacman -S rofi` | `sudo dnf install rofi` |
| `fastfetch` | System info | `sudo pacman -S fastfetch` | `sudo dnf install fastfetch` |

---

## 🎨 Fonts (required for icons & Nerd Font symbols)

| Font | Arch/CachyOS | Fedora |
|------|-------------|--------|
| JetBrains Mono (kitty) | `sudo pacman -S ttf-jetbrains-mono` | `sudo dnf install jetbrains-mono-fonts` |
| Nerd Font (icons in zsh/eza) | `sudo pacman -S ttf-jetbrains-mono-nerd` | Install manually from [nerdfonts.com](https://www.nerdfonts.com/font-downloads) |
| Papirus icons (rofi) | `sudo pacman -S papirus-icon-theme` | `sudo dnf install papirus-icon-theme` |

---

## 🖼️ KDE / Wayland

| Program | Purpose | Arch/CachyOS | Fedora |
|---------|---------|-------------|--------|
| `kwriteconfig6` | KDE config tool (desktop names) | included with KDE | included with KDE |
| `qdbus` | KDE D-Bus tool | `sudo pacman -S qt6-tools` | `sudo dnf install qt6-qttools` |

---

## ⚡ One-liner installs

### Arch / CachyOS
```bash
sudo pacman -S --needed zsh starship zsh-autosuggestions zsh-syntax-highlighting \
  eza bat ripgrep fd fzf zoxide git-delta btop dust xclip \
  kitty rofi fastfetch \
  ttf-jetbrains-mono ttf-jetbrains-mono-nerd papirus-icon-theme \
  qt6-tools
```

### Fedora
```bash
sudo dnf install zsh starship zsh-autosuggestions zsh-syntax-highlighting \
  eza bat ripgrep fd-find fzf zoxide git-delta btop xclip \
  kitty rofi fastfetch \
  jetbrains-mono-fonts papirus-icon-theme \
  qt6-qttools
```
> **Note:** `dust` is not in Fedora repos — install via `cargo install du-dust` (requires `rustup`).

---

## 🎨 Rofi theme

Your rofi config references a custom theme at `~/.config/rofi/themes/e595.rasi`.  
Add that file to `dotfiles/rofi/themes/e595.rasi` and `install.sh` will link it automatically.

---

## 🏗️ Source-built apps (your `update-all` alias)

These are compiled from source and live in `~/Apps/` — install manually:

- **cpptrace** — `~/Apps/cpptrace` → [github.com/jeremy-rifkin/cpptrace](https://github.com/jeremy-rifkin/cpptrace)
- **quickshell** — `~/Apps/quickshell` → [quickshell.outfoxxed.me](https://quickshell.outfoxxed.me)
- **qylock** (SDDM theme) — `~/Apps/qylock`

Requires: `cmake ninja git libunwind-devel` (Fedora) / `cmake ninja git libunwind` (Arch)
