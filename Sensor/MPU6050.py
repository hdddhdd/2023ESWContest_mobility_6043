from smbus2 import SMBus
from bitstring import Bits
import math

DEV_ADDR = 0x68

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
    radians = math.atan(y/dist(x,z)) 
    degrees = math.degrees(radians)
    #if degrees < 0:
        #degrees += 360 
    #elif degrees >= 360:
        #degrees -= 360
    return degrees


def MPU():
    global bus, DEV_ADDR, register_accel_xout_h, register_accel_yout_h, register_accel_zout_h
    bus = SMBus(1)
    bus.write_byte_data(DEV_ADDR,0x6B,0b00000000)
    x = read_data(register_accel_xout_h)
    y = read_data(register_accel_yout_h)
    z = read_data(register_accel_zout_h)
    aY = get_y_rotation(accel_g(x),accel_g(y),accel_g(z))
    data = str(aY)
    bus.close()
    if aY > 90:
        return "우회전 입니다.", aY
    return "우회전이 아닙니다.", aY
