#!/usr/bin/env bash
#* This script is from https://github.com/cetz-package/cetz/blob/master/scripts/package
set -eu

PKG_PREFIX="ichigo"

# List of all files that get packaged
files=(
  template/
  src/
  export.typ
  typst.toml
  LICENSE
  README.md
  thumbnail.png
)

# Local package directories per platform
if [[ "$OSTYPE" == "linux"* ]]; then
  DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  DATA_DIR="$HOME/Library/Application Support"
else
  DATA_DIR="${APPDATA}"
fi

if (( $# < 1 )) || [[ "${1:-}" == "help" ]]; then
  echo "package TARGET [--relative-paths]"
  echo ""
  echo "Packages all relevant files into a directory named '${PKG_PREFIX}/<version>'"
  echo "at TARGET. If TARGET is set to @local, the local Typst package directory"
  echo "will be used so that the package gets installed for local use, if @preview"
  echo "is used, Typsts preview cache dir will be used."
  echo "The version is read from 'typst.toml' in the project root."
  echo ""
  echo "Local package prefix: $DATA_DIR/typst/package/local"
  exit 1
fi

function read-toml() {
  local file="$1"
  local key="$2"
  # Read a key value pair in the format: <key> = "<value>"
  # stripping surrounding quotes.
  perl -lne "print \"\$1\" if /^${key}\\s*=\\s*\"(.*)\"/" < "$file"
}

SOURCE="$(cd "$(dirname "$0")"; pwd -P)/.." # macOS has no realpath
TARGET="${1:?Missing target path or @local}"; shift
VERSION="$(read-toml "$SOURCE/typst.toml" "version")"

OPT_RELATIVE_PATHS=false
while [[ $# -gt 0 ]]; do
  case "$1" in
    --relative-paths)
      OPT_RELATIVE_PATHS=true
      shift
      ;;
    *)
      echo "Unexpected option $1!"
      exit 1
      ;;
  esac
done

if [[ "$TARGET" == "@local" ]] || [[ "$TARGET" == "install" ]]; then
  TARGET="${DATA_DIR}/typst/packages/local/"
elif [[ "$TARGET" == "@preview" ]]; then
  TARGET="${DATA_DIR}/typst/packages/preview/"
fi
echo "Install dir: $TARGET"

TMP="$(mktemp -d)"

for f in "${files[@]}"; do
  mkdir -p "$TMP/$(dirname "$f")" 2>/dev/null
  cp -r "$SOURCE/$f" "$TMP/$f"
done

TARGET="${TARGET:?}/${PKG_PREFIX:?}/${VERSION:?}"
echo "Packaged to: $TARGET"
if rm -rf "${TARGET:?}" 2>/dev/null; then
  echo "Overwriting existing version."
fi

if $OPT_RELATIVE_PATHS; then
  echo "Changing imports to relative."
  "$SOURCE/scripts/relpaths" "$TMP"
fi

mkdir -p "$TARGET"
mv "$TMP"/* "$TARGET"