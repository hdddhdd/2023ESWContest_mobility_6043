import RPi.GPIO as GPIO
import time

def Crash_D():
    GPIO.setmode(GPIO.BCM)

    PIN_NUM = 24
    CHECK_ON = 1

    GPIO.setup(PIN_NUM, GPIO.IN)

    if GPIO.input(PIN_NUM)==CHECK_ON:
        GPIO.cleanup()
        return "충돌이 감지되었습니다."
    GPIO.cleanup()
    return "평상시"