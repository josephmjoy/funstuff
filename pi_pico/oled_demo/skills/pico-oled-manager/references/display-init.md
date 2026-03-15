# Display Initialization (CircuitPython 9.x+)

## I2C Setup
For the Raspberry Pi Pico, standard I2C pins are:
- **GP0 (SDA)**, **GP1 (SCL)** -> `busio.I2C(board.GP1, board.GP0)`
- **GP4 (SDA)**, **GP5 (SCL)** -> `busio.I2C(board.GP5, board.GP4)`

### Troubleshooting Pins
If `busio.I2C` fails, check if another I2C peripheral is active on the same bus (Pico has I2C0 and I2C1).

## displayio Pattern (Modern)
Use this pattern for `adafruit_displayio_ssd1306`:

```python
import board
import busio
import displayio
import terminalio
from adafruit_display_text import label
import adafruit_displayio_ssd1306 as ssd1306

displayio.release_displays()

# Setup I2C (check pins)
i2c = busio.I2C(board.GP1, board.GP0)

# Display Bus
from i2cdisplaybus import I2CDisplayBus
display_bus = I2CDisplayBus(i2c, device_address=0x3c)

# Initialize Display
WIDTH = 128
HEIGHT = 64
display = ssd1306.SSD1306(display_bus, width=WIDTH, height=HEIGHT)
```

## legacy adafruit_ssd1306 Pattern
Use for simple graphics without `displayio`:

```python
import board
import busio
import adafruit_ssd1306

i2c = busio.I2C(board.GP1, board.GP0)
oled = adafruit_ssd1306.SSD1306_I2C(128, 64, i2c)
oled.fill(0)
oled.text("Hello!", 0, 0, 1)
oled.show()
```
