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

local sensors = {}

-------------------------------------------------------------------------------
-- WORKER FUNCTION
-------------------------------------------------------------------------------
local function worker(args)
    ---------------------------------------------------------------------------
    -- ARGUMENTS
    ---------------------------------------------------------------------------
    local args = args or {}

    local timeout = args.timeout or 2

    ---------------------------------------------------------------------------
    -- ICONS
    ---------------------------------------------------------------------------
    local icon_dir = gears.filesystem.get_configuration_dir() .. "/"
        .. module_path .. "/icons/"

    ---------------------------------------------------------------------------
    -- WIDGET DEFINITION
    ---------------------------------------------------------------------------
    local sensors_widget = wibox.widget {
        layout = wibox.layout.fixed.horizontal,
        {
            widget = wibox.container.margin,
            margins = 4,
            wibox.widget.imagebox(icon_dir .. "temperature.png")
        },
        {
            widget = wibox.widget.textbox
        },
    }
    
    ---------------------------------------------------------------------------
    -- UPDATE WIDGET PERIODICALLY
    ---------------------------------------------------------------------------
    gears.timer {
        timeout = timeout,
        call_now = true,
        autostart = true,
        callback = function()
            local temp_file = io.open(
                "/sys/class/thermal/thermal_zone0/temp"
            )
            local temp = temp_file:read()
            temp_file:close()
            sensors_widget:get_children()[2]:set_text(tonumber(temp)/1000 .. "°C")
        end
    }


    ---------------------------------------------------------------------------
    -- CLICK FUNCTION
    ---------------------------------------------------------------------------
    sensors_widget:buttons(gears.table.join(
        awful.button({}, 1, function()
            local f = io.popen("sensors")
            local str = "sensors"
            for line in f:lines() do
                str = str .. "\n" .. line
            end
            naughty.notify {
                preset = naughty.config.presets.normal,
                title = "Sensors Info",
                text = str
            }
        end)
    ))

    return sensors_widget
end

return setmetatable(
    sensors, 
    {__call = function(_, ...) return worker(...) end}
)
