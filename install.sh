#!/usr/bin/env bash
#
# Installs the tmux + zsh + kitty setup from this repo on macOS or Linux.
# Safe to re-run. Existing configs are backed up to <file>.bak-<timestamp>.
#
#   git clone https://github.com/tskulbru/dotfiles.git
#   cd dotfiles && ./install.sh
#
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TS="$(date +%Y%m%d%H%M%S)"
ZSH_CUSTOM_DIR="$HOME/.oh-my-zsh/custom"

info() { printf '\033[1;34m==>\033[0m %s\n' "$1"; }
warn() { printf '\033[1;33m!! \033[0m %s\n' "$1"; }

# --- detect OS + package manager -------------------------------------------
OS="$(uname -s)"
PM=""
case "$OS" in
  Darwin) PM="brew" ;;
  Linux)
    for c in apt-get dnf pacman zypper; do
      command -v "$c" >/dev/null 2>&1 && PM="$c" && break
    done
    ;;
esac
[[ -z "$PM" ]] && { warn "No supported package manager found; install tmux/zsh/kitty/git/fzf yourself, then re-run."; }

# pkg <generic-name> [brew] [apt] [dnf] [pacman]
pkg_install() {
  local brew_n="${2:-$1}" apt_n="${3:-$1}" dnf_n="${4:-$1}" pac_n="${5:-$1}"
  case "$PM" in
    brew)    brew list "$brew_n" >/dev/null 2>&1 || brew install "$brew_n" ;;
    apt-get) sudo apt-get install -y "$apt_n" ;;
    dnf)     sudo dnf install -y "$dnf_n" ;;
    pacman)  sudo pacman -S --needed --noconfirm "$pac_n" ;;
    zypper)  sudo zypper install -y "$1" ;;
    *)       warn "skip $1 (no package manager)" ;;
  esac
}

# --- dependencies -----------------------------------------------------------
if [[ -n "$PM" ]]; then
  info "Installing packages (zsh, tmux, kitty, git, fzf, neovim)"
  [[ "$PM" == "brew" ]] && ! command -v brew >/dev/null 2>&1 && \
    { warn "Homebrew not found. Install from https://brew.sh then re-run."; exit 1; }
  [[ "$PM" == "apt-get" ]] && sudo apt-get update -y
  pkg_install zsh
  pkg_install tmux
  pkg_install git
  pkg_install fzf
  pkg_install neovim
  # kitty: cask on macOS, regular pkg on Linux
  if [[ "$PM" == "brew" ]]; then
    brew list --cask kitty >/dev/null 2>&1 || brew install --cask kitty
  else
    pkg_install kitty
  fi
fi

# --- Nerd Font (MesloLGS NF, what p10k expects) -----------------------------
info "Installing MesloLGS Nerd Font"
if [[ "$PM" == "brew" ]]; then
  brew list --cask font-meslo-lg-nerd-font >/dev/null 2>&1 || \
    brew install --cask font-meslo-lg-nerd-font || warn "font cask failed; install MesloLGS NF manually"
else
  FONT_DIR="$HOME/.local/share/fonts"
  mkdir -p "$FONT_DIR"
  base="https://github.com/romkatv/powerlevel10k-media/raw/master"
  for f in "MesloLGS%20NF%20Regular.ttf" "MesloLGS%20NF%20Bold.ttf" \
           "MesloLGS%20NF%20Italic.ttf" "MesloLGS%20NF%20Bold%20Italic.ttf"; do
    out="$FONT_DIR/${f//%20/ }"
    [[ -f "$out" ]] || curl -fsSL "$base/$f" -o "$out" || warn "could not fetch $out"
  done
  command -v fc-cache >/dev/null 2>&1 && fc-cache -f "$FONT_DIR" >/dev/null 2>&1 || true
fi

# --- oh-my-zsh + Powerlevel10k + plugins ------------------------------------
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  info "Installing oh-my-zsh"
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

clone_or_pull() { [[ -d "$2" ]] && git -C "$2" pull --quiet || git clone --depth=1 "$1" "$2"; }

info "Installing Powerlevel10k + zsh plugins"
clone_or_pull https://github.com/romkatv/powerlevel10k.git           "$ZSH_CUSTOM_DIR/themes/powerlevel10k"
clone_or_pull https://github.com/zsh-users/zsh-autosuggestions.git    "$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions"
clone_or_pull https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM_DIR/plugins/zsh-syntax-highlighting"

# --- tmux plugin manager ----------------------------------------------------
info "Installing tmux plugin manager (tpm)"
clone_or_pull https://github.com/tmux-plugins/tpm.git "$HOME/.tmux/plugins/tpm"

# --- link configs -----------------------------------------------------------
link() {
  local src="$1" dst="$2"
  [[ -e "$dst" || -L "$dst" ]] && [[ ! -L "$dst" || "$(readlink "$dst")" != "$src" ]] && {
    mv "$dst" "$dst.bak-$TS"; warn "backed up $dst -> $dst.bak-$TS"
  }
  mkdir -p "$(dirname "$dst")"
  ln -sfn "$src" "$dst"
  info "linked $dst"
}

link "$DOTFILES/.config/tmux"  "$HOME/.config/tmux"
link "$DOTFILES/.config/kitty" "$HOME/.config/kitty"
link "$DOTFILES/zsh/zshrc"     "$HOME/.zshrc"
link "$DOTFILES/zsh/p10k.zsh"  "$HOME/.p10k.zsh"
link "$DOTFILES/zsh/aliases.zsh" "$ZSH_CUSTOM_DIR/aliases.zsh"

# --- default shell ----------------------------------------------------------
if [[ "${SHELL:-}" != *zsh ]]; then
  warn "Set zsh as your default shell with:  chsh -s \"$(command -v zsh)\""
fi

cat <<EOF

Done. Next:
  1. Restart your terminal (or: exec zsh).
  2. Set your terminal font to "MesloLGS NF" (kitty already uses a Nerd Font).
  3. In tmux, press  prefix + I  (Ctrl-a then Shift-i) to install tmux plugins.
  4. Personal PATH/exports go in ~/.zshrc.local (sourced automatically).
EOF
