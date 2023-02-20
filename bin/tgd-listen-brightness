#!/usr/bin/env python3

# Listens to brightness change events and output its state in JSON format to be 
# consumed by EWW widgets.

from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler, FileModifiedEvent
import sys
import time

brightness_file = '/sys/class/backlight/intel_backlight/brightness'
max_brightness_file = '/sys/class/backlight/intel_backlight/max_brightness'

max_brightness = 0

with open(max_brightness_file, 'r') as f:
    max_brightness = int(f.read())
    f.close()

def notify():
    with open(brightness_file, 'r') as f:
        brightness = int(f.read())
        f.close()
        brightness = round(brightness * 100 / max_brightness)
        print(brightness, flush = True)

class BrightnessHandler(FileSystemEventHandler):
    def on_modified(self, event):
        # return super().on_modified(event)
        if isinstance(event, FileModifiedEvent):
            notify()

handler = BrightnessHandler()
observer = Observer()

notify()

observer.schedule(handler, path=brightness_file)
observer.start()
try:
    while True:
        time.sleep(1)
except:
    observer.stop()

observer.join()

