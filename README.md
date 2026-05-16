# Breathing Exercise

Guided breathing techniques for relaxation and focus.

<img src="screenshot.png" width="400" alt="Screenshot">

## Install


**Required:** This plugin requires [dms-common](https://github.com/hthienloc/dms-common) to be installed.

```bash
# 1. Install shared components
git clone https://github.com/hthienloc/dms-common ~/.config/DankMaterialShell/plugins/dms-common

# 2. Install this plugin
dms://plugin/install/breathing
```

Or manually:
```bash
git clone https://github.com/hthienloc/dms-breathing ~/.config/DankMaterialShell/plugins/breathing
```

## Features

- **6 techniques** - Deep Breathing, 4-7-8, Box, Equal, Resonance, Alternate Nostril
- **Visual guide** - Phase indicator with icon and countdown
- **Duration presets** - Quick selection from 1m to 30m
- **Quick start** - Double-tap same exercise to begin

## Usage

| Action | Result |
|--------|--------|
| Left click | Open exercise selector |
| Double-tap exercise | Start immediately |
| Right click | Pause/resume |

## License

GPL-3.0

## Roadmap / TODO

- [ ] **Custom technique builder** to allow users to define their own inhale/hold/exhale times.
- [ ] **Haptic feedback support** for phase changes (inhale/exhale transitions).
- [ ] **Session history tracker** to monitor daily breathing streaks and statistics.
