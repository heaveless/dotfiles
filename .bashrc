
#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

source ~/.config/terminal/main

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

[[ -s "/home/dev/.gvm/scripts/gvm" ]] && source "/home/dev/.gvm/scripts/gvm"
