#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

if [ ! -f /tmp/devices_initialized ]; then
    # Devices
    
    # End Devices
    touch /tmp/devices_initialized
fi

# Variables

$HOME/Temporary/firstload.sh