#!/usr/bin/env python3

# Listens to hyprland events and output its state in JSON format to be 
# consumed by EWW widgets.

import os
import socket
import json
from typing import Any

class IconTheme:
    def __init__(self, theme: str):
        self.icon_dirs: list[str]

        theme_dirs: list[str] = list()
        fallback_dirs: list[str] = list()
        
        xdg_data_dirs = os.environ["XDG_DATA_DIRS"].split(":")

        for d in xdg_data_dirs:
            id = os.path.join(d, "icons")
            if os.path.isdir(id):
                fallback_dirs.append(id)

        for d in fallback_dirs:
            td = os.path.join(d, theme, "scalable/apps")
            if os.path.isdir(td):
                theme_dirs.append(td)

        self.icon_dirs = theme_dirs + fallback_dirs
        
    def window(self, name: str) -> str:
        if name == '':
            return ''
        for dir in self.icon_dirs:
            for f in os.listdir(dir):
                if f.find(name) == 0:
                    return os.path.join(dir, f)
        return ""
    
    def desktop(self, name: str) -> str:
        for dir in self.icon_dirs:
            for f in os.listdir(dir):
                if f.find(name) == 0:
                    return os.path.join(dir, f)
        return ""

class Workspace:
    def __init__(self, name: str):
        self.name: str = name
        self.occupied: bool = False

    def get_css_class(self) -> str:
        return 'occupied ' if self.occupied else ''

class Monitor:
    def __init__(self, name: str, ws_names: list[str]):
        self.name: str = name
        self.workspaces_names: list[str] = ws_names
        self.active_workspace: str = ''
        self.workspaces: dict[str, Workspace] = dict()
        for ws_name in ws_names:
            self.workspaces[ws_name] = Workspace(ws_name)
        
    def set_active_workspace(self, ws_name: str):
        if ws_name in self.workspaces_names:
            self.active_workspace = ws_name

    def set_workspace_occupied(self, ws_name: str, value: bool):
        if ws_name in self.workspaces_names:
            self.workspaces[ws_name].occupied = value

    def get_workspace_css_class(self, ws_name: str) -> str:
        ret: str = self.workspaces[ws_name].get_css_class()
        if ws_name == self.active_workspace:
            ret += 'active '
        return ret

    def get_workspace_css_class_list(self) -> list[str]:
        ret: list[str] = [self.get_workspace_css_class(ws_name)
                          for ws_name in self.workspaces_names]
        for i in range(len(ret) - 1):
            if ret[i] != '' and ret[i+1] != '':
                ret[i] += 'close-right '
                ret[i+1] += 'close-left '
        return ret

class HyprlandState:
    def __init__(self, monitors_config: dict, icon_theme: IconTheme):
        self.monitors: dict[str, Monitor] = dict()
        self.active_monitor: str = ''
        self.active_window_class: str = ''
        self.active_window: str = ''
        self.submap: str = ''
        self.icon_theme: IconTheme = icon_theme
        for mon_name in monitors_config.keys():
            self.monitors[mon_name] = Monitor(mon_name, monitors_config[mon_name])

    def set_active_workspace(self, ws_name: str):
        for mon in self.monitors.values():
            mon.set_active_workspace(ws_name)

    def set_workspace_occupied(self, ws_name: str, value: bool):
        for mon in self.monitors.values():
            mon.set_workspace_occupied(ws_name, value)

    def set_active_window(self, title: str):
        if len(title) > 40:
            self.active_window = title[:40] + '...'
        else: 
            self.active_window = title

    def set_submap(self, submap: str):
        self.submap = submap

    def refresh(self):
        for mon in self.monitors.values():
            for ws in mon.workspaces.values():
                ws.occupied = False

        jmons: Any = HyprlandCommandSocket().request_json('monitors')
        for jmon in jmons:
            if jmon['name'] in self.monitors.keys():
                mon = self.monitors[jmon['name']]
                mon.active_workspace = jmon['activeWorkspace']['name']

        jwss: Any = HyprlandCommandSocket().request_json('workspaces')
        for jws in jwss:
            if jws['monitor'] in self.monitors.keys():
                mon = self.monitors[jws['monitor']]
                if jws['name'] in mon.workspaces.keys():
                    mon.workspaces[jws['name']].occupied = True

        jaw: Any = HyprlandCommandSocket().request_json('activewindow')
        if 'title' in jaw.keys():
            self.set_active_window(jaw['title'])
            self.active_window_class = jaw['class']
        else:
            self.set_active_window('')
            self.active_window_class = ''

    def to_json(self):
        ret: dict[str, Any] = {
            'activeWindowIcon' : self.icon_theme.window(self.active_window_class), 
            'activeWindow' : self.active_window,
            'submap': self.submap,
            'monitors': dict()
        }
        for mon_name in self.monitors.keys():
            ret['monitors'][mon_name] = \
                self.monitors[mon_name].get_workspace_css_class_list()
        return ret


class HyprlandCommandSocket:
    def __init__(self):
        self.hyprland_sig: str = os.environ['HYPRLAND_INSTANCE_SIGNATURE']
        self.sock: socket.socket = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        pass

    def request_json(self, command: str) -> Any:
        self.sock.connect('/tmp/hypr/{}/.socket.sock'.format(self.hyprland_sig))
        self.sock.send('j/{}'.format(command).encode('utf-8'))
        response: str = self.sock.recv(1024).decode('utf-8')
        self.sock.close()
        return json.loads(response)

class HyprlandEventSocket:
    def __init__(self):
        self.hyprland_sig: str = os.environ['HYPRLAND_INSTANCE_SIGNATURE']
        self.sock: socket.socket = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        self.sock.connect('/tmp/hypr/{}/.socket2.sock'.format(self.hyprland_sig))

    def listen(self, state: HyprlandState):
        events = self.sock.recv(4096).decode('utf-8')[:-1]
        for event in events.split('\n'):
            # print(event)
            etype, data = event.split('>>')

            if etype == 'workspace':
                state.set_active_workspace(data)
            elif etype == 'createworkspace':
                state.set_workspace_occupied(data, True)
            elif etype == 'destroyworkspace':
                state.set_workspace_occupied(data, False)
            elif etype == 'activewindow':
                state.set_active_window(str.join(", ", data.split(',')[1:]))
                state.active_window_class = data.split(',')[0]
            elif etype == 'closewindow':
                state.set_active_window('')
                state.active_window_class = ''
            elif etype == 'submap':
                state.set_submap(data)
        print(json.dumps(state.to_json()), flush=True)

# Configurations

config = {
    'eDP-1': ['1', '2', '3', '4', '5', '6', '7', '8', '9']
}

state = HyprlandState(config, IconTheme("Tela-dark"))
state.refresh()
print(json.dumps(state.to_json()), flush=True)

event_sock = HyprlandEventSocket()
while True:
    event_sock.listen(state)
