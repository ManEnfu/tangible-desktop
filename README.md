# tangible-desktop

Desktop configuration for various window managers.

### Awesome
![Awesome](./docs/screenshot-awesome.png)

### Hyprland
![Hyprland](./docs/screenshot-hyprland.png)

## Requirements

### General 
- `alacritty`: terminal emulator
- `rofi`: run launcher
- `gcolor3`: color chooser & picker
- `pactl`: volume control
- `networkmanagerapplet`
- `lxsession`: Policykit client
- `playerctl`: media player controller
- `libinput-gestures`: enable gestures for X 
- `libnotify`: send notifications 
- Fonts
    - Ubuntu
    - Ubuntu Nerd Font
    - JetBrainsMono Nerd Font
    - TangibleIcons (available in `fonts` folder)
- Themes (optional)
    - Kvantum: Qt theme engine
    - Materia GTK theme
    - Materia Kvantum them
    - Tela icon theme
    - Quintom cursor theme

### X11
- One of these window managers:
    - `awesome`
- `feh`: image viewer & background setter
- `redshift`: night light
- `picom`: X compositor
- `scrot`: screenshot
- `wmctrl`: control window manager
- `xclip`: clipboard

### Wayland
- One of these window managers:
    - `Hyprland`
- `python` with packages:
    - `pulsectl`
    - `watchdog`
- `waybar`: panel
- `eww`: panel & widgets
- `wl-clipboard`: clipboard
- `grim` and `slurp`: screenshot
- `pipewire`, `wireplumber`, and `xdg-desktop-portal-wlr`: screenshare

## Keybindings

### General

| Keybind | Action |
| :---    | :---   |
| <kbd>Super + Shift + R</kbd>  | Reload |
| <kbd>Super + Shift + Q</kbd>  | Quit |
| <kbd>Super + B</kbd>          | Toggle panel |

### Launcher

| Keybind | Action |
| :---    | :---   |
| <kbd>Super + Enter</kbd>      | Open terminal |
| <kbd>Super + P</kbd>          | Show app launcher |
| <kbd>Super + Shift + P</kbd>  | Show logout menu |
| <kbd>Super + Ctrl + P</kbd>   | Show password manager menu |
| <kbd>Super + R</kbd>          | Show run prompt |
| <kbd>Super + O</kbd>          | Show window selector |
| <kbd>Super + Shift + O</kbd>  | Show file explorer |
| <kbd>Super + Shift + I</kbd>  | Show ambient sound selector |
| <kbd>Super + A</kbd>          | Show file manager |
| <kbd>Super + C</kbd>          | Show color picker |

### Window

| Keybind | Action |
| :---    | :---   |
| <kbd>Super + Shift + C</kbd>      | Close window |
| <kbd>Super + Shift + Enter</kbd>  | Swap master window |
| <kbd>Super + Ctrl + Enter</kbd>   | Focus master window |
| <kbd>Super + J</kbd>              | Focus next window |
| <kbd>Super + K</kbd>              | Focus previous window |
| <kbd>Super + Tab</kbd>            | Cycle windows |
| <kbd>Alt + Tab</kbd>              | Focus previously focused window |
| <kbd>Super + Shift + J</kbd>      | Swap with next window |
| <kbd>Super + Shift + K</kbd>      | Swap with previous window |
| <kbd>Super + H</kbd>              | Shrink master area |
| <kbd>Super + L</kbd>              | Grow master area |

### Workspace / Tag

| Keybind | Action |
| :---    | :---   |
| <kbd>Super + [Num]</kbd>          | Switch to workspace/tag |
| <kbd>Super + Shift + [Num]</kbd>  | Move window to workspace/tag |
| <kbd>Super + Ctrl + [Num]</kbd>   | Toggle tag |
| <kbd>Super + Left</kbd>           | Switch to previous workspace/tag |
| <kbd>Super + Right</kbd>          | Switch to next workspace/tag |

### Screenshot

| Keybind | Action |
| :---    | :---   |
| <kbd>Print</kbd>          | Take screenshot |
| <kbd>Shift + Print</kbd>  | Take screenshot (select area) |

### Volume and Media Control

| Keybind | Action |
| :---    | :---   |
| <kbd>Super + [</kbd>          | Lower volume |
| <kbd>Super + ]</kbd>          | Raise volume |
| <kbd>Super + \\</kbd>         | Toggle volume |
| <kbd>Super + Shift + [</kbd>  | Play previous |
| <kbd>Super + Shift + ]</kbd>  | Play next |
| <kbd>Super + Shift + \\</kbd> | Play/pause current |

### Brightness and Light Filter

| Keybind | Action |
| :---    | :---   |
| <kbd>Super + Shift + [</kbd>  | Play previous |
| <kbd>Super + Shift + ]</kbd>  | Play next |
| <kbd>Super + '</kbd>          | Toggle blue light filter |

## Gestures

| Gesture | Action |
| :---    | :---   |
| Three finger swipe left   | Next workspace/tag |
| Three finger swipe right  | Previous workspace/tag |
| Three finger swipe up     | Application launcher |
