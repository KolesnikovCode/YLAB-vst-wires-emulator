# wires-emulator v1.0.0

First public release of **wires-emulator** by YLAB — a macOS audio plugin for selecting premium interconnect configurations.

## Highlights

- VST3 and Audio Unit support
- Universal binary for Apple Silicon and Intel Macs
- Four wire options: gold, copper, and both on wooden stands
- Session-persistent wire selection with audiophile descriptions
- Dark-themed interface with visual wire previews

## Wire options

- **Gold Wire** — Crystalline highs, effortless air, and uncolored transparency.
- **Copper Wire** — Rich harmonics, velvety mids, and an inviting musical warmth.
- **Gold Wire on Wooden Stand** — Seasoned hardwood riser reveals hidden micro-detail and spatial depth.
- **Copper Wire on Wooden Stand** — Elevated on kiln-dried birch for a wider, more organic soundstage.

## Downloads

| File | Description |
|------|-------------|
| `wires-emulator-1.0.0-macos-universal.pkg` | Installer — places plugins in `/Library/Audio/Plug-Ins/` |
| `wires-emulator-1.0.0-macos-universal.zip` | Manual install — copy VST3 and AU to `~/Library/Audio/Plug-Ins/` |

## Requirements

- macOS 10.13 or later
- Apple Silicon or Intel Mac

## Installation (PKG)

1. Download `wires-emulator-1.0.0-macos-universal.pkg`
2. Open the package and follow the installer
3. Rescan plugins in your DAW

## Installation (ZIP)

1. Download and extract the archive
2. Copy `VST3/wires-emulator.vst3` to `~/Library/Audio/Plug-Ins/VST3/`
3. Copy `AU/wires-emulator.component` to `~/Library/Audio/Plug-Ins/Components/`
4. Rescan plugins in your DAW

## macOS Gatekeeper warning

Downloads from GitHub are quarantined. Unsigned builds trigger Apple's security warning.

**Option A — ZIP (recommended for unsigned builds):**

```bash
xattr -dr com.apple.quarantine ~/Downloads/wires-emulator-1.0.0-macos-universal.zip
```

Then extract and copy plugins manually (see Installation ZIP above).

**Option B — PKG:**

Right-click the `.pkg` file and choose **Open**, then confirm in the dialog.  
Or remove quarantine first:

```bash
xattr -d com.apple.quarantine ~/Downloads/wires-emulator-1.0.0-macos-universal.pkg
```

**Option C — System Settings:**

Open **System Settings → Privacy & Security** and click **Open Anyway** after the blocked attempt.

Signed and notarized releases do not require these steps. See `scripts/package-macos-release.sh` for maintainer signing setup.
