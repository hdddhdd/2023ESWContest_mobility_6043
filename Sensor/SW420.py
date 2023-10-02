import RPi.GPIO as GPIO
import time

GPIO.setmode(GPIO.BCM)

PIN_NUM = 24
LED = 26
CHECK_ON = 1

GPIO.setup(PIN_NUM, GPIO.IN)
GPIO.setup(LED, GPIO.OUT)

PREV_TIME=time.time()
CUR_TIME=time.time()

try:
    i=0
    while True:
        CUR_TIME=time.time()
        if GPIO.input(PIN_NUM)==CHECK_ON:
            i=i+1
        if CUR_TIME-PREV_TIME > 5:
            if i > 20:
                GPIO.output(LED,GPIO.HIGH)
            else:
                GPIO.output(LED,GPIO.LOW)
            PREV_TIME=time.time()
            print("COUNT: ",i)
            i=0
        time.sleep(0.01)
finally:
    GPIO.cleanup()