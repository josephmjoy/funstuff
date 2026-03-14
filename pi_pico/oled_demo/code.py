import board
import busio
import displayio
import terminalio
from adafruit_display_text import label
# import adafruit_ssd1306
import adafruit_displayio_ssd1306 as ssd1306
# 1. Release any resources currently in use for the display
displayio.release_displays()

# 2. Setup I2C (GP0 = SDA, GP1 = SCL)
i2c = busio.I2C(board.GP1, board.GP0)

# 3. Define display bus and dimensions
display_bus = displayio.I2CDisplay(i2c, device_address=0x3C)
WIDTH = 128
HEIGHT = 32  # Specified resolution
BORDER = 2
#print(dir(ssd1306))
display = ssd1306.SSD1306(display_bus, width=WIDTH, height=HEIGHT)

# 4. Create a Display Group to hold our text elements
splash = displayio.Group()
display.root_group = splash

# 5. Create three lines of text
# Line 1
text_line1 = "Pico Dev System"
label1 = label.Label(terminalio.FONT, text=text_line1, color=0xFFFF, x=5, y=5)
splash.append(label1)

# Line 2
text_line2 = "CircuitPython 9.x"
label2 = label.Label(terminalio.FONT, text=text_line2, color=0xFFFF, x=5, y=15)
splash.append(label2)

# Line 3
text_line3 = "Status: Running"
label3 = label.Label(terminalio.FONT, text=text_line3, color=0xFFFF, x=5, y=25)
splash.append(label3)

# The code will automatically stay on screen until updated or reset
while True:
    pass
