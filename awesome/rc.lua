-------------------------------------------------------------------------------
--
--  ------------------
--  |                |
--  -------------    |
--  -------------    |
--  |                |
--  |    --------    |
--  |    ------ |    |
--  |         | |    |
--  ----------- ------
--       AWESOME
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- IMPORTS
-------------------------------------------------------------------------------
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")

-- Widget collection
local widgets = require("widgets")
local custom_layout = require("layout")

local shapes = require("util.shapes")

-- for application menu
local has_fdo, freedesktop = pcall(require, "freedesktop")


-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
config_dir = gears.filesystem.get_configuration_dir()

beautiful.init(config_dir .. "theme.lua")
beautiful.notification_shape = shapes.roundedrect

-- This is used later as the default terminal and editor to run.
terminal = "alacritty"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, 
-- but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.floating,
    custom_layout.tilemax,
    awful.layout.suit.max,
    --awful.layout.suit.fair,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-------------------------------------------------------------------------------
-- WIDGETS
-------------------------------------------------------------------------------
myawesomemenu = {
    { "Hotkeys", 
        function() 
            hotkeys_popup.show_help(nil, awful.screen.focused()) 
        end 
    },
    { "Manual", terminal .. " -e man awesome" },
    { "Edit Config", editor_cmd .. " " .. awesome.conffile },
    { "Restart", awesome.restart },
    { "Quit", function() awesome.quit() end },
}


if has_fdo then
    mymainmenu = freedesktop.menu.build({
        before = { 
            { "Awesome", myawesomemenu, config_dir .. "/icons/awesome.png" },
        },
        after =  { 
            { "Open Terminal", terminal },
            { "Suspend","i3lock -c 242424 && sleep 0.5 && loginctl suspend" },
            { "Reboot", "loginctl reboot" },
            { "Power Off", "loginctl poweroff" }
        }
    })
else
    mymainmenu = awful.menu({ 
        items = { 
            { "Awesome", myawesomemenu, beautiful.awesome_icon },
            { "Applications", xdgmenu },
            { "Open Terminal", terminal },
            { "Suspend","i3lock -c 242424 && sleep 0.5 && loginctl suspend" },
            { "Reboot", "loginctl reboot" },
            { "Power Off", "loginctl poweroff" }
        },
    })
end

mylauncher = awful.widget.launcher({ 
    image = config_dir .. "/icons/artix-logo.png",                                 
    menu = mymainmenu 
})

-- Menubar configuration
-- Set the terminal for applications that require it
menubar.utils.terminal = terminal 

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- Panel Widgets
mycpu = widgets.cpu { timeout = 5 }
mymemory = widgets.memory { timeout = 5 }
mysensors = widgets.sensors { timeout = 7 }
mynet = widgets.net { timeout = 4, interface = "wlan0" }
myvolume = widgets.volume { 
    timeout = 3, 
    play = config_dir .. "/sound_click_tick.wav"
}
mybattery = widgets.battery { timeout = 3 }
myschedule = widgets.schedule { timeout = 60 }
mydisk = widgets.disk { timeout = 120 }
mynightmode = widgets.nightmode {}

-------------------------------------------------------------------------------
-- SCREEN
-------------------------------------------------------------------------------
awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    --set_wallpaper(s)

    -- Each screen has its own tag table.
    -- local tagnames = { "1", "2", "3", "4", "5", "6", "7", "8", "9" }
    local tagnames = { 
        "term1", "term2", "web", "web2", "file", 
        "media", "design", "game", "virt" 
    }
    -- awful.tag(
    --     { "1", "2", "3", "4", "5", "6", "7", "8", "9" }, 
    --     s, 
    --     awful.layout.layouts[1]
    -- )
    for i, tagname in ipairs(tagnames) do
        awful.tag.add(tagname, {
            icon = config_dir .. "/icons/" ..
                tagname .. ".png",
            layout = (tagname == "game" or tagname == "virt")
                and awful.layout.suit.max
                or awful.layout.suit.tile,
            screen = s,
            selected = i == 1,
            gap_single_client = 0
        })
    end

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an 
    -- icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({ }, 1, function () awful.layout.inc( 1) end),
        awful.button({ }, 3, function () awful.layout.inc(-1) end),
        awful.button({ }, 4, function () awful.layout.inc( 1) end),
        awful.button({ }, 5, function () awful.layout.inc(-1) end)))

    ---------------------------------------------------------------------------
    -- PANEL / WIBAR
    ---------------------------------------------------------------------------
    local top_panel = require ("components.top-panel")
    local bottom_panel = require ("components.bottom-panel")
    s.mytoppanel = top_panel {
        screen = s,
        widgets = {
            mynightmode,
            mycpu,
            mymemory,
            mydisk,
            mysensors,
            mynet,
            myvolume,
            mybattery,
        }
    }
    s.mybotpanel = bottom_panel {screen = s}
    s.mybotpanel.visible = false

end)

require("keybindings")

require("rules")

require("signals")

-- Autostart
awful.spawn.with_shell("~/.config/scripts/autostart.sh")

gears.timer {
    timeout = 20,
    call_now = true,
    autostart = true,
    callback = function()
        collectgarbage("collect")
        collectgarbage("collect")
    end
}

collectgarbage("setpause", 105)
collectgarbage("setstepmul", 1200)
