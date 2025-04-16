#!/bin/sh

###
 # My Requirements
 #
 # @since Unknown
 #
 # shellcheck disable=SC2120
 ##

###
 # Require a command (and install if missing).
 #
 # E.g: require "git" "brew reinstall git"
 #
 #     This will simply run the command as the 2nd option.
 #
 # E.g: require "git" "brew reinstall git" "brew"
 #
 #     This will only run the command if a package manager as the 3rd option is present, e.g. `brew`.
 #
 # @since Sun June 9th 2019
 # @since 1.0.0
 ##
require () {

	CMD="$1"
	INSTALL="$2"
	MANAGER="$3"

	if [ -n "$MANAGER" ] && ! [ -x "$(command -v "$MANAGER")" ]; then

		echo "Required package manager command '$MANAGER' not found, please install missing command '$CMD' so we can automatically handle dependancies."

		return 1
	fi

	if alias "$CMD" >/dev/null 2>&1; then

		# The required command is an alias, we'll just have to trust them.
		return 0
	fi

	if ! [ -x "$(command -v "$CMD")" ]; then

		# Add export REQUIRE_AUTO_INSTALL="off" to .zshrc to stop auto installation.
		if [ "off" = "$REQUIRE_AUTO_INSTALL" ]; then

			echo "Could not find '$CMD' command and it is required, some functionality may not work until you install it."

			return 1
		fi

		echo "Could not find '$CMD' command, installing using: $INSTALL..."
		eval "${INSTALL}"
	fi

	return 0
}

###
 # Check requirements.
 #
 # @param string $1 Set to `--install` to install the requirements.
 #
 # @since Apr 7, 2023
 ##
requirements () {

	# Remember what I had it set to first.
	DEFAULT="$REQUIRE_AUTO_INSTALL"

	if [ '--install' = "$1" ]; then
		export REQUIRE_AUTO_INSTALL="on"
	else
		export REQUIRE_AUTO_INSTALL="off"
	fi

	###
	 # Install homebrew itself.
	 #
	 # You probably have this installed aready though.
	 #
	 # E.g: brew
	 #
	 # @since Friday, 10/2/2020
	 # @see   https://brew.sh
	 ##
	require "brew" "/bin/bash -c $(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

	###
	 # Required packages, and how to install them.
	 #
	 # @since Friday, 10/2/2020
	 ##
	require "cmatrix" "brew reinstall cmatrix" "brew" # Easy matrix screensave.
	require "composer" "brew reinstall composer" "brew" # Composer, @see https://composer.org
	require "duti" "brew reinstall duti" "brew" # Used to keep file associations.
	require "eza" "brew reinstall eza" "brew" # Eza makes ls even more awesome (exa fork).
	require "ffmpeg" "brew reinstall ffmpeg" "brew"
	require "fzf" "brew reinstall fzf" "brew"
	require "ghq" "brew reinstall ghq" "brew" # required by git get alias.
	require "git" "brew reinstall git" "brew"
	require "highlight" "brew reinstall highlight" "brew" # Highlighting cat
	require "http" "brew install httpie" "brew" # Better than curl, replaces curl.
	require "m" "brew install m-cli" "brew" # Love m-cli!
	require "mycli" "brew reinstall mycli" "brew" # Better than mysql
	require "n" "brew reinstall n" "brew" # nvm
	require "npm" "brew reinstall node" "brew" # Also installs node.
	require "python" "brew reinstall python" "brew" # Installs pip3 and easy_install
	require "ruby" "brew reinstall ruby" "brew" # Installs gems
	require "svn" "brew reinstall subversion" "brew"
	require "terminal-notifier" "brew reinstall terminal-notifier" "brew" # Terminal notifications
	require "ttab" "npm install ttab -g" "npm" # Used to open new windows in iTerm, etc.
	require "vcsh" "brew reinstall vcsh" "brew"
	require "watch" "brew reinstall watch" "brew"
	require "watchexec" "brew reinstall watchexec" "brew"
	require "wget" "brew reinstall wget" "brew"
	require "wp" "brew reinstall wp-cli" "brew"
	require "mc" "brew reinstall mc" "brew"
	require "duti" "brew reinstall duti" "brew" # Used for file extension association.
	require "pinentry-mac" "brew reinstall pinentry-mac" "brew" # Used for GPG signing.
	require "walk" "brew reinstall walk" "brew" # Used to cd into folders, etc.
	require "terminal-notifier" "brew reinstall terminal-notifier" "brew" # Used for notifications.
	require "7z" "brew reinstall p7zip" "brew" # Used to compress things better.
	require "trash" "brew reinstall trash-cli" "brew" # Move to trash instead of rm -Rf.

	# Reset REQUIRE_AUTO_INSTALL.
	export REQUIRE_AUTO_INSTALL="$DEFAULT"
}

###
 # Required Commands
 #
 # - Note, if antigen above hasn't installed yet, a reload will install require and install the below.
 #
 # @see   https://github.com/aubreypwd/zsh-plugin-require Uses this bundle to run require function/command.
 # @since Friday, 10/2/2020                               The initial ones.
 # @since Tuesday, April 19, 2022.                        Moved to own plugin.
 ##
if [ ! "$( command -v require )" ]; then

	echo "Could not find the 'require' function."
	echo "  Please install: https://github.com/aubreypwd/zsh-plugin-require"
else

	requirements

	if [ ! "$( command -v php )" ]; then
		echo "Please install php, for some reason it's not installed."
	fi
fi