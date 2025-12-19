#!/bin/sh
set -e

ADDON_NAME="fuzzy_type"
ADDONS_DIR_DEFAULT="$HOME/Library/Application Support/Anki2/addons21"
ADDONS_DIR="${ANKI_ADDONS_DIR:-$ADDONS_DIR_DEFAULT}"
TARGET_LINK="$ADDONS_DIR/$ADDON_NAME"

if [ -L "$TARGET_LINK" ]; then
  rm "$TARGET_LINK"
  echo "Removed symlink $TARGET_LINK"
  exit 0
fi

if [ -e "$TARGET_LINK" ]; then
  echo "Target exists and is not a symlink: $TARGET_LINK" >&2
  exit 1
fi

echo "No install found at $TARGET_LINK"
