#I2C통신, 비트조작, 수학연산, 시간 관련된 라이브러리
from smbus2 import SMBus
from bitstring import Bits
import math
import time
import RPi.GPIO as GPIO
 
bus = SMBus(1)
DEV_ADDR = 0x68 #MPU6050 센서 주소

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
 
def get_y_rotation(x,y,z):
    radians = math.atan(y/dist(x,z))
    return radians

def get_y_rotation(x, y, z):
    radians = math.atan2(y, x) 
    degrees = math.degrees(radians)
    if degrees < 0:
        degrees += 360 
    elif degrees >= 360:
        degrees -= 360
    return degrees
 
bus.write_byte_data(DEV_ADDR,0x6B,0b00000000)
 
GPIO.setmode(GPIO.BCM)

LED = 23

GPIO.setup(LED, GPIO.OUT, initial=GPIO.LOW)
 
try:
    while True:
        x = read_data(register_accel_xout_h)
        y = read_data(register_accel_yout_h)
        z = read_data(register_accel_zout_h)
        aY = get_y_rotation(accel_g(x),accel_g(y),accel_g(z))
        data = str(aX) + ' , ' + str(aY) + '$'
 
				# 1.5707963267948966라디안(90도) 회전 시, LED 점등
        if aY > 1.5707963267948966:
            print("on LED")
            GPIO.output(LED, GPIO.HIGH)
        else:
            GPIO.output(LED, GPIO.LOW)
 
        print(data)
        time.sleep(0.3)
except KeyboardInterrupt:
    print("\nInterrupted!")
except:
    print("\nClosing socket")
finally:
    bus.close()
GPIO.cleanup()