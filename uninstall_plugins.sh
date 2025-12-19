#!/bin/sh
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGINS_DIR="$SCRIPT_DIR/plugins"
ADDONS_DIR_DEFAULT="$HOME/Library/Application Support/Anki2/addons21"
ADDONS_DIR="${ANKI_ADDONS_DIR:-$ADDONS_DIR_DEFAULT}"
PLUGIN_NAME=""

usage() {
  cat <<'USAGE'
Usage: ./uninstall_plugins.sh [-p plugin_name]

Uninstalls all plugins by default. Use -p to uninstall a single plugin.
USAGE
}

while getopts "p:h" opt; do
  case "$opt" in
    p) PLUGIN_NAME="$OPTARG" ;;
    h)
      usage
      exit 0
      ;;
    *)
      usage >&2
      exit 1
      ;;
  esac
done
shift $((OPTIND - 1))

if [ "$#" -ne 0 ]; then
  usage >&2
  exit 1
fi

if [ ! -d "$PLUGINS_DIR" ]; then
  echo "Plugins directory not found: $PLUGINS_DIR" >&2
  exit 1
fi

uninstall_plugin() {
  name="$1"
  target_link="$ADDONS_DIR/$name"

  if [ -L "$target_link" ]; then
    rm "$target_link"
    echo "Removed symlink $target_link"
    return 0
  fi

  if [ -e "$target_link" ]; then
    echo "Target exists and is not a symlink: $target_link" >&2
    exit 1
  fi

  echo "No install found at $target_link"
}

if [ -n "$PLUGIN_NAME" ]; then
  uninstall_plugin "$PLUGIN_NAME"
  exit 0
fi

for dir in "$PLUGINS_DIR"/*; do
  [ -d "$dir" ] || continue
  uninstall_plugin "$(basename "$dir")"
done
