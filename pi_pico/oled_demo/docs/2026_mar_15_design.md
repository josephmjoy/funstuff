# March 15 Refactoring Design Document

March 15 Update:
- Based on Gemini's questions, display is updated instantaneously, so there is no separate `update()` method.

## Overview
Factor out display-related code into a separate module(file) called display.py.
The goal is to keep the main script simple, and also let me use the `display` module future programs.

## Current State
Currently all functionality lives in one file, `code.py`.

## Proposed Changes
In `display.py`, define a class called Display, that will be used in the main script (code.py).  Some public class
methods are below. Multiple displays must be supported, each with it's I2C ID. Therefore almost all display state
must be within the Display object.

### Constructor
 Note that the constructor takes the height and width, and number of lines. So all calculations have to refer to these
 input parameters. Appropriate private fields must be constructed.
```
    Display(display_bus, device_address:int, height: int, width: int, nlines: int)
    # where:
    #  - i2c_bus: The I2C bus. The caller will have typically created this using `busio.I2C(board.GP1, board.GP0)`.
    #  - display_address: The I2C address of the device on the bus.
    #  - height and width are the HW display size in pixels, and nlines is the number of lines in the display.
```

### Display Methods

```
    set_row(row: int, text: str) -> None
        # Sets the text for a specific row of the display.
        # Throw an exception of the row index is out of range (greater or equal to the number of display rows)
    
    set_rows(rows: list[str]) -> None
        # Sets the text for one or more rows the display.
        # rows[0] is the first row, and so on. A None value for a row means to keep the previous value in the internal
        # buffer. If the list is shorter than the number of rows in the display, leave the remaining row buffers
        # unchanged. If the length of the list is longer than number of rows, throw a ValueError exception.

    clear_rows() -> None
        # Clear all text.

```

### Implementation Notes
Note that the Display object is statefu: `setrows`, `setrow`  and `clearrows()`, update an internal buffer but
don't update the physical display, while `update()` and `clear()` actually updates the physical display.


## Verification Plan
`code.py` should be refactored so that it creates a single Display object and calls appropriate public methods to
preserve existing functionality, namely printing CircuitPython version info, an updating timer, and some other text.
