-------------------------------------------------------------------------------
-- IMPORTS
-------------------------------------------------------------------------------
local wibox         = require("wibox")
local awful         = require("awful")
local beautiful     = require("beautiful")
local naughty       = require("naughty")
local gears         = require("gears")
local cairo         = require("lgi").cairo
local module_path = (...):match ("(.+/)[^/]+$") or ""

local theme = beautiful.get()

local volume = {}

-------------------------------------------------------------------------------
-- WORKER FUNCTION
-------------------------------------------------------------------------------
local function worker(args)
    ---------------------------------------------------------------------------
    -- ARGUMENTS
    ---------------------------------------------------------------------------
    local args = args or {}
    
    local timeout = args.timeout or 5
    local card = args.card or 0
    local use_buttons = args.use_buttons or false
    local keys = args.keys or nil
    local play = args.play or ""

    ---------------------------------------------------------------------------
    -- ICONS
    ---------------------------------------------------------------------------
    local icon_dir = gears.filesystem.get_configuration_dir() .. "/"
        .. module_path .. "/icons/"

    local icons = {
        wibox.widget.imagebox(icon_dir .. "volume-on.png"),
        wibox.widget.imagebox(icon_dir .. "volume-off.png"),
        wibox.widget.imagebox(icon_dir .. "volume-mute.png"),
    }

    ---------------------------------------------------------------------------
    -- WIDGET DEFINITION
    ---------------------------------------------------------------------------
    local volume_widget = wibox.widget {
        layout = wibox.layout.fixed.horizontal,
        {
            widget = wibox.container.margin,
            margins = 6,
        },
        {
            widget = wibox.widget.textbox
        },
    }
   
    ---------------------------------------------------------------------------
    -- UPDATE WIDGET PERIODICALLY
    ---------------------------------------------------------------------------
    local function update_widget(widget, stdout)
        local volume_level = string.match(stdout, '(%-?%d+)%%')
        local unmuted = string.match(stdout, '%[(o[nf]+)%]')
        local children = widget:get_children()
        if volume_level ~= nil then 
            if unmuted == "off" then
                children[1]:set_widget(icons[3])
            elseif tonumber(volume_level) > 0 then
                children[1]:set_widget(icons[1])
            else
                children[1]:set_widget(icons[2])
            end
            children[2]:set_text(volume_level .. "%")
        else
            children[2]:set_text("Vol:Err")
        end
    end

    awful.widget.watch("amixer -D pulse sget Master ", timeout, 
    function(widget, stdout)
        update_widget(widget, stdout)
    end, volume_widget)

    ---------------------------------------------------------------------------
    -- CLICK FUNCTION
    ---------------------------------------------------------------------------
    volume_widget:buttons(gears.table.join(
        awful.button({}, 1, function()
            local f = io.popen("amixer -D pulse sget Master ")
            local str = "amixer -D pulse sget Master"
            for line in f:lines() do
                str = str .. "\n" .. line
            end
            naughty.notify {
                preset = naughty.config.presets.normal,
                title = "Volume Info",
                text = str
            }
        end)
    ))

    volume_widget.force_update = function(self)
        awful.spawn.easy_async_with_shell(
            "amixer -D pulse sget Master", 
            function(stdout, stderr, exr, exc)
                update_widget(volume_widget, stdout)
            end
        )
    end

    return volume_widget
end

return setmetatable(
    volume, 
    {__call = function(_, ...) return worker(...) end}
)
