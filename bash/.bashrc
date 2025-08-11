#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export EDITOR=nvim

alias ls='ls --color=auto'
alias la='ls -a'
alias ll='ls -l'
alias lla='la -l'
alias grep='rg --color=auto'

shopt -s autocd
shopt -s cdspell
shopt -s dirspell
shopt -s globstar

# install ruby gems to ~/gems
export GEM_HOME="$HOME/gems"
export PATH="$HOME/gems/bin:$PATH"

PS1='[\u@\h \W]\$ '
