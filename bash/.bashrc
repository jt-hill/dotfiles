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

PS1='[\u@\h \W]\$ '
