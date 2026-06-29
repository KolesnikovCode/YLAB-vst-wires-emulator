#!/usr/bin/env bash
set -euo pipefail

VERSION="${1:-1.0.0}"
PRODUCT="wires-emulator"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BUILD_DIR="$ROOT/build-release"
RELEASE_DIR="$ROOT/releases"
PKG_ROOT="$ROOT/releases/.pkg-root-$VERSION"
ZIP_ROOT="$ROOT/releases/.zip-root-$VERSION"

ARTEFACTS_DIR="$BUILD_DIR/WireEmulator_artefacts/Release"
VST3_SRC="$ARTEFACTS_DIR/VST3/$PRODUCT.vst3"
AU_SRC="$ARTEFACTS_DIR/AU/$PRODUCT.component"

ZIP_NAME="$RELEASE_DIR/${PRODUCT}-${VERSION}-macos-universal.zip"
PKG_NAME="$RELEASE_DIR/${PRODUCT}-${VERSION}-macos-universal.pkg"

# Optional signing (requires Apple Developer Program):
#   export CODESIGN_IDENTITY="Developer ID Application: Your Name (TEAMID)"
#   export INSTALLER_IDENTITY="Developer ID Installer: Your Name (TEAMID)"
#   export NOTARY_APPLE_ID="you@example.com"
#   export NOTARY_TEAM_ID="TEAMID"
#   export NOTARY_APP_PASSWORD="xxxx-xxxx-xxxx-xxxx"

sign_bundle() {
    local bundle="$1"
    codesign --force --options runtime --timestamp \
        --sign "$CODESIGN_IDENTITY" \
        --deep "$bundle"
    codesign --verify --deep --strict --verbose=2 "$bundle"
}

notarize_pkg() {
    local submission
    submission=$(mktemp -t notary-submission.XXXXXX)
    xcrun notarytool submit "$PKG_NAME" \
        --apple-id "$NOTARY_APPLE_ID" \
        --team-id "$NOTARY_TEAM_ID" \
        --password "$NOTARY_APP_PASSWORD" \
        --wait \
        --output-format plist > "$submission"
    if ! /usr/libexec/PlistBuddy -c "Print :status" "$submission" | grep -q "Accepted"; then
        echo "Notarization failed. Log:" >&2
        xcrun notarytool log "$(/usr/libexec/PlistBuddy -c 'Print :id' "$submission")" \
            --apple-id "$NOTARY_APPLE_ID" \
            --team-id "$NOTARY_TEAM_ID" \
            --password "$NOTARY_APP_PASSWORD" >&2 || true
        rm -f "$submission"
        exit 1
    fi
    rm -f "$submission"
    xcrun stapler staple "$PKG_NAME"
    xcrun stapler validate "$PKG_NAME"
}

echo "==> Building $PRODUCT $VERSION (arm64 + x86_64)"
cmake -B "$BUILD_DIR" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_OSX_ARCHITECTURES="arm64;x86_64"
cmake --build "$BUILD_DIR" --config Release -j"$(sysctl -n hw.ncpu)"

echo "==> Verifying architectures"
lipo -info "$VST3_SRC/Contents/MacOS/$PRODUCT"
lipo -info "$AU_SRC/Contents/MacOS/$PRODUCT"

if [[ -n "${CODESIGN_IDENTITY:-}" ]]; then
    echo "==> Signing plugin bundles"
    sign_bundle "$VST3_SRC"
    sign_bundle "$AU_SRC"
else
    echo "==> Skipping code signing (set CODESIGN_IDENTITY to enable)"
fi

echo "==> Creating ZIP"
rm -rf "$ZIP_ROOT"
PKG_DIR="$ZIP_ROOT/$PRODUCT"
mkdir -p "$PKG_DIR/VST3" "$PKG_DIR/AU"
cp -R "$VST3_SRC" "$PKG_DIR/VST3/"
cp -R "$AU_SRC" "$PKG_DIR/AU/"

cp "$ROOT/scripts/install-macos.sh" "$PKG_DIR/install.sh"
chmod +x "$PKG_DIR/install.sh"

cat > "$PKG_DIR/Install.txt" <<EOF
wires-emulator $VERSION — macOS (Apple Silicon + Intel)

Quick install:

  1. Remove quarantine from the downloaded archive:
     xattr -dr com.apple.quarantine ~/Downloads/wires-emulator-${VERSION}-macos-universal.zip

  2. Extract the archive, open Terminal in the extracted folder, run:
     bash install.sh

  3. Rescan plugins in your DAW.

Manual install:

  Copy VST3/wires-emulator.vst3 to ~/Library/Audio/Plug-Ins/VST3/
  Copy AU/wires-emulator.component to ~/Library/Audio/Plug-Ins/Components/
EOF

rm -f "$ZIP_NAME"
ditto -c -k --sequesterRsrc --keepParent "$PKG_DIR" "$ZIP_NAME"

if [[ -n "${INSTALLER_IDENTITY:-}" ]]; then
    echo "==> Creating signed PKG"
    rm -rf "$PKG_ROOT"
    mkdir -p "$PKG_ROOT/Library/Audio/Plug-Ins/VST3"
    mkdir -p "$PKG_ROOT/Library/Audio/Plug-Ins/Components"
    cp -R "$VST3_SRC" "$PKG_ROOT/Library/Audio/Plug-Ins/VST3/"
    cp -R "$AU_SRC" "$PKG_ROOT/Library/Audio/Plug-Ins/Components/"

    rm -f "$PKG_NAME"
    pkgbuild \
      --root "$PKG_ROOT" \
      --identifier "com.ylab.wires-emulator" \
      --version "$VERSION" \
      --install-location "/" \
      --sign "$INSTALLER_IDENTITY" \
      "$PKG_NAME"

    if [[ -n "${NOTARY_APPLE_ID:-}" && -n "${NOTARY_TEAM_ID:-}" && -n "${NOTARY_APP_PASSWORD:-}" ]]; then
        echo "==> Notarizing PKG"
        notarize_pkg
    fi

    rm -rf "$PKG_ROOT"
else
    echo "==> Skipping PKG (unsigned PKG is blocked by Gatekeeper; set INSTALLER_IDENTITY to ship PKG)"
    rm -f "$PKG_NAME"
fi

rm -rf "$ZIP_ROOT"

echo "==> Release artifacts"
ls -lh "$RELEASE_DIR/${PRODUCT}-${VERSION}"* 2>/dev/null || ls -lh "$ZIP_NAME"
