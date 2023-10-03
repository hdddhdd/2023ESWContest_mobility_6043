from smbus2 import SMBus
from bitstring import Bits
import math
import time
import RPi.GPIO as GPIO

DEV_ADDR = 0x68
CMD = False
previous_aY = 0
count = 0
LeftT = 0

register_accel_xout_h = 0x3B
register_accel_yout_h = 0x3D
register_accel_zout_h = 0x3F
sensitive_accel = 16384.0

def read_data(register):
    high = bus.read_byte_data(DEV_ADDR,register)
    low = bus.read_byte_data(DEV_ADDR,register+1)
    val = (high << 8) + low
    return val

def twocomplements(val):
    s = Bits(uint=val,length=16)
    return s.int

def accel_g(val):
    return twocomplements(val)/sensitive_accel

def dist(a,b):
    return math.sqrt((a*a)+(b*b))

def get_y_rotation(x, y, z):
    radians = math.atan2(y,x)
    degrees = math.degrees(radians)
    return degrees

def MPU():
    global bus, DEV_ADDR, register_accel_xout_h, register_accel_yout_h, register_accel_zout_h, CMD, previous_aY, count, LeftT
    bus = SMBus(1)
    bus.write_byte_data(DEV_ADDR,0x6B,0b00000000)
    x = read_data(register_accel_xout_h)
    y = read_data(register_accel_yout_h)
    z = read_data(register_accel_zout_h)
    aY = get_y_rotation(accel_g(x),accel_g(y),accel_g(z))
    data = str(aY)
    bus.close()
    if LeftT > 0:
        if previous_aY - aY > 180:
            LeftT -= 1
            previous_aY = aY
            return False, round(aY, 2)
        elif previous_aY - aY < -180:
            LeftT += 1
            previous_aY = aY
            return False, round(aY, 2)
    if count > 0:
        if previous_aY - aY < -180:
            count -= 1
        elif previous_aY - aY > 180:
            count += 1
        previous_aY = aY
        return True, round(aY, 2)
    if aY > 0 and LeftT == 0:
        if previous_aY - aY < -180:
            LeftT = 1
            previous_aY = aY
            return False, round(aY, 2)
        CMD = True
        previous_aY = aY
        return True, round(aY, 2) 
    elif previous_aY - aY > 180 and CMD == True:
        count += 1
        previous_aY = aY
        return True, round(aY, 2)
    CMD = False
    previous_aY = aY
    return False, round(aY, 2)