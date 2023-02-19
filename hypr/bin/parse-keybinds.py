#!/usr/bin/env python3

import os
import re

home = os.environ['HOME']
desc = ''

with open(os.path.join(home, '.config/hypr/hyprland.conf')) as f:
    for line in f.readlines():
        if line[:2] == '# ':
            desc = line[2:-1]
        bind = re.match(r'^bind *= *(\w*) *, *(\w*) *,.*', line)
        if bind is not None:
            tokens = bind.groups()
            mod = tokens[0]
            key = tokens[1].replace(' ', '')
            if len(mod) == 0:
                print(f'%s\t| %s'%(key, desc))
            else:
                print(f'%s + %s\t| %s'%(mod, key, desc))
