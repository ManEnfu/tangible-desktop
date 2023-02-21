-------------------------------------------------------------------------------
-- IMPORTS
-------------------------------------------------------------------------------
local wibox         = require("wibox")
local awful         = require("awful")
local beautiful     = require("beautiful")
local naughty       = require("naughty")
local gears         = require("gears")
local module_path = (...):match ("(.+/)[^/]+$") or ""

local theme = beautiful.get()

local cpu = {}

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
    local cpu_widget = wibox.widget {
        layout = wibox.layout.fixed.horizontal,
        cached_total = 0,
        cached_active = 0,
        {
            widget = wibox.container.margin,
            margins = 6,
            wibox.widget.imagebox(icon_dir .. "cpu.png")
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
            local stat_file = io.open("/proc/stat", "r")
            local line = stat_file:read()
            stat_file:close()
            columns = {}
            for i in string.gmatch(line, "[%s]+([^%s]+)") do
                table.insert(columns, i)
            end
            local total = 0
            for i = 1, #columns do
                total = total + columns[i]
            end
            local active = total - columns[4] - columns[5]
            local dt = total - cpu_widget.cached_total
            local da = active - cpu_widget.cached_active
            if dt == 0 then dt = 0.00001 end

            cpu_widget:get_children()[2]:set_text(
                math.floor((da / dt) * 100) .. "%"
            )
            cpu_widget.cached_total = total
            cpu_widget.cached_active = active
        end
    }


    ---------------------------------------------------------------------------
    -- CLICK FUNCTION
    ---------------------------------------------------------------------------
    cpu_widget:buttons(gears.table.join(
        awful.button({}, 3, function()
            awful.spawn('alacritty -e htop')
        end)
    ))

    return cpu_widget
end

return setmetatable(
    cpu, 
    {__call = function(_, ...) return worker(...) end}
)
