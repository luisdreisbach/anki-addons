#!/bin/sh
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGINS_DIR="$SCRIPT_DIR/plugins"
ADDONS_DIR_DEFAULT="$HOME/Library/Application Support/Anki2/addons21"
ADDONS_DIR="${ANKI_ADDONS_DIR:-$ADDONS_DIR_DEFAULT}"
PLUGIN_NAME=""

usage() {
  cat <<'USAGE'
Usage: ./install_plugins.sh [-p plugin_name]

Installs all plugins by default. Use -p to install a single plugin.
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

install_plugin() {
  name="$1"
  source_dir="$PLUGINS_DIR/$name"
  target_link="$ADDONS_DIR/$name"

  if [ ! -d "$source_dir" ]; then
    echo "Plugin source not found: $source_dir" >&2
    exit 1
  fi

  mkdir -p "$ADDONS_DIR"

  if [ -e "$target_link" ] && [ ! -L "$target_link" ]; then
    echo "Target exists and is not a symlink: $target_link" >&2
    exit 1
  fi

  ln -sfn "$source_dir" "$target_link"
  echo "Installed $name -> $target_link"
}

if [ -n "$PLUGIN_NAME" ]; then
  install_plugin "$PLUGIN_NAME"
  exit 0
fi

for dir in "$PLUGINS_DIR"/*; do
  [ -d "$dir" ] || continue
  install_plugin "$(basename "$dir")"
done
