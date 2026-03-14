# Pi Pico Demo using thei SSD1306 Oled display 
This version displays some text on the real Raspberry Pi. It won't work as-is
on the Wokwi simulator because the CircuitPython versions are different.
Perhaps get it to conditinally work on either by checking the version at run time - see `notes.md` on how to determine the version.

# Origin
I asked Gemini to create the code with this prompt:
> write a circuitpython demo program exercising the SSD1306 oled display with 128x32 pixel resolution. The demo should display some text in a 3-line display.

It got everything right except for one thing: It included a wrong library by mistake. It included `adafruit_ssd1306`  instead of `adafruit_displayio_ssd1306`.
The former is for buffer-based display and the latter is for a text-based display. The constructor name and constructor arguments are slightly different, which
took me some time to figure out.

The other thing I had to do to get this to work with Wokwiki is to
add the `requirements.txt` file, which contains two libraries that are not
added by default it seems:
> adafruit_displayio_ssd1306
> adafruit_display_text

With these changes, the simulator worked fine!

# Getting to work on real HW
The CircuitPython version on WokWi is 8.x while on the real device (via Thonny) it is 10.x. So needed to change how the `display_bus` was created. See `notes.md` for more info.
