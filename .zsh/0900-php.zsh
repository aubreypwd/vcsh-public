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

	echo "• Un-pinning any currently pinned versions of PHP..."

	# Unlink all versions of PHP.
	for VERSION in "${MY_PHP_VERSIONS[@]}"; do
		brew unpin "php@$VERSION" --quiet
	done

	CONF_FILES=( 'php.ini' 'xdebug-3.ini' ) # In ~/.config/php/conf.d/ that I want symlinked.

	# For each version...
	for VERSION in "${MY_PHP_VERSIONS[@]}"; do

		echo "• Installing php@$VERSION and modules..."

		# Install w/ xDebug...
		brew install "shivammathur/php/php@$VERSION" --quiet && \
			brew install "shivammathur/extensions/xdebug@$VERSION" --quiet

		echo "• Symlinking your ./config/php/conf.d/*.ini files..."

		# Add custom configs...
		for CONF_FILE in "${CONF_FILES[@]}"; do
			ln -sf "$HOME/.config/php/conf.d/$CONF_FILE" "/opt/homebrew/etc/php/$VERSION/conf.d/z-$CONF_FILE"
		done

		# Make sure it isn't linked, we'll link the preferred (my) version later.
		brew unlink "php@$VERSION" --quiet
	done

	brew cleanup --prune=all --quiet

	# Link and pin the final PHP version (my version).
	brew unlink php # Unlink whatever version might be linked.

	echo "• Linking and pinning php@$MY_PHP_VERSION..."

	# Link my preferred version of PHP.
	brew link "php@$MY_PHP_VERSION" --quiet
	brew pin "php@$MY_PHP_VERSION" --quiet

	echo "• Updating Valet..."

	# Install and setup Laravel Valet
	composer global require laravel/valet
	valet install --silent --quiet --no-interaction
}

for VERSION in "${MY_PHP_VERSIONS[@]}"; do
	alias "php@$VERSION"="$(brew --prefix php@$VERSION)/bin/php"
done
