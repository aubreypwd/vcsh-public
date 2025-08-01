#!/bin/sh

# My Mac Defaults
# @since Tuesday, April 19, 2022
reset-mac-defaults () {

	# iTerm2
	defaults write com.googlecode.iterm2 OpenFileInNewWindows -bool false # false always opens in a tab, true opens a new window

	# Misc
	defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
	defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
	defaults write com.apple.desktopservices DSDontWriteNetworkStores true
	defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
	defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

	# Disable disk image verification
	defaults write com.apple.frameworks.diskimages skip-verify -bool true
	defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
	defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

	# Automatically open a new Finder window when a volume is mounted
	defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
	defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
	defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

	# Keyboard
	defaults write com.apple.loginwindow DisableScreenLockImmediate -bool yes # Disable the lock key above the delete key.
	defaults write com.googlecode.iterm2 "Secure Input" 0 # Tell iterm2 to allow non-secure input for escape

	# Sublime Text
	defaults write com.sublimetext.4 ApplePressAndHoldEnabled -bool false # https://www.sublimetext.com/docs/vintage.html#mac
	defaults write com.sublimetext ApplePressAndHoldEnabled -bool false # https://www.sublimetext.com/docs/vintage.html#mac

	# TextEdit
	defaults write com.apple.TextEdit SmartQuotes -bool false
	defaults write com.apple.TextEdit SmartDashes -bool false

	# Dock
	defaults write com.apple.Dock autohide-delay -float 0 # Show dock after X seconds.
	defaults write com.apple.dock autohide-time-modifier -int 1 # Animation speed.
	defaults write com.apple.dock show-recents -bool true;
	defaults write com.apple.dock show-recent-count -int 3;

	# Finder
	defaults write com.apple.Finder QuitMenuItem 1 # Add Quit to Finder
	defaults write com.apple.Finder FXPreferredViewStyle Nlsv # Tell Finder what view style to use, see https://www.defaults-write.com/change-default-view-style-in-os-x-finder/
	defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false # Disable the warning when changing a file extension
	defaults write com.apple.finder _FXShowPosixPathInTitle -bool true # Show full path in the path bar.
	defaults write com.apple.finder CreateDesktop false # Desktop icons/items/Stage Manager should be hidden.
	defaults write NSGlobalDomain "NSToolbarTitleViewRolloverDelay" -float "0" # When hovering over the folder in finder, show the icon immediately.

	# Safari
	defaults write com.apple.Safari WebKitDebugDeveloperExtrasEnabled -bool true # Allow inspecting the web inspector.
	defaults write com.apple.Safari IncludeInternalDebugMenu -bool false # Don't show the debug menu in normal Safari.
	defaults write com.apple.SafariTechnologyPreview IncludeInternalDebugMenu -bool true # But show it in STP.
	defaults write com.apple.Safari TargetedClicksCreateTabs -bool false # Tell Safari to open targeted links in new tab/window (false means don't).

	# WindowsManger (Stage Manager)
	defaults write com.apple.WindowManager AutoHideDelay -int 9999 # Wait X seconds to show Stage Manager.
	defaults write com.apple.WindowManager StageFrameMinimumHorizontalInset -int 0 # See https://www.reddit.com/r/MacOS/comments/ydgi9z/stage_manager_causes_new_windows_to_not_be/

	# Screenshots (Native)
	defaults write com.apple.screencaptureui "thumbnailExpiration" -float 9999 # Keep the floating thumbnail up indefinitly.
	defaults write com.apple.screencapture type png # Take jpg screenshots.
	defaults write com.apple.screencapture location "$HOME/Pictures/Screenshots/Autosaved"

	# Repeat key mode for VIM emulation in VSCode.
	defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false # For VS Code

	# Make sure loginwindow didn't get fucked up by something so I can lock the screen.
	defaults delete com.apple.loginwindow

	# Reset apps.
	killall "Dock"
	killall "Finder"
}
