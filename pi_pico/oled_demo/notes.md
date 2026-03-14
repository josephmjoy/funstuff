D More recent notes come first.
## March 13, 2026
I dynamically define the `I2CDisplayBus` class as either from `displayio` (pre 9.x) or from i2cdisplay` where it is called `I2CDisplay`. CircuitPython version is determined by:
``
ver, *_ = sys.implementation.version
```
Also print the actual version. FStrings work in CircuitPython!

## March 13, 2026
Changes from the previous version (which worked on Wokwi simulator):
> Needed to add libraries to Thonny. To do this, lookup
The packages in question were:
> adafruit_display_text
> adafruit_ssd1306
To add these packages (and any dependencies automatically), you have to open `Tools->Manage Packages`, and type the name of each package, and click on the button on the top right that says "Search micropython-lib and PyPl". But note that `_circuitpython` has been inserted into the package name:
> adafruit_circuitpython_display_text 
> adafruit_circuitpython_displayio_ssd1306 

To find the library, you can search CircuitPython documentation, found here: https://docs.circuitpython.org/projects/bundle/en/latest/drivers.html

That page does have a TOC, *however* it also lists every driver, so you can simply search within that page. When you click on a page, you may find the package listed as a `pip install` command, like so: `pip3 install adafruit-circuitpython-displayio-ssd1306`. Of course, you don't run the command, but rather specify the package name in the search box for the Thonny package manager mentioned earlier.
## How to determine Circuit Python version programatically
This is to ensure we are using the correct version of the libraries. This is the CircuitPython image.
```
>>> import os
>>> print(os.uname())
>>> 
```
It prints this on Thonny:
```
(sysname='rp2040', nodename='rp2040', release='10.1.4', version='10.1.4 on 2026-03-09', machine='Raspberry Pi Pico with rp2040')

```
And this on Wokwi:
```
(sysname='rp2040', nodename='rp2040', release='8.0.2', version='8.0.2 on 2023-02-14', machine='Raspberry Pi Pico with rp2040')
```

## Changes to code moving from Wokwi to the real device on Thonny.
Note that thge CircuitPython version is 8.0.2 on Wokwi and 10.1.4 on the real device. Some libraries have changed. Notably, bus-related code has moved out from the `displayio` package and into `i2cdisplaybus`, and usage is slightly different. From:
> display_bus = displayio.I2CDisplay(i2c, device_address=0x3C)
To
> display_bus = i2cdisplaybus.I2CDisplayBus(i2c, device_address=0x3C)




