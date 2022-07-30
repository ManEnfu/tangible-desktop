local gears = require("gears")
local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")

local function bind_key(group, mods, key, action, desc)
    _action = action
    if type(action) == "string" then
        _action = function() awful.spawn.with_shell(action) end
    end
    return awful.key(
        mods, key, _action,
        { description = desc, group = group })
end

local function key_group(group, keybinds)
    local ret = {}
    for _, spec in pairs(keybinds) do
        local kb = bind_key(group, spec[1], spec[2], spec[3], spec[4])
        for _, v in pairs(kb) do
            table.insert(ret, v)
        end
    end
    return ret
end

local M = { "Mod4" }
local MS = { "Mod4", "Shift" }
local MC = { "Mod4", "Control" }
local A = { "Mod1" }
local S = { "Shift" }

local vol_up = "XF86AudioRaiseVolume"
local vol_down = "XF86AudioLowerVolume"
local vol_mute = "XF86AudioMute"
local br_up = "XF86MonBrightnessUp"
local br_down = "XF86MonBrightnessDown"

local scripts = "~/.config/scripts/"

-------------------------------------------------------------------------------
-- GENERAL
-------------------------------------------------------------------------------

local function toggle_bar()
    local screen = awful.screen.focused()
    screen.mytoppanel.visible = not screen.mytoppanel.visible
end

globalkeys = key_group ("general", {
    { MS, "r", awesome.restart, "reload" },
    { MS, "q", awesome.quit, "quit" },
    { M,  "s", hotkeys_popup.show_help, "show keybinds" },
    { M,  "b", toggle_bar, "toggle top panel" },
})

-------------------------------------------------------------------------------
-- LAUNCHER
-------------------------------------------------------------------------------

globalkeys = gears.table.join(globalkeys, key_group ("launcher", {
    { M,  "Return", terminal, "open terminal" },
    { M,  "p",      "~/.config/scripts/run-menu drun", "show app launcher" },
    { MS, "p",      "~/.config/scripts/run-menu power", "show logout menu" },
    { MC, "p",      "~/.config/scripts/run-menu pass", "show password manager menu" },
    { M,  "r",      "~/.config/scripts/run-menu run", "show run prompt" },
    { M,  "o",      "~/.config/scripts/run-menu drun", "show window selector" },
    { MS, "o",      "~/.config/scripts/run-menu drun", "show file explorer" },
    { MS, "i",      "~/.config/scripts/run-menu ambient", "show ambient sound selector" },
    { M,  "a",      "pcmanfm-qt", "open file manager" },
    { M,  "c",      scripts .. "pick-color.sh", "show color picker" },
}))

-------------------------------------------------------------------------------
-- LAYOUT
-------------------------------------------------------------------------------

local function sel_layout(i)
    return function() awful.layout.inc(i) end
end

globalkeys = gears.table.join(globalkeys, key_group ("launcher", {
    { M,  "space", sel_layout(1),  "select next layout" },
    { MS, "space", sel_layout(-1), "select previous layout" },
}))

-------------------------------------------------------------------------------
-- WINDOW
-------------------------------------------------------------------------------

local function focus_idx(i)
    return function() awful.client.focus.byidx(i) end
end

local function swap_idx(i)
    return function() awful.client.swap.byidx(i) end
end

local function focus_master()
    client.focus = awful.client.getmaster()
    if client.focus then
        client.focus:raise()
    end
end

local function fact(x)
    return function() awful.tag.incmwfact(x) end
end

local function nmaster(x)
    return function() awful.tag.incnmaster(x) end
end

local function kill_window()
    local c = client.focus
    if c then
        c:kill()
    end
end

local function toggle_fullscreen()
    local c = client.focus
    if c then
        c.fullscreen = not c.fullscreen
        c:raise()
    end
end

local function toggle_floating()
    local c = client.focus
    if c then
        c.floating = not c.floating
    end
end

local function toggle_maximized()
    local c = client.focus
    if c then
        c.maximized = not c.maximized
        c:raise()
    end
end

local function minimize()
    local c = client.focus
    if c then
        c.minimized = true
    end
end

local function move_to_master()
    local c = client.focus
    if c then
        c:swap(awful.client.getmaster())
    end
end

globalkeys = gears.table.join(globalkeys, key_group ("window", {
    { MS, "c",      kill_window,        "close window" },
    { MS, "Return", move_to_master,     "move to master window" },
    { MC, "Return", focus_master,       "focus master window" },
    { M,  "j",      focus_idx(1),       "focus next by index" },
    { M,  "k",      focus_idx(-1),      "focus previous by index" },
    { M,  "Tab",    focus_idx(1),       "cycle windows" },
    { A,  "Tab",    focus_idx(1),       "focus previously focused window" },
    { MS, "j",      swap_idx(1),        "swap with next by index" },
    { MS, "k",      swap_idx(-1),       "swap with previous by index" },
    { M,  "h",      fact(-0.05),        "shrink master area" },
    { M,  "l",      fact(0.05),         "grow master area" },
    { MS, "h",      nmaster(1),         "shrink master area" },
    { MS, "l",      nmaster(-1),        "grow master area" },
    { M,  "f",      toggle_fullscreen,  "toggle fullscreen" },
    { M,  "m",      toggle_maximized,   "(un)maximize" },
    { M,  "n",      minimize,           "minimize" },
}))

-------------------------------------------------------------------------------
-- TAG
-------------------------------------------------------------------------------

local function switch_tag(i)
    return function ()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
            tag:view_only()
        end
    end
end

local function move_to_tag(i)
    return function ()
        if client.focus then
            local tag = client.focus.screen.tags[i]
            if tag then
                client.focus:move_to_tag(tag)
            end
        end
    end
end

local function toggle_tag(i)
    return function ()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
            awful.tag.viewtoggle(tag)
        end
    end
end

globalkeys = gears.table.join(globalkeys, key_group ("tag", {
    { M, "Left",  awful.tag.viewprev, "previous tag" },
    { M, "Right", awful.tag.viewnext, "next tag" },
}))

for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys, key_group("tag", {
        { M,  "#" .. i + 9, switch_tag(i),  "switch to tag" .. i },
        { MS, "#" .. i + 9, move_to_tag(i), "move window to tag" .. i },
        { MC, "#" .. i + 9, toggle_tag(i),  "toggle tag" .. i },
    }))
end


-- key_group ("screen", {
--     {}
-- })

-------------------------------------------------------------------------------
-- SCREENSHOT
-------------------------------------------------------------------------------

globalkeys = gears.table.join(globalkeys, key_group ("screenshot", {
    { {}, "Print", scripts .. "screenshot.sh", "take screenshot"},
    { S,  "Print", scripts .. "screenshot-select.sh", "take screenshot"},
}))

-------------------------------------------------------------------------------
-- VOLUME AND MEDIA
-------------------------------------------------------------------------------

globalkeys = gears.table.join(globalkeys, key_group ("volume and media", {
    { {}, vol_down, scripts .. "vol lower",  "lower volume"},
    { {}, vol_up,   scripts .. "vol raise",  "raise volume"},
    { {}, vol_mute, scripts .. "vol toggle", "toggle volume"},
    { M,  "[",      scripts .. "vol lower",  "lower volume"},
    { M,  "]",      scripts .. "vol raise",  "raise volume"},
    { M,  "\\",     scripts .. "vol toggle", "toggle volume"},
    { MS, "[",      scripts .. "player prev",  "play previous"},
    { MS, "]",      scripts .. "player next",  "play next"},
    { MS, "\\",     scripts .. "player toggle", "(un)pause"},
}))

-------------------------------------------------------------------------------
-- BRIGHTNESS
-------------------------------------------------------------------------------

local function toggle_nightmode()
    awesome.emit_signal("signal::nightmode")
end

globalkeys = gears.table.join(globalkeys, key_group ("brightness", {
    { {}, br_down, scripts .. "brightness lower", "lower brightness"},
    { {}, br_up,   scripts .. "brightness raise", "raise brightness"},
    { MC, "[",     scripts .. "brightness lower", "lower brightness"},
    { MC, "]",     scripts .. "brightness raise", "raise brightness"},
    { M,  "'",     toggle_nightmode,              "toggle nightmode"},
}))

root.keys(globalkeys)

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)
