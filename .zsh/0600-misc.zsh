#!/bin/bash

# Autocomplete
if [[ "$COMP_INIT" == "true" ]]; then
	autoload -Uz compinit && compinit
fi

# fzf
if [[ "$FZF_ZSH" == "true" ]]; then
	test -f "$HOME/.fzf.zsh" && \
		source "$HOME/.fzf.zsh"
fi

# iTerm2 Integration
if [[ "$ITERM2_INTEGRATION" == "true" ]]; then
	test -e "${HOME}/.iterm2_shell_integration.zsh" \
		&& source "${HOME}/.iterm2_shell_integration.zsh"
fi

# Show system info on ~ load.
# @since Unknown
# if [[ true ]]; then # Only when loaded $HOME...
# 	if test "$(pwd)" = "$HOME"; then
# 		sysinfo
# 	fi
# fi

# Show git status on CD.
if [[ "$SHOW_GIT_STATUS_ON_CD" == "true" ]]; then
	if [ -e "./.git" ]; then git s; fi
fi

# Automatically choose suggestion in zsh-autosuggestions using TAB.
if [[ "$AUTOSUGGEST_ZSH_TAB" == "true" ]]; then
	bindkey '^[[Z' autosuggest-accept
fi

# pyenv.
if [[ "$PYENV_INIT" == "true" ]]; then
	if command -v pyenv 1>/dev/null 2>&1; then
		eval "$(pyenv init --path)"
	fi
fi

###
 # Reset Misc
 #
 # @since Wednesday, June 29, 2022
 ##
reset-misc () {

	if [[ "$MAKE_SCREENSHOT_DIRS" == "true" ]]; then
		mkdir -p "$HOME/Pictures/Screenshots"
		mkdir -p "$HOME/Pictures/Screenshots/Autosaved" # Where we put CleanshotX.
	fi

	# Make sure keys and identities make it into keychain.
	if [[ "$APPLE_SSH_ADD_KEYCHAIN" == "true" ]]; ssh-add -q --apple-load-keychain -k

	if [[ $(pwd) != "$HOME" ]]; then
		return # Don't do the below unless we're loading the HOME folder.
	fi

	# Don't show last login message, e.g. you have mail, etc.
	if [[ "$HUSH_LOGIN" == "true" ]]; touch "$HOME/.hushlogin"

	###
	 # Hidden/Unhidden Files & Folders
	 #
	 # @TODO Make hide and show a zsh plugin so this is easier.
	 #
	 # @since Thursday, 10/1/2020
	 ##
	chflags nohidden "$HOME/Applications"
	chflags hidden "$HOME/Desktop"
	chflags hidden "$HOME/Documents"
	chflags hidden "$HOME/Public"
	chflags nohidden "$HOME/Library"
	# chflags hidden "$HOME/Applications (Parallels)"
}

###
 # Used to clone and link plugins below.
 #
 # @since Jan 16, 2023
 #
 # // TODO: (Aubrey) Delete this.
 ##
_clone-and-link-antigen-bundle () {

	if test ! -x "$(command -v ghq)"; then
		echo "_clone-and-link-antigen-bundle: Please install ghq, can't clone plugin $1."
	fi

	ghq get -s "ssh://git@github.com/$1" 2> /dev/null

	antigen bundle "$HOME/Repos/github.com/$1" --no-local-clone
}