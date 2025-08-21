
#!/usr/bin/env bash
# ~/.bashrc - sensible defaults for students and instructors
# Simple, easy-to-read, and safe for classroom VMs.

# Avoid duplicate entries when sourcing
[[ -n "${BASH_STARTED:-}" ]] && return || BASH_STARTED=1

# History settings
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoredups:erasedups
shopt -s histappend

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

# Enable colorized ls if possible
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

#### Prompt configuration (colors, git branch, root indicator)
# Environment variables (optional):
#  DOTFILES_PS_USER_COLOR   - color sequence for the username (tput setaf N or ANSI escape)
#  DOTFILES_PS_HOST_COLOR   - color sequence for the hostname
#  DOTFILES_PS_CWD_COLOR    - color sequence for the working directory
#  DOTFILES_PS_GIT_COLOR    - color sequence for the git branch indicator
#  DOTFILES_PS_ROOT_COLOR   - color sequence for the prompt symbol when root
# These may be set by instructors or students before sourcing the file.

# If terminal supports tput, provide sensible defaults.
if command -v tput >/dev/null 2>&1 && [ "$(tput colors)" -ge 8 ]; then
	: "${DOTFILES_PS_USER_COLOR:=$(tput setaf 2)}"   # green
	: "${DOTFILES_PS_HOST_COLOR:=$(tput setaf 6)}"   # cyan
	: "${DOTFILES_PS_CWD_COLOR:=$(tput setaf 4)}"    # blue
	: "${DOTFILES_PS_GIT_COLOR:=$(tput setaf 3)}"    # yellow
	: "${DOTFILES_PS_ROOT_COLOR:=$(tput setaf 1)}"   # red
	RESET_SEQ="$(tput sgr0)"
else
	DOTFILES_PS_USER_COLOR=""
	DOTFILES_PS_HOST_COLOR=""
	DOTFILES_PS_CWD_COLOR=""
	DOTFILES_PS_GIT_COLOR=""
	DOTFILES_PS_ROOT_COLOR=""
	RESET_SEQ=""
fi


# Helper: non-printing sequence wrappers for PS1
_esc() { printf '%s' "\[${1}\]"; }
USER_COLOR_ESC=$(_esc "$DOTFILES_PS_USER_COLOR")
HOST_COLOR_ESC=$(_esc "$DOTFILES_PS_HOST_COLOR")
CWD_COLOR_ESC=$(_esc "$DOTFILES_PS_CWD_COLOR")
GIT_COLOR_ESC=$(_esc "$DOTFILES_PS_GIT_COLOR")
ROOT_COLOR_ESC=$(_esc "$DOTFILES_PS_ROOT_COLOR")
RESET_ESC=$(_esc "$RESET_SEQ")

# Lightweight git branch helper (only runs when in a git repo)
git_branch() {
	if command -v git >/dev/null 2>&1 && git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
		local branch
		branch=$(git symbolic-ref --quiet --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
		[ -n "$branch" ] && printf '%s' "$branch"
	fi
}

# Git dirty indicator - '*' if changes exist
git_dirty() {
	if command -v git >/dev/null 2>&1 && git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
		if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
			printf '*'
		fi
	fi
}

# Prompt symbol and its color (root vs normal user)
if [ "${EUID:-$(id -u)}" -eq 0 ]; then
	PROMPT_SYMBOL="#"
	PROMPT_SYMBOL_ESC=$ROOT_COLOR_ESC
else
	PROMPT_SYMBOL="\$"
	PROMPT_SYMBOL_ESC=$USER_COLOR_ESC
fi

# Prompt style: short (default) or verbose. Can be set with DOTFILES_PROMPT_STYLE env var.
: ${DOTFILES_PROMPT_STYLE:=short}

# Preset color themes: 'school', 'night', 'high-contrast'
dotfiles_prompt_preset() {
	case "$1" in
		school)
			# green user, cyan host, blue cwd, yellow git, red root
			DOTFILES_PS_USER_COLOR="$(tput setaf 2)"
			DOTFILES_PS_HOST_COLOR="$(tput setaf 6)"
			DOTFILES_PS_CWD_COLOR="$(tput setaf 4)"
			DOTFILES_PS_GIT_COLOR="$(tput setaf 3)"
			DOTFILES_PS_ROOT_COLOR="$(tput setaf 1)"
			;;
		night)
			# magenta user, blue host, cyan cwd, bright yellow git, red root
			DOTFILES_PS_USER_COLOR="$(tput setaf 5)"
			DOTFILES_PS_HOST_COLOR="$(tput setaf 4)"
			DOTFILES_PS_CWD_COLOR="$(tput setaf 6)"
			DOTFILES_PS_GIT_COLOR="$(tput setaf 11 2>/dev/null || tput setaf 3)"
			DOTFILES_PS_ROOT_COLOR="$(tput setaf 1)"
			;;
		high-contrast)
			# bright white user, bright blue host, bright cyan cwd, bright magenta git, bright red root
			DOTFILES_PS_USER_COLOR="$(tput setaf 15 2>/dev/null || $(tput setaf 7))"
			DOTFILES_PS_HOST_COLOR="$(tput setaf 12 2>/dev/null || $(tput setaf 4))"
			DOTFILES_PS_CWD_COLOR="$(tput setaf 14 2>/dev/null || $(tput setaf 6))"
			DOTFILES_PS_GIT_COLOR="$(tput setaf 13 2>/dev/null || $(tput setaf 5))"
			DOTFILES_PS_ROOT_COLOR="$(tput setaf 9 2>/dev/null || $(tput setaf 1))"
			;;
		*)
			echo "Usage: dotfiles_prompt_preset <school|night|high-contrast>" >&2
			return 2
			;;
	esac
	# rebuild escape sequences
	USER_COLOR_ESC=$(_esc "$DOTFILES_PS_USER_COLOR")
	HOST_COLOR_ESC=$(_esc "$DOTFILES_PS_HOST_COLOR")
	CWD_COLOR_ESC=$(_esc "$DOTFILES_PS_CWD_COLOR")
	GIT_COLOR_ESC=$(_esc "$DOTFILES_PS_GIT_COLOR")
	ROOT_COLOR_ESC=$(_esc "$DOTFILES_PS_ROOT_COLOR")
	RESET_ESC=$(_esc "$RESET_SEQ")
	build_ps1
}

# Build PS1 according to DOTFILES_PROMPT_STYLE
build_ps1() {
	case "$DOTFILES_PROMPT_STYLE" in
		short)
			# short: user:cwd$ (colored cwd)
			PS1="${USER_COLOR_ESC}\u${RESET_ESC}:${CWD_COLOR_ESC}\w${RESET_ESC} ${PROMPT_SYMBOL_ESC}${PROMPT_SYMBOL}${RESET_ESC} "
			;;
		verbose)
			# verbose: user@host:cwd (branch[*]) symbol
			PS1="${USER_COLOR_ESC}\u${RESET_ESC}@${HOST_COLOR_ESC}\h${RESET_ESC}:${CWD_COLOR_ESC}\w${RESET_ESC} ${GIT_COLOR_ESC}$(git_branch)$(git_dirty)${RESET_ESC} ${PROMPT_SYMBOL_ESC}${PROMPT_SYMBOL}${RESET_ESC} "
			;;
		*)
			# fallback to short
			PS1="${USER_COLOR_ESC}\u${RESET_ESC}:${CWD_COLOR_ESC}\w${RESET_ESC} ${PROMPT_SYMBOL_ESC}${PROMPT_SYMBOL}${RESET_ESC} "
			;;
	esac
}

# Convenience functions to switch styles at runtime
prompt_short() { export DOTFILES_PROMPT_STYLE=short; build_ps1; }
prompt_verbose() { export DOTFILES_PROMPT_STYLE=verbose; build_ps1; }

# Initialize PS1
build_ps1

# End of .bashrc
