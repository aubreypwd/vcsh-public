#!/bin/bash

###
 # PHP Configuration, etc
 #
 # @since Dec 21, 2022
 ##

###
 # These are the versions of PHP I want installed and setup.
 #
 # @since Dec 14, 2023
 ##
MY_PHP_VERSIONS=(7.4 8.0 8.1 8.2 8.3 8.4)

# The PHP version I want to use by default (pinned).
MY_PHP_VERSION="8.3"

###
 # Setup PHP on my system.
 #
 # @since Dec 14, 2023
 ##
reset-php () {

	brew update
	brew tap shivammathur/php
	brew tap shivammathur/extensions

	CONF_FILES=( 'php.ini' 'xdebug-3.ini' ) # In ~/.config/php/conf.d/ that I want symlinked.

	# Fully uninstall old versions...
	for VERSION in "${MY_PHP_VERSIONS[@]}"; do

		# Un-pin just in case it is.
		brew unpin "php@$VERSION" > /dev/null 2>&1

		# Fully uninstall the version.
		brew uninstall --zap --ignore-dependencies "php@$VERSION"
		brew uninstall --zap --ignore-dependencies "shivammathur/php/php/php@$VERSION"

		brew cleanup --prune=all
	done

	# For each version...
	for VERSION in "${MY_PHP_VERSIONS[@]}"; do

		# Install a fresh install...
		brew install "shivammathur/php/php@$VERSION"
		brew install "shivammathur/extensions/xdebug@$VERSION"

		# Add custom configs...
		for CONF_FILE in "${CONF_FILES[@]}"; do
			ln -sf "$HOME/.config/php/conf.d/$CONF_FILE" "/opt/homebrew/etc/php/$VERSION/conf.d/z-$CONF_FILE"
		done

		# Make sure it isn't linked, we'll link the preferred (my) version later.
		brew unlink "php@$VERSION"

	done # Each version...

	brew cleanup --prune=all

	# Link and pin the final PHP version (my version).
	brew unlink php # Unlink whatever version might be linked.
	brew link "php@$MY_PHP_VERSION"
	brew pin "php@$MY_PHP_VERSION"
}

for VERSION in "${MY_PHP_VERSIONS[@]}"; do
	alias "php@$VERSION"="$(brew --prefix php@$VERSION)/bin/php"
done