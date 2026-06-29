# Wire Emulator

A VST/AU plugin for selecting premium interconnect configurations. Your wire choice is saved in the plugin state and recalled with your session.

## Wire options

- **Gold Wire** — Crystalline highs, effortless air, and uncolored transparency.
- **Copper Wire** — Rich harmonics, velvety mids, and an inviting musical warmth.
- **Gold Wire on Wooden Stand** — Seasoned hardwood riser reveals hidden micro-detail and spatial depth.
- **Copper Wire on Wooden Stand** — Elevated on kiln-dried birch for a wider, more organic soundstage.

## Requirements

- CMake 3.22+
- C++17 compiler (Xcode on macOS, MSVC on Windows, GCC/Clang on Linux)
- Git (JUCE is fetched automatically via CMake)

## Build

```bash
cmake -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --config Release
```

On macOS, built plugins are copied to:

- VST3: `~/Library/Audio/Plug-Ins/VST3/Wire Emulator.vst3`
- AU: `~/Library/Audio/Plug-Ins/Components/Wire Emulator.component`
- Standalone: `build/WireEmulator_artefacts/Release/Standalone/`

## Run standalone (for quick testing)

```bash
./build/WireEmulator_artefacts/Release/Standalone/Wire\ Emulator.app/Contents/MacOS/Wire\ Emulator
```

## macOS install (release downloads)

Download the ZIP from [Releases](https://github.com/KolesnikovCode/YLAB-wires-emulator/releases), remove quarantine, and run the installer script:

```bash
xattr -dr com.apple.quarantine ~/Downloads/wires-emulator-*-macos-universal.zip
# extract, then inside the wires-emulator folder:
bash install.sh
```

Unsigned PKG installers are not shipped — macOS Gatekeeper blocks them without an Apple Developer certificate.

For signed releases, set `CODESIGN_IDENTITY`, `INSTALLER_IDENTITY`, and `NOTARY_*` env vars before running `scripts/package-macos-release.sh`.

## Project structure

```
vst-wires/
├── CMakeLists.txt
├── Source/
│   ├── PluginProcessor.h/cpp   — audio passthrough + parameter state
│   └── PluginEditor.h/cpp      — wire selector UI
└── README.md
```

Built with [JUCE](https://juce.com/) 8.
