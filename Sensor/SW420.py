import RPi.GPIO as GPIO
import time

def Crash_D():
    GPIO.setmode(GPIO.BCM)

    PIN_NUM = 24
    CHECK_ON = 1

    GPIO.setup(PIN_NUM, GPIO.IN)

    count=0
    Start_T=time.time()
    
    while True:
        if GPIO.input(PIN_NUM)==CHECK_ON:
            count += 1
        Interval_T = time.time() - Start_T
        if Interval_T >= 0.5:
            break

    GPIO.cleanup()

    if count >= 10
        return True
    return False
