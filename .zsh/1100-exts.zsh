#!/bin/bash

###
 # Assigns source and text file extensions to Sublime Text.
 #
 # @since Jul 14, 2023
 # @since Jun 12, 2024 Previously disabled while using OpenIn.
 # @since August 28th 2025 Updated for sublime.
 # @since October 11, 2026 Target Sublime Text instead of VS Code.
 ##
reset-exts () {

	# How to figure out the name of an app:
	#    osascript -e 'id of app "Finder"'

	# # Built-in Terminal
	# duti -s com.apple.Terminal .sh all
	# duti -s com.apple.Terminal .zsh all

	# Set all opening roles so Finder also uses Sublime Text by default.
	for ext in aspx bash c cfg class conf cpp cs css dart env go h hpp ini jar java js json log lua m markdown md mm php pl pm py pyw rb rs scss sh sql svelte swift toml ts tsx txt vb vue xml yaml yml zsh; do
		duti -s "$(osascript -e 'id of app "Sublime Text"')" "$ext" all;
	done
}
