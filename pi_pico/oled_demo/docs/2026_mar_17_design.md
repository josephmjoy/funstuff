# Update to support the Adafruit ENS160 AQI QT sensor breakout board

## External References
- Overview: https://learn.adafruit.com/adafruit-ens160-mox-gas-sensor/circuitpython-python
- Reference: https://docs.circuitpython.org/projects/ens160/en/latest/
- Simple sample code: https://docs.circuitpython.org/projects/ens160/en/latest/examples.html
  - Prints a few items by polling the device
- Advanced sample code: https://docs.circuitpython.org/projects/ens160/en/latest/examples.html#advanced-test
  - Sets temperature and humidity compensation
  - Enables interrupt trigger
  - Displays all data

## Initial Objective
Add functionality to the existing project, which simply displays CircuitPython version and a timer on the Oled display,
to an environmental sensor package. In this first version it just polls the sensor and prints AQI information - this is displayed by both printing to the terminal and displing to the OLED display using the `Display` class.

This version of the code is simple, intended to demonstrate that the sensor works with CircuitPython on the Pi Pico.

## Implementation Guidelines
In this virst version keep all ENS160 code within the `main.py` class. So don't introduce any new modules.

