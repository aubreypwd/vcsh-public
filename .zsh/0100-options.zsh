#!/bin/bash

###
 # My Options
 #
 # @since Tuesday, April 19, 2022
 #
 # shellcheck disable=SC2155
 ##

export DOTFILES_FILE_LIST="$HOME/.Dotfiles.list" # Where you list all your dotfiles at.
#export DOTFILES_ZIP_ARCHIVE="$HOME/iCloud/dotfiles.bak.zip" # Path to a ZIP archive where we can backup your dotfiles.
export DOTFILES_BAK_DIR="$HOME/iCloud/Dotfiles" # Path to a ZIP archive where we can backup your dotfiles.
export DOTFILES_SYMLINK_DIR="$HOME/Dotfiles" # A location where we can create symlinked versions of all your dotfiles for easy management.

unsetopt INC_APPEND_HISTORY # Append history to new shells.
unsetopt SHARE_HISTORY

unset NODE_ENV # This causes things like vite to fail, etc.

setopt MONITOR
setopt POSIX_JOBS
setopt LONG_LIST_JOBS

export HOMEBREW_NO_ENV_HINTS=1 # Don't show hints.
export HOMEBREW_PREFIX=$(brew --prefix)
#export NODE_OPTIONS=--openssl-legacy-provider
export GPG_TTY=$(tty) # GPG Suite.

# Editors.
# @since Thursday, 5/13/2021

# Terminal editor.
if [[ "$TERM_PROGRAM" == 'vscode' ]]; then
	export EDITOR='code'
else
	export EDITOR='micro'
fi

export VISUAL="subl" # Visual Editor.

# export PAGER="highlight --out-format ansi --syntax=html --force --no-trailing-nl" # I can scroll and highlist
export PAGER="cat" # Just use cat for now.
export HOMEBREW_BUNDLE_FILE="$HOME/.Brewfile" # brew nundle nob.
export HOMEBREW_BUNDLE_NO_LOCK=true; # Don't make a lock file.

###
 # aubreypwd/zsh-plugin-require Options.
 #
 # @since Apr 7, 2023
 ##
export REQUIRE_AUTO_INSTALL="off"

###
 # Misc Nobs
 #
 # @since Friday, 10/2/2020
 ##
export COMPOSER_PROCESS_TIMEOUT=3600 # Fail after x seconds.
export LESS="-F -X -R $LESS" # Don't pager on less.
export MANPAGER='ul | cat -s' # Don't use less.

# Python
export PYTHON='/opt/homebrew/bin/python3'

# Fix wordpress-develop
export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
export PUPPETEER_EXECUTABLE_PATH="$(which chromium)"

# zsh-autosuggestions strategy.
export ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd history completion)

# Internal options.
export APPLE_SSH_ADD_KEYCHAIN=true
export AUTOSUGGEST_ZSH_TAB=true
export COMP_INIT=true
export DISSALOW_VSCODE_TERMINAL_EXIT=false
export FZF_ZSH=true
export HUSH_LOGIN=true
export ITERM2_INTEGRATION=true
export MAKE_SCREENSHOT_DIRS=true
export PYENV_INIT=true
export SHOW_GIT_STATUS_ON_CD=true

# Walk CLI
export WALK_REMOVE_CMD=trash

# k6 Options
export K6_SUMMARY_MODE=full

# When using Quick Command, do not use color.
if [ "$ITERM_PROFILE" = "Quick Command" ]; then
	unset CLICOLOR
	unset LSCOLORS
	export NO_COLOR=1
fi
