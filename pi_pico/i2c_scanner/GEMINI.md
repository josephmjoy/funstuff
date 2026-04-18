# I2C Scanner Subproject

This subproject provides a simple utility to scan the I2C bus on a Raspberry Pi Pico or other CircuitPython-compatible boards.

## Configuration
- **Board**: Raspberry Pi Pico
- **Pins**: GP0 (SDA), GP1 (SCL)
- **Library**: `busio`, `board`, `time`

## Simulation
A `diagram.json` is provided for Wokwi simulation. It includes a DS1307 RTC as an example I2C device.

## Known Limitations
- The current implementation scans periodically (every 5 seconds).
- It assumes the I2C bus is on `board.SCL` and `board.SDA`. On a Pi Pico, these often map to GP1 and GP0 respectively, but this can vary by board.
