# Anki Add-ons

My own Anki plugins for personal use.

## Layout

- `plugins/` contains each plugin in its own subdirectory.
- `install_plugins.sh` installs plugins by creating symlinks.
- `uninstall_plugins.sh` removes those symlinks.

## Install

Install all plugins:

```sh
./install_plugins.sh
```

Install a single plugin:

```sh
./install_plugins.sh -p fuzzy_type
```

## Uninstall

Uninstall all plugins:

```sh
./uninstall_plugins.sh
```

Uninstall a single plugin:

```sh
./uninstall_plugins.sh -p fuzzy_type
```

## Configuration

By default, scripts target:

```
$HOME/Library/Application Support/Anki2/addons21
```

Override the target with:

```sh
ANKI_ADDONS_DIR=/path/to/addons21 ./install_plugins.sh
```
