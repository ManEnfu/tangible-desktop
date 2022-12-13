#!/usr/bin/env python3

import os

# xdg_data_dirs = os.environ["XDG_DATA_DIRS"].split(":")

# icon_dirs: list[str] = list()
# for d in xdg_data_dirs:
#     id = os.path.join(d, "icons")
#     if os.path.isdir(id):
#         icon_dirs.append(id)

        
# print(icon_dirs)

# theme = "Tela-dark"

# def get_icon_path(theme: str, window_class: str):
    
#     pass

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


icon_theme = IconTheme("Tela-dark")
print(icon_theme.icon_dirs)
print(icon_theme.window("zathura"))
print(icon_theme.window("kitty"))
print(icon_theme.window("firefox"))

