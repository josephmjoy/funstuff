# `Display` Class Documentation

The `Display` class provides a high-level interface for managing an SSD1306 OLED display (128x32) using CircuitPython's `displayio` and `adafruit_displayio_ssd1306` library. It handles the initialization of the I2C display bus, the display driver, and the management of multiple text rows.

## Class Structure

The following class diagram illustrates the internal structure of the `Display` class, including its private attributes and public methods.

```mermaid
classDiagram
    class Display {
        -int _nlines
        -int _height
        -int _width
        -I2CDisplayBus _display_bus
        -SSD1306 _display
        -Group _splash
        -list[Label] _labels
        +__init__(i2c_bus: I2C, device_address: int, height: int, width: int, nlines: int)
        +set_row(row: int, text: str) None
        +set_rows(rows: list[str | None]) None
        +clear_rows() None
    }
```

### Constructor

- **`Display(i2c_bus, device_address, height, width, nlines)`**:
    - `i2c_bus`: The initialized `busio.I2C` object.
    - `device_address`: The I2C address of the SSD1306 (typically `0x3C`).
    - `height`: Display height in pixels (e.g., `32`).
    - `width`: Display width in pixels (e.g., `128`).
    - `nlines`: Number of text rows to manage.

### Methods

- **`set_row(row: int, text: str)`**: Sets the text for a specific row (zero-indexed). Raises a `ValueError` if the row index is out of range.
- **`set_rows(rows: list[str | None])`**: Sets multiple rows at once. `None` values skip the corresponding row. Raises a `ValueError` if the list exceeds the number of lines.
- **`clear_rows()`**: Clears all text rows on the display.

---

## Typical Use Sequence

This sequence diagram shows a typical interaction between a main script (e.g., `main.py`) and the `Display` class, including initialization and periodic updates.

```mermaid
sequenceDiagram
    participant App as main.py
    participant I2C as busio.I2C
    participant D as Display Class
    participant HW as SSD1306 HW

    App->>I2C: Initialize (SCL, SDA)
    App->>D: Create Display(i2c, 0x3C, 32, 128, 3)
    activate D
    D->>D: release_displays()
    D->>D: Init I2CDisplayBus
    D->>D: Init SSD1306 Driver
    D->>D: Create root Group (splash)
    D->>D: Create Labels for 3 rows
    D->>HW: (Implicit) Initial rendering
    deactivate D

    loop Every 1 second
        App->>D: set_row(0, "AQI: 1")
        D->>D: Update Label 0 text
        D->>HW: (Implicit) Instant update
        
        App->>D: set_row(1, "eCO2: 400")
        D->>D: Update Label 1 text
        D->>HW: (Implicit) Instant update
        
        App->>D: set_row(2, "Uptime: 10s")
        D->>D: Update Label 2 text
        D->>HW: (Implicit) Instant update
    end
```

*(You can also view the standalone SVG version here: [display_sequence.svg](./images/display_sequence.svg))*

### Implementation Note
The `Display` class uses `displayio`, which handles automatic refresh. Therefore, updating a `Label` object's `text` attribute results in an instantaneous update to the physical display without needing an explicit `update()` or `refresh()` call.
