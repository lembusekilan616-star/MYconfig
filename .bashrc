# ~/.bashrc - Config Bash minimalis & cantik dengan starship, eza, fzf, fd, bat, rg + VSCodium

# === Starship Prompt (wajib paling atas) ===
eval "$(starship init bash)"

# === Aliases pengganti command standar (lebih cantik & cepat) ===
alias ls='eza --icons=auto --group-directories-first'
alias ll='eza -l --icons=auto --group-directories-first --git'
alias la='eza -la --icons=auto --group-directories-first --git'
alias lt='eza -T --icons=auto --level=3'  # Tree 3 level biar ga terlalu dalam

alias cat='bat --style=plain --paging=never'  # Highlight tanpa header/footer
alias grep='rg'
alias find='fd'

# === FZF - Fuzzy finder yang simple & langsung buka di VSCodium ===

# Pastikan fzf terinstall dengan baik (di Arch biasanya sudah include key bindings)
# Source fzf key bindings & completion (jika ada)
[ -f /usr/share/fzf/key-bindings.bash ] && source /usr/share/fzf/key-bindings.bash
[ -f /usr/share/fzf/completion.bash ] && source /usr/share/fzf/completion.bash

# Ctrl-T: cari file dengan fd → preview dengan bat → enter langsung buka di codium
export FZF_CTRL_T_COMMAND="fd --type f --hidden --follow --exclude .git"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers {}' --height 60% --layout=reverse --border --bind 'enter:become(codium {})'"

# Ctrl-R: history search yang lebih bagus (default fzf sudah bagus di bash)
# Tidak perlu custom lagi, fzf sudah handle dengan baik setelah source key-bindings.bash

# Alt-C: fuzzy cd (ganti directory)
export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"
export FZF_ALT_C_OPTS="--preview 'eza -T --icons=auto --level=2 --color=always {}' --height 50% --layout=reverse --border"

# === Fungsi tambahan simple (opsional, tapi sangat berguna) ===

# ff - fuzzy find file lalu langsung buka di codium
ff() {
    local file
    file=$(fd --type f --hidden --exclude .git | fzf --preview 'bat --color=always {}' --height 60% --layout=reverse --border)
    [[ -n "$file" ]] && codium "$file"
}

# fcd - fuzzy change directory
fcd() {
    local dir
    dir=$(fd --type d --hidden --exclude .git | fzf --preview 'eza -T --icons=auto --level=2 {}' --height 50% --layout=reverse --border)
    [[ -n "$dir" ]] && cd "$dir"
}

# frg - fuzzy ripgrep lalu buka di codium pada baris yang tepat
frg() {
    local result
    result=$(rg --color=always --line-number --no-heading --smart-case "$@" | 
             fzf --ansi --preview 'bat --color=always {1} --highlight-line {2}' --preview-window 'up,60%,border-bottom' --height 70% --layout=reverse)
    if [[ -n "$result" ]]; then
        local file=$(echo "$result" | cut -d: -f1)
        local line=$(echo "$result" | cut -d: -f2)
        codium "$file" +"$line"
    fi
}

# === Environment untuk Wayland + Niri (biar app Qt/GTK jalan lancar) ===
export XDG_SESSION_TYPE=wayland
export QT_QPA_PLATFORM=wayland
export GDK_BACKEND=wayland
export MOZ_ENABLE_WAYLAND=1  # Bonus buat Firefox biar native Wayland
##FASTFETCH
fastfetch
# === Cleanup ===
# Tidak ada yang aneh-aneh, semua aman, tidak ada eval dari luar, tidak ada loop tak terbatas.

