# sensor.py
import smbus
import time
from datetime import datetime
import csv
from threading import Thread, Lock

PWR_MGMT_1 = 0x6B
SMPLRT_DIV = 0x19
CONFIG = 0x1A
GYRO_CONFIG = 0x1B
INT_ENABLE = 0x38
ACCEL_XOUT_H = 0x3B
ACCEL_YOUT_H = 0x3D
ACCEL_ZOUT_H = 0x3F

Device_Address = 0x68
bus = smbus.SMBus(1)
lock = Lock()
latest_data = {}

def MPU_Init():
    bus.write_byte_data(Device_Address, SMPLRT_DIV, 7)
    bus.write_byte_data(Device_Address, PWR_MGMT_1, 1)
    bus.write_byte_data(Device_Address, CONFIG, 0)
    bus.write_byte_data(Device_Address, GYRO_CONFIG, 24)
    bus.write_byte_data(Device_Address, INT_ENABLE, 1)

def read_raw_data(addr):
    high = bus.read_byte_data(Device_Address, addr)
    low = bus.read_byte_data(Device_Address, addr + 1)
    value = (high << 8) | low
    if value > 32767:
        value -= 65536
    return value

def read_accel():
    ax = read_raw_data(ACCEL_XOUT_H) / 16384.0
    ay = read_raw_data(ACCEL_YOUT_H) / 16384.0
    az = read_raw_data(ACCEL_ZOUT_H) / 16384.0
    return ax, ay, az

def monitor():
    MPU_Init()
    with open("logs/data.csv", "a", newline="") as f:
        writer = csv.writer(f)
        writer.writerow(["timestamp", "Ax", "Ay", "Az"])
        while True:
            ax, ay, az = read_accel()
            timestamp = datetime.now().isoformat()
            with lock:
                latest_data.update({"Ax": ax, "Ay": ay, "Az": az, "timestamp": timestamp})
            writer.writerow([timestamp, ax, ay, az])
            f.flush()
            time.sleep(0.1)

def get_latest():
    with lock:
        return latest_data.copy()

# Lanza el hilo de monitoreo si se importa
Thread(target=monitor, daemon=True).start()
