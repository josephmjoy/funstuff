"""
SSD1306 OLED Display Management Module
Handles initialization and text rendering for 128x32 I2C displays on Raspberry Pi Pico.
Supports CircuitPython 8.x - 10.x through dynamic I2CDisplayBus imports.
"""

import sys

import busio
import displayio
import terminalio
from adafruit_display_text import label
import adafruit_displayio_ssd1306 as ssd1306

# Dynamic imports for I2CDisplayBus based on CircuitPython version
ver, *_ = sys.implementation.version
if ver >= 9:
    from i2cdisplaybus import I2CDisplayBus
else:
    from displayio import I2CDisplay as I2CDisplayBus

# Module-wide constants
BORDER = 2
FONT = terminalio.FONT


class Display:
    def __init__(
        self,
        i2c_bus: busio.I2C,
        device_address: int,
        height: int,
        width: int,
        nlines: int,
    ) -> None:
        """
        Initialize the OLED display manager.

        :param i2c_bus: The initialized I2C bus object.
        :param device_address: The I2C address of the SSD1306 (typically 0x3C).
        :param height: Display height in pixels (e.g., 32).
        :param width: Display width in pixels (e.g., 128).
        :param nlines: Number of text rows to manage.
        """
        self._nlines = nlines
        self._height = height
        self._width = width

        # Release any resources currently in use for the display
        displayio.release_displays()

        # Initialize display bus and driver
        self._display_bus = I2CDisplayBus(i2c_bus, device_address=device_address)
        self._display = ssd1306.SSD1306(self._display_bus, width=width, height=height)

        # Create the main group
        self._splash = displayio.Group()
        self._display.root_group = self._splash

        # Draw border if configured
        if BORDER > 0:
            # Outer white frame
            bg_bitmap = displayio.Bitmap(width, height, 1)
            bg_palette = displayio.Palette(1)
            bg_palette[0] = 0xFFFF
            bg_sprite = displayio.TileGrid(bg_bitmap, pixel_shader=bg_palette, x=0, y=0)
            self._splash.append(bg_sprite)

            # Inner black area
            inner_w = width - (BORDER * 2)
            inner_h = height - (BORDER * 2)
            inner_bitmap = displayio.Bitmap(inner_w, inner_h, 1)
            inner_palette = displayio.Palette(1)
            inner_palette[0] = 0x0000
            inner_sprite = displayio.TileGrid(
                inner_bitmap, pixel_shader=inner_palette, x=BORDER, y=BORDER
            )
            self._splash.append(inner_sprite)

        # Setup labels for text rows
        self._labels = []
        usable_height = height - (2 * BORDER)
        step = usable_height / nlines

        for i in range(nlines):
            # Calculate vertical position (y).
            # Using 0.75 weight to align closer to original manual placement.
            y_pos = int(BORDER + (i + 0.75) * step)
            lbl = label.Label(FONT, text="", color=0xFFFF, x=BORDER + 3, y=y_pos)
            self._splash.append(lbl)
            self._labels.append(lbl)

    def set_row(self, row: int, text: str) -> None:
        """
        Set the text of a specific row.

        :param row: Zero-indexed row number.
        :param text: String to display in the row.
        :raises ValueError: If the row index is out of range.
        """
        if row < 0 or row >= self._nlines:
            raise ValueError(f"Row index {row} out of range (0-{self._nlines - 1})")
        self._labels[row].text = text

    def set_rows(self, rows: list[str | None]) -> None:
        """
        Set multiple rows of text at once.

        :param rows: List of strings (or None to skip a row).
        :raises ValueError: If the list length exceeds the number of display rows.
        """
        if len(rows) > self._nlines:
            raise ValueError(
                f"List length {len(rows)} exceeds number of "
                f"display rows ({self._nlines})"
            )

        for i, text in enumerate(rows):
            if text is not None:
                self.set_row(i, text)

    def clear_rows(self) -> None:
        """
        Clear all text rows on the display.
        """
        for lbl in self._labels:
            lbl.text = ""
