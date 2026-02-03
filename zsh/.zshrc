# https://github.com/zsh-users/zsh-autosuggestions
# https://github.com/zsh-users/zsh-syntax-highlighting

# --- Personal Customizations ---
# If not running interactively, don't do anything
# [[ $- != *i* ]] && return

export EDITOR=nvim
export SUDO_EDITOR=nvim
export PATH="$HOME/.local/bin:$PATH"

alias ls='ls --color=auto'
alias la='ls -a'
alias ll='ls -l'
alias lla='la -l'
alias grep='rg --color=auto'
alias dots='cd ~/.dotfiles'
alias ds='source ~/.local/share/venvs/datascience/bin/activate'

# install ruby gems to ~/gems
export GEM_HOME="$HOME/gems"
export PATH="$HOME/gems/bin:$PATH"

source ~/.config/shell/nvim-aliases
# --- History ---
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY          # share across sessions
setopt HIST_IGNORE_ALL_DUPS   # no duplicates
setopt HIST_REDUCE_BLANKS     # trim whitespace
setopt INC_APPEND_HISTORY     # write immediately

# --- Completion ---
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select                 # arrow-key menu
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # case-insensitive

# --- Plugins (fish-like behavior) ---
PLUGIN_DIR="${ZDOTDIR:-$HOME}/.zsh/plugins"
[[ -f "$PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && \
    source "$PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh"
[[ -f "$PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && \
    source "$PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# --- Autosuggestions config ---
ZSH_AUTOSUGGEST_STRATEGY=(history completion)  # try history first, then completion
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'         # gray suggestions (adjust if hard to see)
bindkey '^[[C' forward-char                     # right arrow accepts suggestion (fish-style)
bindkey '^F' forward-word                       # ctrl+f accepts next word

# --- Better history search (ctrl+r) ---
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^[[A" history-beginning-search-backward-end  # up arrow
bindkey "^[[B" history-beginning-search-forward-end   # down arrow

# --- Directory navigation ---
setopt AUTO_CD           # type dirname to cd
setopt AUTO_PUSHD        # cd pushes to stack
setopt PUSHD_IGNORE_DUPS # no duplicates in stack
alias ..='cd ..'
alias ...='cd ../..'

# --- Prompt (simple, fast) ---
setopt PROMPT_SUBST
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats ' %F{cyan}(%b)%f'
PROMPT='%F{blue}%~%f${vcs_info_msg_0_} %# '

# --- Optional: z for directory jumping ---
# Uncomment if you install zoxide: eval "$(zoxide init zsh)"
