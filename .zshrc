#!/bin/sh

# shellcheck disable=SC3051
# shellcheck disable=SC1094
# shellcheck disable=SC1090

###
 # .zshrc
 #
 # @since Unknown       The beginning of time.
 # @since Unknown       Large update, most things are ZSH plugins now.
 # @since (Jan 16, 2023) Moved a ton of configurations to aubreypwd/zsh-plugin-my-config
 #
 # shellcheck disable=SC3030
 # shellcheck disable=SC3046
 ##

export N_PREFIX="$HOME/.n"

###
 # PATH
 #
 # See my-path.php in zsh-my-config for more.
 ##
export PATH="$N_PREFIX/bin:$PATH"
export PATH="$PATH:/opt/homebrew/bin:/opt/homebrew/sbin" # Homebrew
export PATH="$PATH:$HOME/.composer/vendor/bin" # Composer
export PATH="/opt/homebrew/opt/ruby/bin:$PATH" #  Ruby
export PATH="/opt/homebrew/opt/openssl@3/bin:$PATH" # Open SSL
export PATH="/opt/homebrew/lib/ruby/gems/3.0.0/bin:$PATH" # Ruby Gems
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH" # OpenJDK.
export PATH="/Applications/UTM.app/Contents/MacOS/:$PATH" # UTM
export PATH="/Applications/Sublime Text.app/Contents/SharedSupport/bin:$PATH" # subl
export PATH="/usr/local/mysql/bin:$PATH" # mysql installed via oracle's website.
export PATH="/Users/aubreypwd/.n/bin/:$PATH" # n node version (leave at the end).

###
 # High Level Options
 #
 # @since Tuesday, April 19, 2022
 ##
export ZSH="$HOME/.oh-my-zsh" # Path to your oh-my-zsh installation.

###
 # Load ZSH
 #
 # @since   Tuesday, September 7, 2021
 ##
if test -e "$ZSH"; then

	###
	 # ZSH & oh-my-zsh Specific Configs
	 #
	 # E.g:
	 #
	 # @since Thursday, 10/1/2020
	 ##
	export UPDATE_ZSH_DAYS=90

	###
	 # Theme
	 #
	 # - Must be done before you shource oh-my-zsh.
	 #
	 # @since Monday, 9/21/2020    frisk
	 # @since 10/1/20              ys
	 # @since Wednesday, 10/7/2020 Switched to refined for more simplicity.
	 # @since Apr 6, 2023          Turned off for custom PS1 Prompt.
	 ##
	# export ZSH_THEME="refined"

	# Built-in plugins.
	export PLUGINS=()

	# Load Oh My ZSH...
	source "$ZSH/oh-my-zsh.sh"

	###
	 # Antigen Plugins
	 #
	 # I use Antigen to source my various zsh functions and aliases, etc.
	 #
	 # - Think of "bundle" as "plugin".
	 # - E.g. `Tarrasch/zsh-bd` should clone from Github by default
	 # - Cloning using ssh URL ensures the resutling clone is contributable upstream with 2FA
	 #
	 # @see   $HOME/.antigen/bundle                 Where the repos are cloned and sourced from.
	 # @see   https://github.com/zsh-users/antigen  Antigen download and info.
	 #
	 # @since Monday, 9/21/2020
	 ##
	if [ ! -f "/opt/homebrew/share/antigen/antigen.zsh" ]; then

		echo "Please install antigen and reload to install ZSH plugins:"
		echo "  Homebrew: brew reinstall antigen"
	else

		# Get antigen ready.
		source /opt/homebrew/share/antigen/antigen.zsh # brew install antigen

		# omz
		antigen use oh-my-zshu

		# Other Plugins
		antigen bundle git-extras
		antigen bundle history-substring-search
		antigen bundle osx
		antigen bundle zsh-users/zsh-syntax-highlighting
		antigen bundle zsh-users/zsh-autosuggestions
		antigen cache-gen
		antigen apply
		antigen cleanup --force 2>&1 /dev/null

		# Load ~/.zsh/*.zsh...
		find "$HOME/.zsh" -maxdepth 1 -name "*.zsh" | sort | while IFS= read -r FILE; do
			source "$FILE"
		done
	fi
else

	echo ".oh-my-zsh isn't installed!"
	echo "  Install: https://ohmyz.sh/#install"

	exit 2
fi

