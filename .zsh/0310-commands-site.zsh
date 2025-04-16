#!/bin/zsh

# shellcheck disable=SC2139

# Requirements.
require "trash" "brew reinstall trash" "brew"
require "tag" "brew reinstall tag" "brew"

site () {
	cd "$HOME/Sites" && ff2d
}