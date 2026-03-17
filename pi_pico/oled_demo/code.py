"""
Pico OLED Demo Entry Point (code.py)
Standard auto-start script for CircuitPython.
Demonstrates ENS160 Air Quality sensor data on an SSD1306 OLED.
"""

import sys
import time

import board
import busio
import adafruit_ens160

from display import Display

# 1. Get CircuitPython version for display
ver, *_ = sys.implementation.version

# 2. Setup I2C (GP1 = SCL, GP0 = SDA on Raspberry Pi Pico)
i2c = busio.I2C(board.GP1, board.GP0)

# 3. Initialize the refactored Display object
# Parameters: i2c_bus, address, height, width, nlines
oled = Display(i2c, 0x3C, 32, 128, 3)

# 4. Initialize ENS160 Air Quality sensor
ens = adafruit_ens160.ENS160(i2c)
ens.temperature_compensation = 25
ens.humidity_compensation = 50

# 5. Set initial text rows
oled.set_rows([
    "ENS160 Air Quality",
    "Initializing sensor...",
    "Uptime: 0s"
])

# 6. Dynamic update loop
print(f"Starting display loop (v{ver}.x)...")
start_time = time.monotonic()

while True:
    uptime = int(time.monotonic() - start_time)
    
    # Read sensor values
    aqi = ens.AQI
    tvoc = ens.TVOC
    eco2 = ens.eCO2
    
    # Print to terminal
    print(f"Uptime: {uptime}s | AQI: {aqi} | TVOC: {tvoc} ppb | eCO2: {eco2} ppm")
    
    # Update OLED display
    oled.set_row(0, f"AQI: {aqi} | TVOC: {tvoc}")
    oled.set_row(1, f"eCO2: {eco2} ppm")
    oled.set_row(2, f"Uptime: {uptime}s")
    
    time.sleep(1)
