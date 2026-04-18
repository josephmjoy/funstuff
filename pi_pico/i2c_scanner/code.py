import time
import board
import busio

# Create the I2C bus on Raspberry Pi Pico
# GP1 is SCL, GP0 is SDA for I2C0
i2c = busio.I2C(board.GP1, board.GP0)

print("I2C Scanner")

while not i2c.try_lock():
    pass

try:
    while True:
        print("Scanning...")
        devices = i2c.scan()
        if devices:
            print(f"I2C devices found: {[hex(device) for device in devices]}")
        else:
            print("No I2C devices found.")
        time.sleep(5)
finally:
    i2c.unlock()
