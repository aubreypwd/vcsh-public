#!/bin/sh

 # shellcheck disable=SC3003
 
# My Prompt
# @since Apr 6, 2023
export NEWLINE=$'\n'
# export PS1="$NEWLINE$NEWLINE%F{%(?.green.red)}❯ %f" # w/out current directory.
export PS1="$NEWLINE$NEWLINE%F{%(?.green.red)}%f%~$NEWLINE%F{%(?.green.red)}❯ %f" # w/ current directory.

# Make sure that additonal info isn't shown on prompt.
# @since  Wednesday, June 29, 2022 (Moved to this file)
precmd() {
	setopt localoptions nopromptsubst
}
