#!/bin/zsh

# shellcheck disable=SC2139

# My Commands
# ===========
# @since Thursday, 10/1/2020      Moved over from .config
# @since Apr 19, 2022             Move to own plugin.
# @since Wednesday, July 13, 2022 Combined with Aliases + Functions.

# Aliases
# =======

# General Aliases
alias b="bell"
alias beep="bell"
alias bell="tput bel"
alias blogname="wp option get blogname"
alias c=clear
alias cat="bat"

# Composer Aliases
alias cc1="composer self-update --1"
alias cc2="composer self-update --2"
alias ccc="composer clearcache && composer global clearcache"
alias cid="composer install --prefer-dist --ignore-platform-reqs" # dist install.
alias cis="composer install --prefer-source --ignore-platform-reqs" # source install.

# Editor Aliases
alias e="edit"

# Xdebug aliases
alias xdb="dbgpClient-macos-arm64 -p 9022"
alias localdb="dbgpClient-macos-arm64 -p 9003" # LocalWP

# Misc Aliases
alias lg="lazygit"
alias ss='cmatrix' # Sceeen Saver
alias safariextconv='xcrun /Applications/Xcode.app/Contents/Developer/us/bin/safari-web-extension-converter' # Convert Chrome Extensions to Safari Extensions.
alias flushdns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'
alias home="cd $HOME"
alias repo="cd \$HOME/Repos && fd 2" # An easy way to get to a repo using my ffd command.
alias siteurl="wp option get siteurl"
alias wpe='wp site list --field=url | xargs -n1 -I % wp --url=%' # On each subsite, run a command.
alias delete="rm -R"
alias pwdcp="pwd | pbcopy"

# iTerm2 Tab Aliases
alias nt='ttab' # New tab.
alias nw='ttab -w' # New window.

# Hiding files Aliases
alias hide="chflags hidden"
alias unhide="chflags nohidden"

# Browser in the terminal
alias browse="carbonyl --zoom=50"

# Exit Alias.
if [[ ( "$TERM_PROGRAM" == 'vscode' ) ]]; then

	# Set DISSALOW_VSCODE_TERMINAL_EXIT=true
	if [[ "$DISSALOW_VSCODE_TERMINAL_EXIT" == "true" ]]; then

		# VSCode: Don't allow exit in VSCode terminals.
		alias x="echo 'Kill terminal in VSCode Instead.'"
		alias exit="echo 'Kill terminal in VSCode Instead'"
	else

		# VSCode: Allow exit and x.
		alias x='exit'
	fi
else

	# Everywhere else, always allow x.
	alias x='exit'
fi

# Functions
# =========

# Copy a file or a directory.
# Usage: copy directory1 directory2
# @since Friday, November 15, 2024
copy () {
	echo "Copying $1 to $2..."
	cp -Rfa "$1" "$2"
}

###
 # Get the site name from the database for this install.
 #
 # @since Oct 18, 2022
 ##
wpblogname () {
	wp option get blogname
}

###
 # Get the home url from the database for this install.
 #
 # @since Oct 18, 2022;
 ##
wphome () {
	wp option get home
}

###
 # Get the PHP version running.
 #g
 # @usedby sysinfo()
 #
 # @since Tuesday, August 2, 2022
 ##
phpv () {
	php -r 'echo phpversion() . "\n";' | sed 's/ *$//g'
}

###
 # Go to one of my plugins (Antigen/ZSH)
 #
 # @since Tuesday, July 26, 2022
 # @since Oct 13, 2022 Renamed to gotoplugin.
 # @since Aug 18, 2023 Renamed to zplugin.
 ##
zplugin () {
	cd "$HOME/.antigen/bundles/aubreypwd" || false && fd
}

###
 # Dump .Brewfile
 #
 # @since Tuesday, July 26, 2022
 ##
brewd () {
	brew bundle dump --file="$HOME/.Brewfile" --verbose --all --describe --force --no-lock "$@"
}

###
 # Get the name of the current directory.
 #
 # @since Thursday, June 30, 2022
 ##
nwd () {
	echo "${PWD##*/}";
}

###
 # System information.
 #
 # @since Thursday, July 7, 2022
 #
 # shellcheck disable=SC2028
 ##
sysinfo () {
	echo "\e[35mƤ PHP:\e[0m   \e[37m$(phpv)\e[0m" # Show the current working directory.
	echo "\e[37m $(pwd)\e[0m" # Show the current working directory.
}

###
 # Switching Databases
 #
 # @since Wednesday, July 6, 2022
 # @since Oct 12, 2022            Refactored to work with files vs internally switching.
 # @since Oct 13, 2022            Renamed to lwpdbs.
 # @since Oct 28, 2022            Renamed to wpdbs since it always works with the dbs/ folder.
 # @since Feb 1, 2024             Updated to use dbs/$(nwd) for the init file.
 ##
wpdbs () {

	# Please run this in the root.
	if test ! -e "wp-config.php"; then

		echo "Sorry, but you have to run this in the root of the install."
		return 1
	fi

	target_db="$1"
	export_db="$2"
	nwd="$(nwd)"

	# Keep the URL the same as the current install.
	install_url=""
		install_url="$(wp option get home)"

	if test -z "$install_url"; then

		echo "Could not determine install's current URL, can't continue (maybe you have a single site DB but have multisite on?)."
		return 1
	fi

	if test -z "$target_db"; then
		target_db="$nwd"
	fi

	mkdir -p "dbs"

	# If they supply an export DB name...
	if test -n "$export_db"; then

		# Export the db first, if they want to do that (will overwrite).
		echo "Exporting DB to dbs/$export_db.tar.gz"
		wpdbx "dbs/$export_db"
	else

		# Use the blogname to export the DB.
		echo "Exporting DB to dbs/$(wp option get blogname).tar.gz"
		wpdbx "dbs/$(wp option get blogname)"
	fi

	# Import or create a DB...
	if test -e "dbs/$target_db.tar.gz"; then

		# Import a DB tar that has the same name already in dbs/...
		echo "Importing dbs/$target_db.tar.gz instead of creating new install."
		wpdbr && wpdbi "dbs/$target_db.tar.gz"

	else

		echo "dbs/$target_db.tar.gz does not exist."

		if test -e "dbs/$nwd.tar.gz"; then

			# They have a dbs/$nwd.tar.gz file, use that as a base instead.
			echo "You have dbs/$nwd.tar.gz, importing it instead of creating new install (delete to ensure new installs are created)."

			wpdbr && wpdbi "dbs/$nwd.tar.gz"

			# Set the blogname to the target db when importing a reset so we can export it next time.
			wp option set blogname "$target_db" --url="$install_url"
		else

			echo "Creating new install with a blank DB..."

			# Multisite.
			if test '1' = "$(wp config get MULTISITE)"; then

				# Create a new multisite install.
				wp db reset --yes && \
					wp core multisite-install --title="$target_db" --url="$install_url" --admin_user="admin" --admin_password="password" --admin_email="localdev@spacehotline.com" --skip-email --skip-config

			# Single-site.
			else

				# Create an entirely new single-site install.
				wp db reset --yes && \
					wp core install --title="$target_db" --url="$install_url" --admin_user="admin" --admin_email="localdev@spacehotline.com" && \
						wp user update admin --user_pass="password"
			fi
		fi
	fi

	# Make sure our blogname matches what we imported.
	wp option set blogname "$target_db"

	# Done
	echo "Done!"
	echo "URL:      $(wp option get home)"
	echo "blogname: $(wp option get blogname)"
}

###
 # Import a DB using WP-CLI.
 #
 # ...that's compressed.
 #
 # @since Tuesday, April 26, 2022
 # @since Thursday, November 21, 2024 automatically uses .tar.gz.
 ##
wpdbi () {
	gzip -c -d "$1.tar.gz" | wp db import -
}

###
 # Export a DB using WP-CLI.
 #
 # ...and compress.
 #
 # @since Monday, April 25, 2022
 # @since Thursday, November 21, 2024 Added --add-drop-table.
 ##
wpdbx () {

	mkdir -p "$(dirname "$1")" && \
		wp db export --add-drop-table - | gzip -9 -f > "$1.tar.gz"
}

###
 # Open finder in the Terminal.
 #
 # This works because we always open Finder in the ~ folder, which
 # opens a normal window. Then we open a new window (tab) in Finder.
 #
 # @since Aug 11, 2022
 ##
finder () {
	open -a Finder .
}

###
 # Run a command in a directory.
 #
 # @since Thursday, July 28, 2022
 #
 # shellcheck disable=SC3057
 ##
rid () {
	( cd "$1" && "${@:2}" )
}

###
 # Get how many frames a video has.
 #
 # @since Dec 30, 2022
 # @see   https://stackoverflow.com/a/28376817/1436129
 ##
frames () {
	ffprobe -v error -select_streams v:0 -count_packets -show_entries stream=nb_read_packets -of csv=p=0 "$1"
}

###
 # Install WordPress.
 #
 # These uses the current directory name for the domain, title, etc.
 #
 # @since Feb 2, 2023
 ##
wpi () {

	if test -z "$1"; then

		echo "Please supply a title: wpi <title>"
		return 1
	fi

	wp core install --url="https://$(nwd).test" --title="$1" --admin_user=admin --admin_email="nobody@example.com" --admin_password="password" --skip-email
}

###
 # Same as wpi, but for multisite.
 #
 # @since Feb 2, 2023
 ##
wpimu () {

	if test -z "$1"; then
		echo "Please supply a title: wpimu <title>."
		return 1
	fi

	wp core multisite-install --title="$1" --admin_email="nobody@example.com" --url="https://$(nwd).test" --admin_password="password" --skip-email --skip-config
}

###
 # Reset the database.
 #
 # @since Feb 2, 2023
 ##
wpdbr () {
	wp db reset --yes
}

###
 # Reset DB and install WordPress.
 #
 # Pass --mu as "$2" to install as multisite.
 #
 # @since Feb 23, 2023
 ##
wpdbri () {

	if test -z "$1"; then

		echo "Please supply a title: $0 <title>"
		return 1
	fi

	mu='no'

	if [ "--mu" = "$2" ]; then
		mu='yes'
	fi

	if test ! -e "wp-config.php"; then

		echo "Please run where wp-config.php is."
		return 1;
	fi

	mkdir -p "dbs"

	echo "Exporting current db to dbs/$(wpblogname)..."
		wpdbx "dbs/$(wpblogname)"

	if [ "yes" = "$mu" ]; then

		wp config set WP_ALLOW_MULTISITE true --raw && \
			wpdbr && wpimu "$1" && wp rewrite flush

		return 0;
	fi

	wp config set WP_ALLOW_MULTISITE false --raw && \
		wpdbr && wpi "$1" &&wp rewrite flush

	return 0;
}

###
 # Update all the things.
 #
 # @since Apr 7, 2023
 ##
update () {
	brew update
}

###
 # Upgrade the things I usually want to upgrade.
 #
 # @since Apr 7, 2023
 #
 # @dependency in my-misc.zsh
 ##
upgrade () {

	brew upgrade gh
	brew upgrade n
	brew upgrade lazygit
	brew upgrade ghq
	brew upgrade openssl

	for VERSION in "${MY_PHP_VERSIONS[@]}"; do
		brew upgrade "php@$VERSION"
	done

	# Update all Cask apps to the latest.
	brew upgrade --cask

	composer global update laravel/valet:~4.0
}

###
 # Cleanup
 #
 # @since Dec 14, 2023
 ##
cleanup () {
	brew cleanup
}

###
 # Quietly do something in the background.
 #
 # @since Apr 7, 2023
 ##
quietly () {

	( ( # Quietly....

		eval "$1"

	) 1>&- 2>&- & )
}

###
 # Slugify a string.
 #
 # @since Apr 14, 2023
 ##
slugify () {

	# shellcheck disable=SC2018,SC2019
	echo "$1" | iconv -c -t ascii//TRANSLIT | sed -E 's/[~^]+//g' | sed -E 's/[^a-zA-Z0-9]+/-/g' | sed -E 's/^-+|-+$//g' | tr A-Z a-z
}

###
 # Delete .DS_Store in a folder (recursive).
 #
 # @since Jul 21, 2023
 ##
rmdstore () {

	dir="$1"

	if [ ! -d "$dir" ] || [ -L "$dir" ]; then

		echo "Sorry, but $dir does not exist (or it is a symlink)."
		return 1
	fi

	find "$dir" -name ".DS_Store" -delete

	killall Finder

	echo "Done cleaning $dir of .DS_Store files (recursively)."
}

###
 # Reset Finder to my default view.
 #
 # @since Jul 21, 2023
 # @since Sep 6, 2023 Change back to list view, just so much superior.
 ##
reset-finder () {

	echo "Quitting Finder (don't open until complete)..."

	killall Finder

	echo "Removing .DS_Store in $HOME/**..."

	rmdstore "$HOME"

	echo "Resetting Defaults..."

	reset-mac-defaults # Load mac defaults (where finder view is set).

	echo "Done resetting Finder default views, etc."

	open -a "Finder"
}

###
 # Restart Finder.
 #
 # @since Jul 28, 2023
 ##
restart-finder () {

	killall Finder
	finder "$HOME"
}

###
 # Slugify the current branch.
 #
 # @since Aug 4, 2023
 #
 # shellcheck disable=SC2005
 ##
slugifyb () {
	echo "$(slugify "$(git b)")"
}

###
 # Slugify the current branch and copy to the clipboard.
 #
 # @since Aug 4, 2023
 ##
slugifycb () {
	slugifyb | pbcopy
}

###
 # Turn WP_DEBUG on or off.
 #
 # E.g.
 #    wpdebug on (default)
 #    wpdebug off
 #
 # @since Aug 15, 2023
 ##
wpdebug () {

	switch="$1"

	if [ "$switch" = 'off' ]; then
		switch="false"
	else
		switch="true"
	fi

	wp config set "WP_DEBUG" "$switch" --raw
}

###
 # Turn multisite on or off.
 #
 # E.g. mu on
 # E.g. mu off (default)
 #
 # @since Aug 15, 2023
 ##
wpmu () {

	if [ 'on' = "$1" ]; then
		wp config set 'WP_ALLOW_MULTISITE' true --raw
	else
		wp config set 'WP_ALLOW_MULTISITE' false --raw
	fi
}

###
 # Turn WP Mail on and/or off.
 #
 # E.g.
 #     wpmail on
 #     wpmail off (default)
 #
 # @since Aug 15, 2023
 ##
wpmail () {

	if [ 'on' = "$1" ]; then
		wp config set 'MAIL' true --raw
	else
		wp config set 'MAIL' false --raw
	fi
}

###
 # Open a project.sublime-project file from LocalWP
 #
 # This looks for a project.sublime-project file in a LocalWP app/public
 # folder. Whatever that site's directory is e.g.
 #
 #     <dir>/app/public/
 #
 # 1. We rename project.sublime-project to <dir>.sublime-project
 # 2. We open the <dir>.sublime-project file
 #
 # If the <dir>.sublime-project file already exists, we open that.
 #
 # Fails if we can't figure out the file to open.
 #
 # @since Nov 1, 2023
 #
 # shellcheck disable=SC2046
 ##
sublop () {

	DIRDIR=$( basename $( pwd ) )

	if [ 'public' != "$DIRDIR" ]; then

		echo "We only do this for LocalWP in the app/public folder."
		return 1
	fi

	SUBLPROJECT="project.sublime-project"
	SITENAME=$( basename $( realpath '../..' ) )
	SITENAMEPROJECT="$SITENAME.sublime-project"

	if [ -e "$SITENAMEPROJECT" ]; then

		subl -p "$SITENAMEPROJECT" # We already did this.
		return 0
	fi

	if [ ! -e "$SUBLPROJECT" ]; then

		echo "No project.sublime-project or $SITENAMEPROJECT file found to open."
		return 1;
	fi

	mv "project.sublime-project" "$SITENAMEPROJECT" && \
		subl -p "$SITENAMEPROJECT"

	return 0
}

###
 # Wrap all my commands into the affwp command.
 #
 # This catches everything else I want to do
 #
 # @since Sep 20, 2023
 ##
affwp () {

	if [ 'nb' = "$1" ]; then

		USAGE="Usage example: affwpnb 'affiliate-wp/4804' 'Refactor Affiliate Group (filters) to result in the new Affiliate_Group_Rate object'"

		if [ -z "$2" ] || [ -z "$3" ]; then

			echo "$USAGE"
			return 1
		fi

		git nb "$2-$(slugify "$3" )";

		return 0;
	fi

	if [ 'l' = "$1" ]; then

		if [ 'personal' = "$1" ] || [ '1' = "$1" ]; then
			wp config set 'AFFWP_LICENSE' "personal"
			return 0
		fi

		if [ 'plus' = "$1" ] || [ '2' = "$1" ]; then
			wp config set 'AFFWP_LICENSE' "plus"
			return 0
		fi

		if [ 'pro' = "$1" ] || [ '3' = "$1" ]; then
			wp config set 'AFFWP_LICENSE' "pro"
			return 0
		fi

		echo "No license level set."
		return 1
	fi

	__affwp "$@"
}

###
 # Walk a directory using walk.
 #
 # @since Dec 19, 2023
 ##
cdw () {
	cd "$(walk --icons --dir-only --fuzzy "$@")" || return 1
}

# Walk through ~/Sites/Valet.
cdwv () {
	cd "$HOME/Sites/Valet" && cdw
}

###
 # Open a Local Site's WordPress Admin URL
 #
 # @arg <$1> If you supply a URL for a site we'll open /wp-admin/ on that URL instead.
 #
 # @since Jan 5, 2024
 ##
owpadmin () {

	if [ -z "$1" ]; then
		SITEURL="$(wp option get siteurl)/wp-admin/"
	else
		SITEURL="$1/wp-admin/"
	fi

	open --url "$SITEURL"
}

###
 # Open a Local Site's WordPress URL
 #
 # @arg <$1> If you supply a URL we'll open that instead.
 #
 # @since Jan 5, 2024
 ##
owpurl () {

	if [ -z "$1" ]; then
		SITEURL="$(wp option get siteurl)/"
	else
		SITEURL="$1/"
	fi

	open --url "$SITEURL"
}

###
 # Run Cloudflared Tunnel
 #
 # @arg <$1> How long to run the tunnel (defaults to 3 hours) e.g. 2m, 12s, 24h.
 #
 # @since Jan 10, 2024
 # @since Jan 11, 2024 Updated to just run the command for 5 hours (by default).
 ##
cftunnel () {

	TIMEOUT="$1"

	if [ -z "$TIMEOUT" ]; then
		TIMEOUT="5h" # Don't run for more than 3 hours, unless instructed.
	fi

	timeout "$TIMEOUT" cloudflared tunnel run
	notify "Cloudflared Tunneling Timeout"
}

###
 # Send Push Notification
 #
 # @arg <$1> The message you want to push to the notification.
 #
 # @since Jan 11, 2024
 ##
notify () {
	terminal-notifier -message "$1" -sender "com.iterm."
}

###
 # Install WordPress (Reset)
 #
 # @arg <$1> The name (and domain) of the site, e.g. "my-site".
 #           Will create my-site.test and name it my-site.
 #
 # @since Jan 12, 2024
 ##
wpinstall () {

	wpdbr

	NAME="$1"

	if [ -z "$NAME" ]; then
		NAME="$(nwd)"
	fi

	wp core install --url="http://$NAME.test" --admin_user=admin --admin_email="admin@example.com" --admin_password=password --title="$NAME"
}

###
 # Change Directory
 #
 # This just add addition functionality once you get into the directory.
 #
 # @since Jan 18, 2024
 ##
cd () {

	if [ "$(pwd)" = "$HOME" ]; then
		builtin cd "$@" && return 0
	fi

	builtin cd "$@" && \
		if [ -e "./.git" ]; then git s; fi
}

###
 # Run command, after first switching to
 # preferred npm version, then switch
 # back to lts.
 #
 # @usage nn i
 # @usage nn run build
 #
 # @arg <$*> The npm command to run (passed to eval).
 #
 # @since Feb 15, 2024
 # @since Tuesday, October 29, 2024 Renamed to nvmdo
 # @since Thursday, November 21, 2024 Renamed back to nn.
 ##
nn () {

	COMMAND="$*"
	NVMRC="./.nvmrc"

	if [ -z "$COMMAND" ]; then

		echo "Usage: nn <npm command>, e.g.: nn install, nn run build, etc."
		return 1
	fi

	if [ -e "$NVMRC" ]; then
		n auto # Use the version in .nvmrc.
	fi

	eval "npm $COMMAND" # Run the command

	if [ -e "$NVMRC" ]; then
		n lts # Switch back to the default version if we switch to nvmrc version.
	fi
}

###
 # Run a command in a directory.
 #
 # @arg <$@> Arguments for gh copilot explain.
 #
 # @usage explain "How do I create a new file in PHP?"
 #
 # @since Feb 15, 2024
 ##
explain () {
	gh copilot explain "$@"
}

###
 # Suggest a Command
 #
 # @arg <$1> The arguments for gh copilot suggest.
 #
 # @usage suggest "How do I create a new file in PHP?"
 #
 # @since Feb 15, 2024
 ##
suggest () {
	gh copilot suggest "$@"
}

###
 # Split terminal into (3) horizontal panes (including the current one).
 #
 # @usage 3vp
 #
 # @since Apr 17, 2024
 ##
3hp () {

	osascript \
		-e 'tell application "iTerm"' \
			-e 'tell current window' \
				-e 'tell current session' \
					-e 'split horizontally with default profile' \
					-e 'split horizontally with default profile' \
				-e 'end tell' \
			-e 'end tell' \
		-e 'end tell'
}

###
 # Split terminal into (2) horizontal panes (including the current one).
 #
 # @usage 3vp
 #
 # @since Apr 17, 2024
 ##
2hp () {

	osascript \
		-e 'tell application "iTerm"' \
			-e 'tell current window' \
				-e 'tell current session' \
					-e 'split horizontally with default profile' \
				-e 'end tell' \
			-e 'end tell' \
		-e 'end tell'
}

###
 # Split terminal into (2) vertical panes (including the current one).
 #
 # @usage 3vp
 #
 # @since Apr 17, 2024
 ##
2vp () {

	osascript \
		-e 'tell application "iTerm"' \
			-e 'tell current window' \
				-e 'tell current session' \
					-e 'split vertically with default profile' \
				-e 'end tell' \
			-e 'end tell' \
		-e 'end tell'
}

###
 # Get the Bundle ID of an app.
 #
 # @usage bundle "Safari"
 #
 # @since Jun 2, 2024
 # @since May 15th, 2025 -- Renamed to get-bundle-id.
 ##
get-bundle-id () {
	osascript "-e id of app '$1'"
}

###
 # Opens the WordPress DB in TablePlus
 #
 # @usage opendb
 #
 # @since Thursday, November 21, 2024
 ##
opendb () {
	open "mysql://root@localhost:3306/$(nwd)"
}

###
 # Add comment to a file
 #
 # E.g. comment <file> "Comment"
 #
 # @since 1.0.0
 # @since Thursday, 10/1/2020
 ##
comment () {
	if ! [[ -x $(command -v osascript) ]]; then
		echo "This works on macOS only, or this requires osascript."
		return
	fi

	osascript -e 'on run {f, c}' -e 'tell app "Finder" to set comment of (POSIX file f as alias) to c' -e end "$1" "$2" > /dev/null 2>&1
}

###
 # Update Dotfiles
 #
 # @usage <command> "Message to leave in the backup file comments."
 #
 # @since Sunday, November 24, 2024
 #/
udf () {

	# Ensure the file list exists.
	if [[ ! -f $DOTFILES_FILE_LIST ]]; then
		touch "$DOTFILES_FILE_LIST"
		chflags hidden "$DOTFILES_FILE_LIST" # Make sure the file list is hidden.
	fi

	# Ensure the backup directory exists.
	mkdir -p "$DOTFILES_BAK_DIR"

	COMMENT="$1"

	# Create a timestamped archive name.
	TIMESTAMP=$(date +"%m-%d-%Y-%I-%M-%S%p" | tr '[:upper:]' '[:lower:]')
	DOTFILES_ARCHIVE="$DOTFILES_BAK_DIR/Dotfiles-$TIMESTAMP.zip"

	# Initialize an array for log messages and files to add to the ZIP.
	LOG_MESSAGES=()
	FILES_TO_ZIP=()

	# Process each entry in the file list.
	while IFS= read -r FILE || [[ -n $FILE ]]; do

		# Skip empty lines or lines starting with #.
		[[ -z $FILE || $FILE == \#* ]] && continue

		# Expand the entry (handles glob patterns, directories, and single files).
		IFS=$'\n' EXPANDED_FILES=($(eval echo "$FILE"))

		for CLEAN_FILE in "${EXPANDED_FILES[@]}"; do
			if [[ -f $CLEAN_FILE ]]; then
				FILES_TO_ZIP+=("$CLEAN_FILE") # Add file to the ZIP list.
				LOG_MESSAGES+=("[Info] Added file: $CLEAN_FILE")
			elif [[ -d $CLEAN_FILE ]]; then
				# Recursively add all files in the directory.
				while IFS= read -r -d '' SUBFILE; do
					FILES_TO_ZIP+=("$SUBFILE")
				done < <(find "$CLEAN_FILE" -type f -print0)
				LOG_MESSAGES+=("[Info] Added directory contents: $CLEAN_FILE")
			else
				LOG_MESSAGES+=("[Error] Skipped invalid path or unmatched glob: $CLEAN_FILE.")
			fi
		done
	done < "$DOTFILES_FILE_LIST"

	echo "\nBacking up dotfiles to $DOTFILES_ARCHIVE archive...\n"

	# Add files to the ZIP archive.
	if [[ ${#FILES_TO_ZIP[@]} -eq 0 ]]; then
		LOG_MESSAGES+=("[Error] No files to add to the ZIP archive. Update $DOTFILES_FILE_LIST.")
	else
		if zip -vr9 -FS "$DOTFILES_ARCHIVE" "${FILES_TO_ZIP[@]}"; then
			LOG_MESSAGES+=("[Success] Files successfully added to ZIP archive: $DOTFILES_ARCHIVE.")
		else
			LOG_MESSAGES+=("[Error] Failed to add files to ZIP archive.")
			return 1
		fi
	fi

	# Add file comment on the update.
	comment "$DOTFILES_ARCHIVE" "$COMMENT"

	# Ensure the symlink directory exists.
	mkdir -p "$DOTFILES_SYMLINK_DIR"

	echo "\nCreating dotfile symlinks in $DOTFILES_SYMLINK_DIR/** for easy dotfiles management...\n"

	rm -Rf "$DOTFILES_SYMLINK_DIR" # Delete so we can re-build.

	# Create symlinks after zipping.
	for FILE in "${FILES_TO_ZIP[@]}"; do

		RELATIVE_PATH="${FILE#$HOME/}" # Remove $HOME prefix.
		TARGET_PATH="$DOTFILES_SYMLINK_DIR/$RELATIVE_PATH" # Destination symlink path.

		# Ensure the target directory exists.
		mkdir -p "$(dirname "$TARGET_PATH")"

		# Create the symlink.
		ln -sf "$FILE" "$TARGET_PATH" && \
			LOG_MESSAGES+=("[Success] Symlinked $FILE > $TARGET_PATH")
		done

	# Echo all log messages at the end.
	for MESSAGE in "${LOG_MESSAGES[@]}"; do
		echo "$MESSAGE"
	done

	echo "Done!"
}

###
 # Startup Operations
 #
 # @since Dec 14, 2023
 ##
reset () {

	reset-misc
	reset-mac-defaults
	reset-php
	reset-exts
	reset-mysql
}

###
 # Checkout a branch using fzf.
 #
 # @since 5/15/17
 # @since 1.0.0
 ##
function fzf-git-branch {

	require "fzf" "brew reinstall fzf" "brew"
	require "sed" "brew reinstall sed" "brew"
	require "git" "brew reinstall git" "brew"

	if ! [[ -x $(command -v fzf) ]]; then >&2 echo "Please install fzf to use." && return; fi
	if ! [[ -x $(command -v sed) ]]; then >&2 echo "Please install sed to use." && return; fi
	if ! [[ -x $(command -v sed) ]]; then >&2 echo "Please install git to use." && return; fi

	if ! [[ -d ".git" ]]; then
		echo "Not a git repository."
		return
	fi

	local branches=$(git branch -a) &&
	local branch=$(echo "$branches" | fzf +s +m -e) &&
	local git_cmd=$(echo "$branch" | sed "s:.* remotes/origin/::" | sed "s:.* ::")

	if [ -z "$git_cmd" ]; then
		return
	fi

	git checkout "$git_cmd"
}

###
 # Reload My Config
 #
 # E.g: reload
 #
 # @author Aubrey Portwood <code@aubreypwd.com>
 # @since 06-09-2019
 # @since 1.0.0
 # @since 1.2.0 Added support for omz reload.
 ##
reload () {

	if [[ ! -x "$(command -v "omz")" ]]; then

		echo "Reloading..." && \
			omz reload && \
				return 0
	fi

	ZDOTDIR=${ZDOTDIR:-$HOME}
	. "$ZDOTDIR/.zshrc"
}

###
 # Similar to cd, but using fzf.
 #
 # E.g: fd [level]
 #
 # @since Wednesday, 9/11/2019
 # @since April 11th, 2025 - Renamed to ffd (fuzzy-find-directory).
 # @since April 11th, 2025 - Also changed default depth to 4.
 ##
ffd () {

	require "fzf" "brew reinstall fzf" "brew" # Automatically install fzf using homebrew.

	DEPTH=4 # A reasonable depth.

	if [ -n "$1" ]; then
		DEPTH="$1"
	fi

	# Using $(...) instead of backticks for command substitution for better readability and nesting
	DIR=$(find -L * -maxdepth $DEPTH -type d -print 2> /dev/null | fzf --height=100%) \
		&& cd "$DIR" || return 1
}

alias fd="ffd 0" # For backwards compatibility.

###
 # Wrapper or aria2c
 #
 # E.g: download ["http://..."] [How many connections]
 #
 # @since Tuesday, May 21, 2019
 # @since 1.0.0
 ##
function download {
	require "aria2c" "brew reinstall aria2" "brew" # Automatically install aria2 using homebrew.

	if [[ -z "$1" ]]; then
		echo "Please supply a URL."
		return
	fi

	local connections="$2"

	if [ -z "$2" ]; then
		local connections="16"
	fi

	aria2c -x "$connections" "$1"
}

# vcsh shorthand for public and private repos.
# @since April 16th 2025 - With lazygit support.
for repo in public private; do
	eval "
		$repo() {
			if [[ \"\$1\" == \"lg\" ]]; then
				shift
				lazygit --git-dir=\"\$HOME/.config/vcsh/repo.d/$repo.git\" --work-tree=\"\$HOME\" \"\$@\"
			else
				vcsh $repo \"\$@\"
			fi
		}
	"
done

# Additional svn functionality.
# @since May 6th, 2025
function svn () {

	if [[ "$1" == "add-remove" || "$1" == "reindex" ]]; then
		command svn add --force . --auto-props --parents
		command svn status | grep '^!' | awk '{print $2}' | xargs -r command svn delete
		command svn status
	elif [[ "$1" == "sync-trunk-to-tag" || "$1" == "sttt" ]]; then
		command svn delete --force "tags/$2"
		command svn copy trunk "tags/$2"
		command svn status
	elif [[ "$1" == "reset" || "$1" == "rhhc" ]]; then
		command svn status --no-ignore | grep '^[?I]' | awk '{print $2}' | xargs -r rm -rf
		command svn revert -R .
		command svn cleanup
		command svn update
		command svn status
	else
		command svn "$@"
	fi
}