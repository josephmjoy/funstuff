import board
import busio
import displayio
import terminalio
import sys
import time
from adafruit_display_text import label
import adafruit_displayio_ssd1306 as ssd1306

# 1. Handle CircuitPython version-specific imports for I2C bus
ver, *_ = sys.implementation.version
if ver >= 9:
    from i2cdisplaybus import I2CDisplayBus
else:
    from displayio import I2CDisplay as I2CDisplayBus

# 2. Release any resources currently in use for the display
displayio.release_displays()

# 3. Setup I2C (GP0 = SDA, GP1 = SCL on Raspberry Pi Pico)
i2c = busio.I2C(board.GP1, board.GP0)

# 4. Define display dimensions and bus
WIDTH = 128
HEIGHT = 32  # Standard for many Pico OLED hats
BORDER = 2

display_bus = I2CDisplayBus(i2c, device_address=0x3C)
display = ssd1306.SSD1306(display_bus, width=WIDTH, height=HEIGHT)

# 5. Create a Display Group and background
splash = displayio.Group()
display.root_group = splash

# Draw a simple border if requested
if BORDER > 0:
    # Outer white frame
    bg_bitmap = displayio.Bitmap(WIDTH, HEIGHT, 1)
    bg_palette = displayio.Palette(1)
    bg_palette[0] = 0xFFFF  # White
    bg_sprite = displayio.TileGrid(bg_bitmap, pixel_shader=bg_palette, x=0, y=0)
    splash.append(bg_sprite)

    # Inner black area
    inner_w = WIDTH - (BORDER * 2)
    inner_h = HEIGHT - (BORDER * 2)
    inner_bitmap = displayio.Bitmap(inner_w, inner_h, 1)
    inner_palette = displayio.Palette(1)
    inner_palette[0] = 0x0000  # Black
    inner_sprite = displayio.TileGrid(inner_bitmap, pixel_shader=inner_palette, x=BORDER, y=BORDER)
    splash.append(inner_sprite)

# 6. Create text labels with improved spacing
label1 = label.Label(terminalio.FONT, text="Pico Dev System", color=0xFFFF, x=BORDER+3, y=8)
splash.append(label1)

label2 = label.Label(terminalio.FONT, text=f"CircuitPython {ver}.x", color=0xFFFF, x=BORDER+3, y=18)
splash.append(label2)

label3 = label.Label(terminalio.FONT, text="Uptime: 0s", color=0xFFFF, x=BORDER+3, y=28)
splash.append(label3)

# 7. Dynamic update loop
print(f"Starting display loop (v{ver}.x)...")
start_time = time.monotonic()

while True:
    uptime = int(time.monotonic() - start_time)
    label3.text = f"Uptime: {uptime}s"
    time.sleep(1)
