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

local apptitle = {}

-------------------------------------------------------------------------------
-- WORKER FUNCTION
-------------------------------------------------------------------------------
local function worker(args)
    ---------------------------------------------------------------------------
    -- ARGUMENTS
    ---------------------------------------------------------------------------
    local args = args or {}

    local timeout = args.timeout or 2
    local battery_arg = args.battery or "BAT0"
    local battery_path = "/sys/class/power_supply/" .. battery_arg .. "/"

    ---------------------------------------------------------------------------
    -- ICONS
    ---------------------------------------------------------------------------
    local icon_dir = gears.filesystem.get_configuration_dir() .. "/"
        .. module_path .. "/icons/"
    

    ---------------------------------------------------------------------------
    -- WIDGET DEFINITION
    ---------------------------------------------------------------------------
    apptitle_widget = wibox.widget {
        widget = wibox.widget.textbox,
        forced_width = 400,
        forced_height = 24
    }

    ---------------------------------------------------------------------------
    -- UPDATE WIDGET PERIODICALLY
    ---------------------------------------------------------------------------
    client.connect_signal("focus",
        function(c)
             apptitle_widget:set_text(c.name)   
        end
    )
    client.connect_signal("unfocus",
        function(c)
             apptitle_widget:set_text("")   
        end
    )
    client.connect_signal("manage",
        function(c)
             apptitle_widget:set_text(c.name)   
        end
    )
    client.connect_signal("unmanage",
        function()
             apptitle_widget:set_text("")   
        end
    )
    client.connect_signal("property::name",
        function(c)
            if c == client.focus then
                apptitle_widget:set_text(c.name)   
            end
        end
    )


    return apptitle_widget
end

return setmetatable(
    apptitle, 
    {__call = function(_, ...) return worker(...) end}
)
