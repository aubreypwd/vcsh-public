#!/bin/bash

autoload -Uz add-zsh-hook

typeset -g GHOSTTY_LAST_CMD=""
typeset -g GHOSTTY_CURRENT_CMD=""

ghostty_set_title() {
  local title="$PWD"

  [[ -n "$GHOSTTY_CURRENT_CMD" && "$GHOSTTY_CURRENT_CMD" != "idle" ]] && title="$title - $GHOSTTY_CURRENT_CMD"
  [[ -n "$GHOSTTY_LAST_CMD" && "$GHOSTTY_LAST_CMD" != "idle" ]] && title="$title - $GHOSTTY_LAST_CMD"

  printf '\033]2;%s\007' "$title"
}

ghostty_preexec() {
  GHOSTTY_CURRENT_CMD="$1"
  ghostty_set_title
}

ghostty_precmd() {
  GHOSTTY_LAST_CMD="$GHOSTTY_CURRENT_CMD"
  GHOSTTY_CURRENT_CMD=""
  ghostty_set_title
}

add-zsh-hook preexec ghostty_preexec
add-zsh-hook precmd ghostty_precmd