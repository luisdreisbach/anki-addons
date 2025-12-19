#!/bin/sh
set -e

ADDON_NAME="fuzzy_type"
ADDON_SOURCE_DIR="$(cd "$(dirname "$0")" && pwd)/${ADDON_NAME}"
ADDONS_DIR_DEFAULT="$HOME/Library/Application Support/Anki2/addons21"
ADDONS_DIR="${ANKI_ADDONS_DIR:-$ADDONS_DIR_DEFAULT}"
TARGET_LINK="$ADDONS_DIR/$ADDON_NAME"

if [ ! -d "$ADDON_SOURCE_DIR" ]; then
  echo "Addon source not found: $ADDON_SOURCE_DIR" >&2
  exit 1
fi

mkdir -p "$ADDONS_DIR"

if [ -e "$TARGET_LINK" ] && [ ! -L "$TARGET_LINK" ]; then
  echo "Target exists and is not a symlink: $TARGET_LINK" >&2
  exit 1
fi

ln -sfn "$ADDON_SOURCE_DIR" "$TARGET_LINK"

echo "Installed $ADDON_NAME -> $TARGET_LINK"
