# ~/.bashrc - sensible defaults for students and instructors
# Simple, easy-to-read, and safe for classroom VMs.

# Avoid duplicate entries when sourcing
[[ -n "$BASH_STARTED" ]] && return || BASH_STARTED=1

# History settings
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoredups:erasedups
shopt -s histappend

# Prompt: small and clear
PS1='\u@\h:\w\$ '

# Path additions (do not overwrite existing PATH)
if [ -d "$HOME/.local/bin" ] && [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
	PATH="$HOME/.local/bin:$PATH"
fi

# Load user aliases and helpers if present
if [ -f "$HOME/.bash_aliases" ]; then
	# shellcheck source=/dev/null
	. "$HOME/.bash_aliases"
fi

# Helpful default umask for multi-user VMs
umask 0022

# Enable color if possible
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias ls='ls --color=auto'
fi

# Safe defaults for editors
: ${EDITOR:=vim}
: ${VISUAL:=$EDITOR}

# Load .profile if interactive login behavior is desired
if [ -f "$HOME/.profile" ]; then
	. "$HOME/.profile"
fi

# Enable bash completion if available (helps tab completion in Ubuntu VMs)
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
	# shellcheck source=/dev/null
	. /etc/bash_completion
fi
# Export commonly useful env vars for class tools
export EXAMPLE_DOTFILES="homeroot/dotfiles"

# End of .bashrc
