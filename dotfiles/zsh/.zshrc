# ==========================================================
# Minimalist Zsh Config — Fedora KDE Optimized
# Fast, Clean, Developer-Friendly
# ==========================================================


# -----------------------------
# Core Zsh Behavior
# -----------------------------
setopt autocd
setopt histignorealldups
setopt sharehistory
setopt inc_append_history
setopt correct
setopt correct_all           # suggest corrections for arguments too
setopt globdots              # include dotfiles in glob patterns
setopt no_beep               # silence all bells
setopt interactive_comments  # allow # comments in interactive shell
setopt extended_history      # save timestamp + duration in history
setopt hist_reduce_blanks    # strip extra blanks from history entries
setopt hist_verify           # show !! expansion before executing
setopt auto_pushd            # cd pushes onto dir stack
setopt pushd_ignore_dups     # no duplicate dirs in stack
setopt pushd_silent          # don't print stack on every cd
setopt complete_in_word      # complete from both ends of a word
setopt always_to_end         # move cursor to end after completion
setopt long_list_jobs        # show PID in job listings
setopt notify                # report job status immediately

HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history


# -----------------------------
# Completion System
# -----------------------------
autoload -Uz compinit
# Only regenerate compinit dump once per day (faster shell startup)
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# Case-insensitive + partial word matching
zstyle ':completion:*' matcher-list \
  'm:{a-z}={A-Z}' \
  'm:{a-zA-Z}={A-Za-z}' \
  'r:|[._-]=* r:|=*' \
  'l:|=* r:|=*'

zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*' special-dirs true
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{8}no matches: %d%f'

# Typo correction in completion (1 char off)
zstyle ':completion:*' completer _extensions _complete _approximate
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Completion cache (speeds up dnf, git, etc.)
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path ~/.zsh/cache

autoload -Uz bashcompinit && bashcompinit


# -----------------------------
# Starship Prompt
# -----------------------------
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi


# -----------------------------
# PATH Improvements
# -----------------------------
export PATH="$HOME/.local/bin:$PATH"


# -----------------------------
# Environment
# -----------------------------
export EDITOR="nano"
export VISUAL="nano"
export LANG="en_US.UTF-8"

# bat as default pager — syntax-highlighted everywhere
if command -v bat >/dev/null 2>&1; then
  export PAGER="bat"
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"  # colorized man pages
fi

export LESS='-R --use-color'


# ============================================================
# MODERN CLI TOOL REPLACEMENTS
# Install all at once:
#   sudo dnf install eza bat fd-find ripgrep fzf zoxide git-delta btop xclip
# ============================================================


# -----------------------------
# eza → ls
# -----------------------------
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --icons --group-directories-first --color=always'
  alias ll='eza -lah --icons --git --group-directories-first'
  alias la='eza -a --icons --group-directories-first'
  alias l='eza -lh --icons --git'
  alias lt='eza --tree --level=2 --icons'        # tree depth 2
  alias ltt='eza --tree --level=3 --icons'       # tree depth 3
  alias ltg='eza --tree --level=2 --icons --git' # tree + git status
fi


# -----------------------------
# bat → cat
# -----------------------------
if command -v bat >/dev/null 2>&1; then
  alias cat='bat --paging=never'   # drop-in replacement, no pager
  alias catt='bat'                 # with paging for long files
  alias batp='bat --style=plain'   # plain, no decorations
fi


# -----------------------------
# ripgrep → grep
# -----------------------------
if command -v rg >/dev/null 2>&1; then
  alias grep='rg'
  export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
  # Suggested ~/.ripgreprc:
  # --hidden
  # --follow
  # --glob=!.git/*
  # --glob=!node_modules/*
fi


# -----------------------------
# fd → find
# -----------------------------
if command -v fd >/dev/null 2>&1; then
  alias find='fd'
  ff() { fd --hidden "$@"; }     # ff: search by name, includes hidden
else
  ff() { find . -iname "*$1*" 2>/dev/null; }
fi


# -----------------------------
# zoxide → cd
# -----------------------------
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
  alias cd='z'    # z learns your dirs; partial names work after first visit
  # zi = interactive fuzzy directory picker (needs fzf)
fi


# -----------------------------
# btop → top
# -----------------------------
if command -v btop >/dev/null 2>&1; then
  alias top='btop'
  alias htop='btop'
fi


# -----------------------------
# dust → du
# -----------------------------
if command -v dust >/dev/null 2>&1; then
  alias du='dust'
  alias ducks='dust -n 20'
else
  alias ducks='du -csh * | sort -rh | head -20'
fi


# -----------------------------
# delta → git diff
# -----------------------------
# Run once to wire delta into all git operations:
#   git config --global core.pager delta
#   git config --global interactive.diffFilter "delta --color-only"
#   git config --global delta.navigate true
#   git config --global delta.side-by-side true
#   git config --global delta.line-numbers true


# -----------------------------
# FZF Integration
# -----------------------------
if command -v fzf >/dev/null 2>&1; then

  # Use fd as fzf's file source (faster, .gitignore-aware)
  if command -v fd >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
  fi

  # Smart preview: bat for files, eza for dirs
  _fzf_file_preview='if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi'

  export FZF_CTRL_T_OPTS="--preview '$_fzf_file_preview' --bind 'ctrl-/:toggle-preview'"
  export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200' --bind 'ctrl-/:toggle-preview'"
  export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window=down:3:wrap --bind 'ctrl-/:toggle-preview'"

  export FZF_DEFAULT_OPTS="
    --height=40%
    --layout=reverse
    --border=rounded
    --info=inline
    --bind='ctrl-d:half-page-down'
    --bind='ctrl-u:half-page-up'
    --bind='ctrl-a:select-all'
    --bind='ctrl-y:execute-silent(echo {+} | xclip -selection clipboard)'
  "

  # Context-aware preview per command
  _fzf_comprun() {
    local command=$1
    shift
    case "$command" in
      cd)           fzf --preview 'eza --tree --color=always {} | head -200'   "$@" ;;
      export|unset) fzf --preview "eval 'echo \${}'"                           "$@" ;;
      ssh)          fzf --preview 'dig {}'                                     "$@" ;;
      bat|cat)      fzf --preview 'bat -n --color=always --line-range :500 {}' "$@" ;;
      *)            fzf --preview "$_fzf_file_preview"                         "$@" ;;
    esac
  }

  # fd-powered tab completion inside fzf
  _fzf_compgen_path() { fd --hidden --follow --exclude .git . "$1"; }
  _fzf_compgen_dir()  { fd --type d --hidden --follow --exclude .git . "$1"; }

  # Load fzf keybinds (Ctrl+R, Ctrl+T, Alt+C)
  [ -f /usr/share/fzf/shell/key-bindings.zsh ] && \
    source /usr/share/fzf/shell/key-bindings.zsh

  [ -f /usr/share/fzf/shell/completion.zsh ] && \
    source /usr/share/fzf/shell/completion.zsh

fi


# -----------------------------
# Plugins
# -----------------------------
[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] && \
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && \
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


# -----------------------------
# Fedora Package Aliases
# -----------------------------
alias update='sudo dnf upgrade --refresh'
alias install='sudo dnf install'
alias remove='sudo dnf remove'
alias searchpkg='dnf search'
alias infopkg='dnf info'             # show package details
alias listpkg='dnf list installed'   # list all installed packages
alias cleanpkg='sudo dnf autoremove && sudo dnf clean all'
alias repolist='dnf repolist'        # show enabled repos


# -----------------------------
# Navigation Shortcuts
# -----------------------------
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'          # go back to previous directory

alias home='cd ~'
alias docs='cd ~/Documents'
alias downloads='cd ~/Downloads'

# Directory stack
alias d='dirs -v | head -20'


# -----------------------------
# Git Shortcuts
# -----------------------------
alias g='git'
alias gs='git status'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gcm='git commit -m'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gds='git diff --staged'                       # diff of staged changes
alias gco='git checkout'
alias gb='git branch'
alias gba='git branch --all'
alias glog='git log --oneline --graph --decorate --all'  # pretty log tree
alias gst='git stash'
alias gstp='git stash pop'


# -----------------------------
# Utility Aliases
# -----------------------------
alias mkdir='mkdir -pv'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'
alias ln='ln -iv'

alias ports='ss -tulnp'
alias sysinfo='fastfetch'
alias c='clear'
alias cls='clear'
alias reload='source ~/.zshrc && echo "zshrc reloaded"'
alias zshconfig='${EDITOR:-nano} ~/.zshrc'

alias df='df -h'
alias free='free -h'
alias path='echo $PATH | tr ":" "\n"'    # PATH entries one per line
alias dmesg='dmesg -H'
alias serve='python3 -m http.server 8080'
alias jlogf='journalctl -f'


# -----------------------------
# Key Bindings
# -----------------------------
bindkey '^[[A' history-search-backward   # Up arrow
bindkey '^[[B' history-search-forward    # Down arrow
bindkey '^[[H' beginning-of-line         # Home
bindkey '^[[F' end-of-line               # End
bindkey '^[[3~' delete-char              # Delete
bindkey '^[[1;5C' forward-word           # Ctrl+Right — skip word
bindkey '^[[1;5D' backward-word          # Ctrl+Left  — skip word
bindkey '^U' backward-kill-line          # Ctrl+U — delete to line start
bindkey '^K' kill-line                   # Ctrl+K — delete to line end
bindkey '^W' backward-kill-word          # Ctrl+W — delete previous word
bindkey '^Z' fancy-ctrl-z                # Ctrl+Z — toggle fg/bg

# Ctrl+Z: resume suspended job if buffer empty, otherwise push input
fancy-ctrl-z() {
  if [[ $#BUFFER -eq 0 ]]; then
    fg 2>/dev/null
    zle redisplay
  else
    zle push-input
  fi
}
zle -N fancy-ctrl-z

# Ctrl+E: edit current command line in $EDITOR
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^E' edit-command-line


# -----------------------------
# Functions
# -----------------------------

# mkdir + cd in one step
mkcd() { mkdir -p "$1" && cd "$1"; }

# cd and immediately list contents
cl() { cd "$1" && ls; }

# Timestamped file backup
backup() {
  if [[ -z "$1" ]]; then echo "Usage: backup <file>"; return 1; fi
  cp -v "$1" "${1}.bak.$(date +%Y%m%d_%H%M%S)"
}

# Universal archive extractor
extract() {
  if [[ -z "$1" ]]; then echo "Usage: extract <archive>"; return 1; fi
  if [[ ! -f "$1" ]]; then echo "extract: '$1' is not a valid file"; return 1; fi
  case "$1" in
    *.tar.bz2)  tar xjf "$1"        ;;
    *.tar.gz)   tar xzf "$1"        ;;
    *.tar.xz)   tar xJf "$1"        ;;
    *.tar.zst)  tar --zstd -xf "$1" ;;
    *.tar)      tar xf  "$1"        ;;
    *.bz2)      bunzip2 "$1"        ;;
    *.gz)       gunzip  "$1"        ;;
    *.xz)       unxz    "$1"        ;;
    *.zip)      unzip   "$1"        ;;
    *.zst)      zstd -d "$1"        ;;
    *.7z)       7z x    "$1"        ;;
    *.rar)      unrar x "$1"        ;;
    *)          echo "extract: '$1' — unknown format" ;;
  esac
}

# Find process by name
psg() { ps aux | \grep -v grep | \grep -i "$1"; }

# Fuzzy search file CONTENTS: ripgrep + fzf + bat preview
# Usage: rgs <pattern>
rgs() {
  if ! command -v rg >/dev/null || ! command -v fzf >/dev/null; then
    echo "rgs: requires rg and fzf — sudo dnf install ripgrep fzf"; return 1
  fi
  rg --color=always --line-number --no-heading "$@" \
    | fzf --ansi \
          --delimiter=: \
          --preview 'bat --color=always --line-range {2}: {1}' \
          --preview-window 'right:60%:wrap'
}

# Fuzzy git log browser — delta preview if available
fshow() {
  if ! command -v fzf >/dev/null; then
    echo "fshow: fzf not found — sudo dnf install fzf"; return 1
  fi
  local preview_cmd
  if command -v delta >/dev/null; then
    preview_cmd='git show --color=always {1} | delta --color-only'
  else
    preview_cmd='git show --stat --color=always {1}'
  fi
  git log --oneline --color=always | \
    fzf --ansi \
        --preview "$preview_cmd" \
        --bind 'enter:execute(git show --color=always {1} | less -R)' \
        --bind 'ctrl-/:toggle-preview'
}

# Quick note: note "text" to save, note to read
note() {
  if [[ -z "$1" ]]; then
    \cat ~/notes.txt 2>/dev/null || echo "(no notes yet)"
  else
    echo "[$(date '+%Y-%m-%d %H:%M')] $*" >> ~/notes.txt
    echo "Note saved."
  fi
}

# Quick system snapshot (bypasses aliases with \)
syssnap() {
  echo "── Host ─────────────────────────────────"
  echo "  Hostname : $(hostname)"
  echo "  Kernel   : $(uname -r)"
  echo "  Uptime   : $(uptime -p)"
  echo "── CPU ──────────────────────────────────"
  \grep -m1 'model name' /proc/cpuinfo | sed 's/model name\s*: /  Model    : /'
  echo "  Load     : $(cut -d' ' -f1-3 /proc/loadavg)"
  echo "── Memory ───────────────────────────────"
  \free -h | awk '/^Mem/ {printf "  Used     : %s / %s\n", $3, $2}'
  echo "── Disk (/) ─────────────────────────────"
  \df -h / | awk 'NR==2 {printf "  Used     : %s / %s (%s)\n", $3, $2, $5}'
  echo "─────────────────────────────────────────"
}


# -----------------------------
# End of Config
# -----------------------------
fastfetch

