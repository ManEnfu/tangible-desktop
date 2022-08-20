#!/usr/bin/env python3

import os
import socket
import json
import subprocess

class Workspace:
    def __init__(self, name):
        self.id = ''
        self.name = name
        self.occupied = False

    def get_class(self):
        return 'occupied ' if self.occupied else ''

class Monitor:
    def __init__(self, name, ws_names):
        self.workspaces = dict()
        for i in range(len(ws_names)):
            self.workspaces[ws_names[i]] = Workspace(ws_names[i])
        self.ws_names = ws_names
        self.name = name
        self.active_ws = ''
    
    def set_active_workspace(self, ws_name):
        if ws_name in self.ws_names:
            self.active_ws = ws_name
    
    def set_workspace_occupied(self, ws_name, v):
        if ws_name in self.ws_names:
            self.workspaces[ws_name].occupied = v

    def get_ws_class(self, name):
        ret = self.workspaces[name].get_class()
        if name == self.active_ws:
            ret += 'active '
        return ret

    def get_ws_classes(self):
        ret = [self.get_ws_class(ws_name)
               for ws_name in self.ws_names]
        for i in range(len(ret)-1):
            if ret[i] != '' and  ret[i+1] != '':
                ret[i] += 'close-right '
                ret[i+1] += 'close-left '
        return ret
        
    
    # def get_workspace_by_name(self, name):
    #     for ws in self.workspaces:
    #         if ws.name == name:
    #             return ws
    #     return None

class Summary:
    def __init__(self, config):
        self.monitors = dict()
        self.active_mon = ''
        self.active_win = ''
        for mon_name in config.keys():
            self.monitors[mon_name] = Monitor(mon_name, config[mon_name])

    # def get_workspace_by_name(self, name):
    #     for mon in self.monitors:
    #         ws = mon.get_workspace_by_name(name)
    #         if ws is not None:
    #             return ws
    #     return None

    def set_active_workspace(self, ws_name):
        for mon in self.monitors.values():
            mon.set_active_workspace(ws_name)
    
    def set_workspace_occupied(self, ws_name, v):
        for mon in self.monitors.values():
            mon.set_workspace_occupied(ws_name, v)

    def full_update(self):
        for mon in self.monitors.values():
            for ws in mon.workspaces.values():
                ws.occupied = False

        jmons = HyprlandCommandSocket().request_json('monitors')
        for jmon in jmons:
            if jmon['name'] in self.monitors.keys():
                mon = self.monitors[jmon['name']]
                mon.active_ws = jmon['activeWorkspace']['name']

        jwss = HyprlandCommandSocket().request_json('workspaces')
        for jws in jwss:
            if jws['monitor'] in self.monitors.keys():
                mon = self.monitors[jws['monitor']]
                if jws['name'] in mon.workspaces.keys():
                    mon.workspaces[jws['name']].occupied = True

        self.update_title()


    def update_title(self):
        jaw = HyprlandCommandSocket().request_json('activewindow')
        if 'title' in jaw.keys():
            self.set_active_window(jaw['title'])
        else:
            self.set_active_window('')

    def set_active_window(self, title):
        if len(title) > 40:
            self.active_win = title[:40] + '...'
        else:
            self.active_win = title

    
    def get_eww_json(self):
        ret = {
            'activeWindow' : self.active_win
        }
        for mon_name in self.monitors.keys():
            ret[mon_name] = self.monitors[mon_name].get_ws_classes()
        return ret
        

class HyprlandCommandSocket:
    def __init__(self):
        self.hyprland_sig = os.environ['HYPRLAND_INSTANCE_SIGNATURE']
        self._sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        pass

    def request_json(self, command):
        self._sock.connect('/tmp/hypr/{}/.socket.sock'.format(self.hyprland_sig))
        self._sock.send('j/{}'.format(command).encode('utf-8'))
        response = self._sock.recv(1024).decode('utf-8')
        self._sock.close()
        # response = subprocess.check_output('hyprctl {0} -j'.format(command), shell = True)\
        #     .decode('utf-8')
        return json.loads(response)


    # def on_workspace(self, data):
    #     pass

class HyprlandEventSocket:
    def __init__(self, summary):
        self.hyprland_sig = os.environ['HYPRLAND_INSTANCE_SIGNATURE']
        self._sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        self._sock.connect('/tmp/hypr/{}/.socket2.sock'.format(self.hyprland_sig))
        self.summary = summary

    def listen(self):
        events = self._sock.recv(4096).decode('utf-8')[:-1]
        for event in events.split('\n'):
            # print(event)
            etype, data = event.split('>>')

            if etype == 'workspace':
                self.summary.set_active_workspace(data)
                self.summary.update_title()
            elif etype == 'createworkspace':
                self.summary.set_workspace_occupied(data, True)
            elif etype == 'destroyworkspace':
                self.summary.set_workspace_occupied(data, False)
            elif etype == 'activewindow':
                self.summary.set_active_window(data.split(',')[1])
                self.summary.update_title()
        print(json.dumps(self.summary.get_eww_json()), flush=True)
    
    # def on_workspace(self, data):
    #     ws = self.summary.ws_names
    #     if ws:

    #     pass

    # def on_createworkspace(self, data):
    #     pass

    # def on_destroyspace(self, data):
    #     pass

    # def on_activewindow(self, data):
    #     pass

# if __name__ == '__main__':
config = {
    'eDP-1': ['1', '2', '3', '4', '5', '6', '7', '8', '9']
}
# command_sock = HyprlandCommandSocket()
summary = Summary(config)

summary.full_update()
print(json.dumps(summary.get_eww_json()), flush=True)

# print(command_sock.request_json('monitors'))
# print(command_sock.request_json('monitors'))

# Indefinitely listen to events
event_sock = HyprlandEventSocket(summary)
while True:
    event_sock.listen()
