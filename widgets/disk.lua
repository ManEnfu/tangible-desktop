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

local disk = {}

-------------------------------------------------------------------------------
-- WORKER FUNCTION
-------------------------------------------------------------------------------
local function worker(args)
    ---------------------------------------------------------------------------
    -- ARGUMENTS
    ---------------------------------------------------------------------------
    local args = args or {}

    local timeout = args.timeout or 120
    
    ---------------------------------------------------------------------------
    -- ICONS
    ---------------------------------------------------------------------------
    local icon_dir = gears.filesystem.get_configuration_dir() .. "/"
        .. module_path .. "/icons/"

    local icons = {
        wibox.widget.imagebox(icon_dir .. "fs.png"),
    }

    ---------------------------------------------------------------------------
    -- WIDGET DEFINITION
    ---------------------------------------------------------------------------
    disk_widget = wibox.widget {
        layout = wibox.layout.fixed.horizontal,
        {
            widget = wibox.container.margin,
            margins = 6,
            icons[1]
        },
        {
            widget = wibox.widget.textbox
        },
    }

    ---------------------------------------------------------------------------
    -- UPDATE WIDGET PERIODICALLY
    ---------------------------------------------------------------------------
    awful.widget.watch("df -h", timeout, 
    function(widget, stdout)
        local children = widget:get_children()
        local sda, size, used = string.match(stdout, '(sda%d+) +(%d+%w) +(%d+%w)')
        children[2]:set_text(used .. '/' .. size)
    end, disk_widget)

    ---------------------------------------------------------------------------
    -- CLICK FUNCTION
    ---------------------------------------------------------------------------
    disk_widget:buttons(gears.table.join(
        awful.button({}, 1, function()
            local f = io.popen("df -h")
            local str = "df -h"
            for line in f:lines() do
                str = str .. "\n" .. line
            end
            naughty.notify {
                preset = naughty.config.presets.normal,
                title = "Disk Info",
                text = str
            }
        end)
    ))

    return disk_widget
end

return setmetatable(
    disk, 
    {__call = function(_, ...) return worker(...) end}
)
