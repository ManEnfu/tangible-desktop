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

local schedule = {}

-------------------------------------------------------------------------------
-- WORKER FUNCTION
-------------------------------------------------------------------------------
local function worker(args)
    ---------------------------------------------------------------------------
    -- ARGUMENTS
    ---------------------------------------------------------------------------
    local args = args or {}

    local timeout = args.timeout or 60
    local interface = args.interface or " "
    
    ---------------------------------------------------------------------------
    -- ICONS
    ---------------------------------------------------------------------------
    local icon_dir = gears.filesystem.get_configuration_dir() .. "/"
        .. module_path .. "/icons/"

    ---------------------------------------------------------------------------
    -- WIDGET DEFINITION
    ---------------------------------------------------------------------------
    schedule_widget = wibox.widget {
        layout = wibox.layout.fixed.horizontal,
        {
            widget = wibox.widget.textbox,
        },
    }

    ---------------------------------------------------------------------------
    -- UPDATE WIDGET PERIODICALLY
    ---------------------------------------------------------------------------
    awful.widget.watch("bash -c ~/.config/myschedule/myschedule.sh", timeout, 
    function(widget, stdout)
        local children = widget:get_children()
        stdout = string.gsub(stdout, "\n", "")
        children[1]:set_text("Schedule: " .. stdout)
    end, schedule_widget)

    return schedule_widget
end

return setmetatable(
    schedule, 
    {__call = function(_, ...) return worker(...) end}
)
