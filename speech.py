#!/usr/bin/python

import speech_recognition as sr


r = sr.Recognizer()
mic = sr.Microphone()

print(sr.Microphone.list_microphone_names())

with mic as source:
    audio = r.listen(source)

print(r.recognize_google(audio))
