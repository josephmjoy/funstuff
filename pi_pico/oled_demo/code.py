"""
Pico OLED Demo Main Entry Point
Demonstrates real-time uptime tracking and multi-row text rendering on an SSD1306 OLED,
now with Air Quality Index (AQI) monitoring via the ENS160 sensor.
Configured for Raspberry Pi Pico (GP0/GP1) and 128x32 resolution.
"""

import sys
import time

import board
import busio
import adafruit_ens160

from display import Display

# 1. Startup delay for power stabilization (important for headless operation)
time.sleep(1.5)

# 2. Get CircuitPython version for display
ver, *_ = sys.implementation.version

# 3. Setup I2C (GP1 = SCL, GP0 = SDA on Raspberry Pi Pico)
i2c = busio.I2C(board.GP1, board.GP0)

# 4. Initialize the refactored Display object
oled = Display(i2c, 0x3C, 32, 128, 3)

# 5. Initialize ENS160 Air Quality sensor with error handling
ens = None
try:
    ens = adafruit_ens160.ENS160(i2c)
    ens.temperature_compensation = 25
    ens.humidity_compensation = 50
    oled.set_row(0, "ENS160 AQI")
    oled.set_row(1, "Initializing...")
except (ValueError, RuntimeError, OSError) as e:
    print(f"ENS160 initialization failed: {e}")
    oled.set_row(0, "Sensor Error")
    oled.set_row(1, "Check Wiring")

# 6. Set initial uptime
oled.set_row(2, "Uptime: 0s")

# 7. Dynamic update loop
print(f"Starting display loop (v{ver}.x)...")
start_time = time.monotonic()

while True:
    uptime = int(time.monotonic() - start_time)

    if ens:
        try:
            # Read sensor values
            aqi = ens.AQI
            tvoc = ens.TVOC
            eco2 = ens.eCO2

            # Print values to the terminal
            print(f"Uptime: {uptime}s | AQI (1-5): {aqi} | TVOC: {tvoc} ppb | eCO2: {eco2} ppm")

            # Update OLED display rows
            oled.set_row(0, f"AQI: {aqi} | TVOC: {tvoc}")
            oled.set_row(1, f"eCO2: {eco2} ppm")
        except Exception as e:
            print(f"Sensor read error: {e}")
            oled.set_row(0, "Read Error")
            oled.set_row(1, "ENS160 Failed")
    else:
        # Sensor was never initialized
        print(f"Uptime: {uptime}s | Sensor not available")
        # Keep row 0 and 1 as set during init failure

    oled.set_row(2, f"Uptime: {uptime}s")

    # Sensor typically updates every 1 second
    time.sleep(1)
