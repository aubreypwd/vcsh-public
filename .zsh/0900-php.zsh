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

###
 # Setup PHP on my system.
 #
 # @since Dec 14, 2023
 ##
reset-php () {

	CONF_FILES=( 'php.ini' 'xdebug-3.ini' ) # In ~/.config/php/conf.d/ that I want symlinked.

	for VERSION in "${MY_PHP_VERSIONS[@]}"; do

		echo "Installing php@$VERSION..."

		brew reinstall "php@$VERSION"

		echo "Installing Xdebug for php@$VERSION..."

		pecl -d "php_suffix=$VERSION" install -f xdebug #> /dev/null 2>&1

		echo "Symlinking config files..."

		for CONF_FILE in "${CONF_FILES[@]}"; do

			SOURCE="$HOME/.config/php/conf.d/$CONF_FILE";
			TARGET="/opt/homebrew/etc/php/$VERSION/conf.d/z-$CONF_FILE"

			echo "Symlinking $SOURCE -> $TARGET..."

			ln -sf "$SOURCE" "$TARGET"
		done

		echo "Restarting php@$VERSION services..."

		brew services restart "php@$VERSION"
	done

	# valet restart

	echo "Setting your perferred version of PHP..."

	brew unlink php && brew link --force php@8.3
	brew pin php@8.3
}

for VERSION in "${MY_PHP_VERSIONS[@]}"; do
	alias "php@$VERSION"="$(brew --prefix php@$VERSION)/bin/php"
done