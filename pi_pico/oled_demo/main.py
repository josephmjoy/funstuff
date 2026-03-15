"""
Pico OLED Demo Main Entry Point
Demonstrates real-time uptime tracking and multi-row text rendering on an SSD1306 OLED.
Configured for Raspberry Pi Pico (GP0/GP1) and 128x32 resolution.
"""
import board
import busio
import time
import sys
from display import Display

# 1. Get CircuitPython version for display
ver, *_ = sys.implementation.version

# 2. Setup I2C (GP1 = SCL, GP0 = SDA on Raspberry Pi Pico)
i2c = busio.I2C(board.GP1, board.GP0)

# 3. Initialize the refactored Display object
# Parameters: i2c_bus, address, height, width, nlines
oled = Display(i2c, 0x3C, 32, 128, 3)

# 4. Set initial text rows
oled.set_rows([
    "Pico Dev System",
    f"CircuitPython {ver}.x",
    "Uptime: 0s"
])

# 5. Dynamic update loop
print(f"Starting display loop (v{ver}.x)...")
start_time = time.monotonic()

while True:
    uptime = int(time.monotonic() - start_time)
    oled.set_row(2, f"Uptime: {uptime}s")
    time.sleep(1)
