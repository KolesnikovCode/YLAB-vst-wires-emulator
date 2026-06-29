#!/usr/bin/env bash
set -euo pipefail

PRODUCT="wires-emulator"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
VST3_SRC="$SCRIPT_DIR/VST3/$PRODUCT.vst3"
AU_SRC="$SCRIPT_DIR/AU/$PRODUCT.component"
VST3_DEST="$HOME/Library/Audio/Plug-Ins/VST3"
AU_DEST="$HOME/Library/Audio/Plug-Ins/Components"

if [[ ! -d "$VST3_SRC" || ! -d "$AU_SRC" ]]; then
    echo "Error: plugin bundles not found next to install.sh" >&2
    exit 1
fi

mkdir -p "$VST3_DEST" "$AU_DEST"

xattr -dr com.apple.quarantine "$SCRIPT_DIR" 2>/dev/null || true

rm -rf "$VST3_DEST/$PRODUCT.vst3" "$AU_DEST/$PRODUCT.component"
cp -R "$VST3_SRC" "$VST3_DEST/"
cp -R "$AU_SRC" "$AU_DEST/"

xattr -dr com.apple.quarantine "$VST3_DEST/$PRODUCT.vst3" "$AU_DEST/$PRODUCT.component" 2>/dev/null || true

echo "Installed $PRODUCT:"
echo "  $VST3_DEST/$PRODUCT.vst3"
echo "  $AU_DEST/$PRODUCT.component"
echo ""
echo "Rescan plugins in your DAW."
