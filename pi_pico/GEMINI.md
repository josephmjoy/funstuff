# Project: Raspberry Pi Pico Collection

This repository is a container for various experiments, demos, and tools built for the Raspberry Pi Pico and other microcontrollers using CircuitPython.

## Repository Structure

- `oled_demo/`: A project demonstrating the use of SSD1306 OLED displays (128x32).
- `skills/`: Custom Gemini skills developed for this workspace.
- `.gemini/`: Workspace-specific Gemini configurations and skill assets.

## General Mandates

- **CircuitPython Focus**: Most projects here target CircuitPython. Always check for a `requirements.txt` or `lib/` folder within subdirectories to understand specific dependencies.
- **Hardware Diversity**: While the Raspberry Pi Pico is the primary target, some projects may target other boards. Always look for board-specific configurations (e.g., `diagram.json` for Wokwi or `code.py` for hardware).
- **Subproject Autonomy**: Each subproject folder (like `oled_demo/`) should be treated as an independent environment. Respect the `GEMINI.md` files within those folders for project-specific rules.

## Development Workflow

1. **Research**: When working on a specific subproject, start by reading its local `GEMINI.md` and `README.md`.
2. **Simulation**: Use Wokwi (`diagram.json`) for initial testing when available.
3. **Deployment**: Real hardware testing should follow simulation to ensure safety and correctness.
