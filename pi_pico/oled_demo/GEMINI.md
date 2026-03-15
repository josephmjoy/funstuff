# Project: Raspberry Pi Pico OLED Demo (CircuitPython)

This project controls an SSD1306 OLED display (128x32) using CircuitPython on a Raspberry Pi Pico.

## Mandates & Constraints

- **CircuitPython Versioning**: The project must support both Wokwi (8.x) and real hardware (10.x).
  - Use dynamic imports for `I2CDisplayBus`:
    - Pre-9.x: `from displayio import I2CDisplay as I2CDisplayBus`
    - 9.x+: `from i2cdisplaybus import I2CDisplayBus`
- **Library Selection**: 
  - ALWAYS use `adafruit_displayio_ssd1306` for displayio-based text/graphics.
  - DO NOT use the older buffer-based `adafruit_ssd1306` unless explicitly requested.
  - Required libraries: `adafruit_displayio_ssd1306`, `adafruit_display_text`, `terminalio`.
- **Hardware Configuration**:
  - I2C Pins: `SDA = board.GP0`, `SCL = board.GP1`.
  - I2C Address: `0x3C`.
  - Display Resolution: `128x32`.
- **Code Style**:
  - Prefer `displayio` for all UI elements (Groups, Labels, Bitmaps).
  - Use `display.root_group = splash` to set the main display group.
- **Source Control**:
  - ALWAYS prefix commit message titles with `[AI Generated]`.
