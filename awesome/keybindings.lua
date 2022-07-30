-------------------------------------------------------------------------------
-- IMPORTS
-------------------------------------------------------------------------------
local gears = require("gears")
local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")

-------------------------------------------------------------------------------
-- GLOBAL KEYBINDINGS
-------------------------------------------------------------------------------
root.buttons(gears.table.join(
    -- awful.button({ }, 3, function () mymainmenu:toggle() end)
    -- awful.button({ }, 4, awful.tag.viewnext),
    -- awful.button({ }, 5, awful.tag.viewprev)
))

globalkeys = gears.table.join(
    ---------------------------------------------------------------------------
    -- AWESOME
    ---------------------------------------------------------------------------
    awful.key({ modkey, "Shift"   }, "r",
        awesome.restart,
        {description = "reload awesome", group = "awesome"}
    ),

    awful.key({ modkey, "Shift"   }, "q",
        awesome.quit,
        {description = "quit awesome", group = "awesome"}
    ),

    awful.key({ modkey }, "b",
        function()
            local screen = awful.screen.focused()
            screen.mytoppanel.visible = not screen.mytoppanel.visible
        end,
        {description = "toggle top panel", group = "awesome"}
    ),

    awful.key({ modkey,           }, "s",
        hotkeys_popup.show_help,
        {description="show help", group="awesome"}
    ),

    awful.key({ modkey,           }, "w",
        function ()
            mymainmenu:show()
        end,
        {description = "show main menu", group = "awesome"}
    ),

    awful.key({ modkey }, "x",
        function ()
            awful.prompt.run {
                prompt       = "Run Lua code: ",
                textbox      = awful.screen.focused().mypromptbox.widget,
                exe_callback = awful.util.eval,
                history_path = awful.util.get_cache_dir() .. "/history_eval"
            }
        end,
        {description = "lua execute prompt", group = "awesome"}
    ),

    awful.key({ modkey }, "v",
        function()
            local screen = awful.screen.focused()
            screen.mybotpanel.visible = not screen.mybotpanel.visible
        end,
        {description = "toggle bottom panel", group = "awesome"}
    ),

    awful.key({ }, "XF86AudioRaiseVolume",
        function()
            awful.spawn.with_shell(
                "~/.config/scripts/vol-raise.sh"
            )
        end,
        {description = "volume up", group = "awesome"}
    ),

    awful.key({ modkey }, "]",
        function()
            awful.spawn.with_shell(
                "~/.config/scripts/vol-raise.sh"
            )
        end,
        {description = "volume up", group = "awesome"}
    ),

    awful.key({ }, "XF86AudioLowerVolume",
        function()
            awful.spawn.with_shell(
                "~/.config/scripts/vol-lower.sh"
            )
        end,
        {description = "volume down", group = "awesome"}
    ),

    awful.key({ modkey }, "[",
        function()
            awful.spawn.with_shell(
                "~/.config/scripts/vol-lower.sh"
            )
        end,
        {description = "volume down", group = "awesome"}
    ),

    awful.key({ }, "XF86AudioMute", function()
            awful.spawn.with_shell(
                "~/.config/scripts/vol-toggle.sh"
            )
        end,
        {description = "volume (un)mute", group = "awesome"}
    ),

    awful.key({ modkey }, "\\", function()
            awful.spawn.with_shell(
                "~/.config/scripts/vol-toggle.sh"
            )
        end,
        {description = "volume (un)mute", group = "awesome"}
    ),

    awful.key({ modkey, "Shift" }, "]", function()
            awful.spawn.with_shell(
                "~/.config/scripts/player-next.sh"
            )
        end,
        {description = "play next", group = "awesome"}
    ),

    awful.key({ modkey, "Shift" }, "[", function()
            awful.spawn.with_shell(
                "~/.config/scripts/player-prev.sh"
            )
        end,
        {description = "play previous", group = "awesome"}
    ),

    awful.key({ modkey, "Shift" }, "\\", function()
            awful.spawn.with_shell(
                "~/.config/scripts/player-toggle.sh"
            )
        end,
        {description = "play/pause", group = "awesome"}
    ),

    awful.key({ }, "XF86MonBrightnessUp", function()
            awful.spawn.with_shell(
                "~/.config/scripts/brightness-raise.sh"
            )
        end,
        {description = "brightness up", group = "awesome"}
    ),

    awful.key({ }, "XF86MonBrightnessDown", function()
            awful.spawn.with_shell(
                "~/.config/scripts/brightness-lower.sh"
            )
        end,
        {description = "brightness up", group = "awesome"}
    ),

    awful.key({ modkey, "Control" }, "]", function()
            awful.spawn.with_shell(
                "~/.config/scripts/brightness-raise.sh"
            )
        end,
        {description = "brightness up", group = "awesome"}
    ),

    awful.key({ modkey, "Control" }, "[", function()
            awful.spawn.with_shell(
                "~/.config/scripts/brightness-lower.sh"
            )
        end,
        {description = "brightness up", group = "awesome"}
    ),

    awful.key({ modkey }, "'", function()
            awesome.emit_signal("signal::nightmode")
        end,
        {description = "toggle nightmode", group = "awesome"}
    ),

    ---------------------------------------------------------------------------
    -- CLIENT
    ---------------------------------------------------------------------------
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),

    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j",
        function ()
            awful.client.swap.byidx(  1)
        end,
        {description = "swap with next client by index", group = "client"}
    ),

    awful.key({ modkey, "Shift"   }, "k",
        function ()
            awful.client.swap.byidx( -1)
        end,
        {description = "swap with previous client by index", group = "client"}
    ),

    awful.key({ modkey,           }, "u",
        awful.client.urgent.jumpto,
        {description = "jump to urgent client", group = "client"}
    ),

    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.byidx(1)
        end,
        {description = "cycle clients", group = "client"}
    ),

    awful.key({ "Mod1",           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "previously focused client clients", group = "client"}
    ),

    awful.key({ modkey, "Control"   }, "Return",
        function ()
            client.focus = awful.client.getmaster()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "focus master client", group = "client"}
    ),

    awful.key({ modkey, "Control" }, "n",
        function ()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                c:emit_signal(
                    "request::activate", "key.unminimize", {raise = true}
                )
            end
        end,
        {description = "restore minimized", group = "client"}
    ),

    ---------------------------------------------------------------------------
    -- LAYOUT
    ---------------------------------------------------------------------------
    awful.key({ modkey,           }, "l",
        function ()
            awful.tag.incmwfact( 0.05)
        end,
        {description = "increase master width factor", group = "layout"}
    ),

    awful.key({ modkey,           }, "h",
        function ()
            awful.tag.incmwfact(-0.05)
        end,
        {description = "decrease master width factor", group = "layout"}
    ),

    awful.key({ modkey, "Shift"   }, "h",
        function ()
            awful.tag.incnmaster( 1, nil, true)
        end,
        {
            description = "increase the number of master clients",
            group = "layout"
        }
    ),

    awful.key({ modkey, "Shift"   }, "l",
        function ()
            awful.tag.incnmaster(-1, nil, true)
        end,
        {
            description = "decrease the number of master clients",
            group = "layout"
        }
    ),

    awful.key({ modkey, "Control" }, "h",
        function ()
            awful.tag.incncol( 1, nil, true)
        end,
        {description = "increase the number of columns", group = "layout"}
    ),

    awful.key({ modkey, "Control" }, "l",
        function ()
            awful.tag.incncol(-1, nil, true)
        end,
        {description = "decrease the number of columns", group = "layout"}
    ),

    awful.key({ modkey,           }, "space",
        function ()
            awful.layout.inc( 1)
        end,
        {description = "select next", group = "layout"}
    ),

    awful.key({ modkey, "Shift"   }, "space",
        function () awful.layout.inc(-1)                end,
        {description = "select previous", group = "layout"}
    ),

    ---------------------------------------------------------------------------
    -- TAG
    ---------------------------------------------------------------------------
    awful.key({ modkey,           }, "Left",
        awful.tag.viewprev,
        {description = "view previous", group = "tag"}
    ),

    awful.key({ modkey,           }, "Right",
        awful.tag.viewnext,
        {description = "view next", group = "tag"}
    ),

    awful.key({ modkey,           }, "Escape",
        awful.tag.history.restore,
        {description = "go back", group = "tag"}
    ),

    ---------------------------------------------------------------------------
    -- WINDOW
    ---------------------------------------------------------------------------

    ---------------------------------------------------------------------------
    -- TAG
    ---------------------------------------------------------------------------

    ---------------------------------------------------------------------------
    -- SCREEN
    ---------------------------------------------------------------------------
    awful.key({ modkey, "Control" }, "j",
        function ()
            awful.screen.focus_relative( 1)
        end,
        {description = "focus the next screen", group = "screen"}
    ),

    awful.key({ modkey, "Control" }, "k",
        function ()
            awful.screen.focus_relative(-1)
        end,
        {description = "focus the previous screen", group = "screen"}
    ),

    ---------------------------------------------------------------------------
    -- LAUNCHER
    ---------------------------------------------------------------------------
    awful.key({ modkey,           }, "Return",
        function ()
            awful.spawn(terminal)
        end,
        {description = "open a terminal", group = "launcher"}
    ),

    awful.key({ modkey }, "p",
        function()
            awful.spawn.with_shell("~/.config/rofi/rofi-drun.sh")
        end,
        {description = "show applications", group = "launcher"}
    ),

    awful.key({ modkey, "Shift" }, "p",
        function()
            awful.spawn.with_shell("~/.config/rofi/rofi-power.sh")
        end,
        {description = "show power options", group = "launcher"}
    ),

    awful.key({ modkey, "Control" }, "p",
        function()
            awful.spawn.with_shell("~/.config/rofi/rofi-pass.sh")
        end,
        {description = "show password manager", group = "launcher"}
    ),

    awful.key({ modkey }, "r",
        function ()
            awful.spawn.with_shell("rofi -modi drun,run,window,ssh -show run")
        end,
        {description = "run prompt", group = "launcher"}
    ),

    awful.key({ modkey }, "o",
        function()
            awful.spawn.with_shell(
                "rofi -modi drun,run,window,ssh -show window"
            )
        end,
        {description = "show open windows", group = "launcher"}
    ),

    awful.key({ modkey, "Shift" }, "o",
        function()
            awful.spawn.with_shell(
                "rofi -modi drun,run,window,ssh,filebrowser -show filebrowser"
            )
        end,
        {description = "file quick open", group = "launcher"}
    ),

    awful.key({ modkey, "Shift" }, "i",
        function()
            awful.spawn.with_shell("~/.config/rofi/rofi-ambient.sh")
        end,
        {description = "play ambient sounds", group = "launcher"}
    ),

    awful.key({ modkey }, "a",
        function()
            awful.spawn.with_shell(
                "pcmanfm-qt"
            )
        end,
        {description = "show applications", group = "launcher"}
    ),

    awful.key({ modkey }, "c",
        function()
            awful.spawn.with_shell(
                "~/.config/scripts/pick-color.sh"
            )
        end,
        {description = "show applications", group = "launcher"}
    ),


    ---------------------------------------------------------------------------
    -- SCREENSHOT
    ---------------------------------------------------------------------------
    awful.key({ }, "Print",
        function ()
            awful.spawn.with_shell("~/.config/scripts/screenshot.sh")
        end,
        {description = "take screenshot", group = "screenshot" }
    ),

    awful.key({ "Shift" }, "Print", nil,
        function ()
            awful.spawn.with_shell("~/.config/scripts/screenshot-select.sh")
        end,
        {description = "take screenshot", group = "screenshot" }
    ),

    ---------------------------------------------------------------------------
    -- VOLUME AND MEDIA CONTROL
    ---------------------------------------------------------------------------
    
    awful.key({ modkey,           }, "f",
        function ()
            local c = client.focus
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}
    )

    ---------------------------------------------------------------------------
    -- BRIGHTNESS AND LIGHT FILTER
    ---------------------------------------------------------------------------
)

-------------------------------------------------------------------------------
-- CLIENT KEYBINDINGS
-------------------------------------------------------------------------------
clientkeys = gears.table.join(
    -- awful.key({ modkey,           }, "f",
    --     function (c)
    --         c.fullscreen = not c.fullscreen
    --         c:raise()
    --     end,
    --     {description = "toggle fullscreen", group = "client"}
    -- ),

    awful.key({ modkey, "Shift"   }, "c",
        function (c)
            c:kill()
        end,
        {description = "close", group = "client"}
    ),

    awful.key({ modkey, "Control" }, "space",
        awful.client.floating.toggle,
        {description = "toggle floating", group = "client"}
    ),

    awful.key({ modkey, "Shift"   }, "Return",
        function (c)
            c:swap(awful.client.getmaster())
        end,
        {description = "move to master", group = "client"}
    ),

    awful.key({ modkey,           }, "o",
        function (c)
            c:move_to_screen()
        end,
        {description = "move to screen", group = "client"}
    ),

    awful.key({ modkey,           }, "t",
        function (c)
            c.ontop = not c.ontop
        end,
        {description = "toggle keep on top", group = "client"}
    ),

    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}
    ),

    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}
    ),

    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}
    ),

    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"}
    )

)

-------------------------------------------------------------------------------
-- TAG KEYBINDINGS
-------------------------------------------------------------------------------
-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
            function ()
                  local screen = awful.screen.focused()
                  local tag = screen.tags[i]
                  if tag then
                     tag:view_only()
                  end
            end,
            {description = "view tag #"..i, group = "tag"}
        ),

        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
            function ()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                   awful.tag.viewtoggle(tag)
                end
            end,
            {description = "toggle tag #" .. i, group = "tag"}
        ),

        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
            function ()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
               end
            end,
            {description = "move focused client to tag #"..i, group = "tag"}
        ),

        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
            function ()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            {
                description = "toggle focused client on tag #" .. i,
                group = "tag"
            }
        )
    )
end

-------------------------------------------------------------------------------
-- CLIENT MOUSECLICK BEHAVIOR
-------------------------------------------------------------------------------
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

-- Set keys
root.keys(globalkeys)
-- }}}
