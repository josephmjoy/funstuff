---
name: pico-oled-manager
description: Manage and optimize OLED displays (SSD1306) on Raspberry Pi Pico using CircuitPython. Use for I2C configuration, displayio patterns, and troubleshooting hardware connections.
---

# Pico OLED Manager

This skill provides specialized workflows and patterns for controlling OLED displays on the Raspberry Pi Pico.

## Workflows

### 1. Initialization
When setting up a new display or fixing a "display not found" error:
1.  Check `references/display-init.md` for the correct `busio.I2C` pins.
2.  Identify if the project uses `displayio` (modern) or `adafruit_ssd1306` (legacy).
3.  Ensure `displayio.release_displays()` is called before initialization.

### 2. Drawing UI Elements
For drawing text or graphics:
- **displayio**: Create a `displayio.Group`, add `label.Label` for text, and use `display.root_group = group`.
- **legacy**: Use `oled.fill()`, `oled.text()`, and `oled.show()` direct methods.

### 3. Library Management
Ensure the following are in the Pico's `/lib` folder:
- `adafruit_ssd1306.mpy` (for legacy)
- `adafruit_displayio_ssd1306.mpy` (for modern)
- `adafruit_display_text/` (for text labels)
- `adafruit_framebuf.mpy` (dependency)

## Reference Documentation
- [Display Initialization](references/display-init.md) - I2C pins and code patterns.
