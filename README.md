# qt 6.9.1 (Major v6)

VFX Platform 2025 compatible build package for qt.

## Package Information

- **Package Name**: qt
- **Version**: 6.9.1
- **Major Version**: 6
- **Repository**: vfxplatform-2025/qt-6
- **Description**: Qt 6.9.1 built with FFmpeg 6.1.1 and system media support

## Build Instructions

```bash
rez-build -i
```

## Package Structure

```
qt/
├── 6.9.1/
│   ├── package.py      # Rez package configuration
│   ├── rezbuild.py     # Build script
│   ├── get_source.sh   # Source download script (if applicable)
│   └── README.md       # This file
```

## Installation

When built with `install` target, installs to: `/core/Linux/APPZ/packages/qt/6.9.1`

## Version Strategy

This repository contains **Major Version 6** of qt. Different major versions are maintained in separate repositories:

- Major v6: `vfxplatform-2025/qt-6`

## VFX Platform 2025

This package is part of the VFX Platform 2025 initiative, ensuring compatibility across the VFX industry standard software stack.
