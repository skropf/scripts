#!/usr/bin/python

import time
import RPi.GPIO as GPIO
import signal
import sys
import threading

# thread class just for moving the stepper motor
class StepperMotor(threading.Thread):
  def __init__(self, gpioPin, steps, speed):
    threading.Thread.__init__(self)
    self.gpioPin = gpioPin
    self.steps = steps
    self.speed = speed

  def run(self):
    GPIO.setwarnings(False)
    GPIO.setmode(GPIO.BOARD)
    GPIO.setup(self.gpioPin, GPIO.OUT)

    while self.steps > 0:
      GPIO.output(self.gpioPin, GPIO.HIGH)
      time.sleep(0.0004)
      GPIO.output(self.gpioPin, GPIO.LOW)
      time.sleep(self.speed)
      self.steps -= 1


motorList = []
motorPins = [29]#, 31, 33, 35]
steps = [6000, 500, 200, 60]
speeds = [0.005, 0.002, 0.005, 1]


for motorPin, step, speed in zip(motorPins, steps, speeds):
  print(str(motorPin) + "-" + str(step) + "-" + str(speed))
  motorList.append(StepperMotor(motorPin, step, speed))

#motorList[int(sys.argv[1])].start()
for motor in motorList:
  motor.start()


