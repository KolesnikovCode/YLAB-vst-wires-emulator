# wires-emulator v1.0.1

macOS release with a simpler install flow for unsigned builds. PKG installer removed — unsigned PKG files are blocked by Gatekeeper.

## Highlights

- VST3 and Audio Unit support
- Universal binary for Apple Silicon and Intel Macs
- Four wire options: gold, copper, and both on wooden stands
- Session-persistent wire selection with audiophile descriptions
- Dark-themed interface with visual wire previews
- `install.sh` script for one-command installation

## Download

| File | Description |
|------|-------------|
| `wires-emulator-1.0.1-macos-universal.zip` | VST3, AU, and install script |

## Requirements

- macOS 10.13 or later
- Apple Silicon or Intel Mac

## Installation

1. Download `wires-emulator-1.0.1-macos-universal.zip`

2. Remove quarantine (required for downloads from GitHub):

```bash
xattr -dr com.apple.quarantine ~/Downloads/wires-emulator-1.0.1-macos-universal.zip
```

3. Extract the archive

4. Open Terminal in the extracted `wires-emulator` folder and run:

```bash
bash install.sh
```

5. Rescan plugins in your DAW

## Manual installation

Copy bundles to your user plugin folders:

- `VST3/wires-emulator.vst3` → `~/Library/Audio/Plug-Ins/VST3/`
- `AU/wires-emulator.component` → `~/Library/Audio/Plug-Ins/Components/`

## Upgrading from v1.0.0

Remove the old plugins if present, then follow the installation steps above. The v1.0.0 PKG installer is no longer distributed.
