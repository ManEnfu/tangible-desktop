#!/usr/bin/env python3

from pulsectl import Pulse, PulseLoopStop
import json
import subprocess

def get_event_callback(index):
    def callback(ev):
        if ev.index == index:
            raise PulseLoopStop
    return callback

def get_sink_value(sink):
    return {
        'port': sink.port_active.name,
        'volume': round(sink.volume.value_flat * 100),
        'mute': sink.mute == 1,
    }

pulse = Pulse()

try:

    # List sinks
    sinks = {s.index: s for s in pulse.sink_list()}
    
    # Get default sink
    default_sink_name = pulse.server_info().default_sink_name
    try:
        default_sink_index = next(index for index, sink in sinks.items()
                                  if sink.name == default_sink_name)
    except StopIteration:
        raise StopIteration("No defaullt sink was found.");
    default_sink = sinks[default_sink_index]

    # Set up event listener
    pulse.event_mask_set('sink')
    pulse.event_callback_set(get_event_callback(default_sink_index))

    # Initialize sink info
    sink_value = get_sink_value(default_sink)
    print(json.dumps(sink_value), flush = True)

    while True:
        pulse.event_listen()

        # Update sink info
        default_sink = pulse.get_sink_by_name(default_sink_name)
        sink_value = get_sink_value(default_sink)
        print(json.dumps(sink_value), flush = True)

except:
    pass
    # subprocess.call("notify-send 'tg-listen-pulse' 'Listener exited unexpectedly.'", 
    #                 shell = True)
