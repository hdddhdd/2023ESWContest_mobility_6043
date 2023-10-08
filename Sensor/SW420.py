import RPi.GPIO as GPIO
import time

def Crash_D():
    GPIO.setmode(GPIO.BCM)

    PIN_NUM = 24
    CHECK_ON = 1

    GPIO.setup(PIN_NUM, GPIO.IN)

    if GPIO.input(PIN_NUM)==CHECK_ON:
        GPIO.cleanup()
        return True
    GPIO.cleanup()
    return False
