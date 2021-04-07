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

local memory = {}

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
    local memory_widget = wibox.widget {
        layout = wibox.layout.fixed.horizontal,
        {
            widget = wibox.container.margin,
            margins = 6,
            wibox.widget.imagebox(icon_dir .. "memory.png")
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
            local meminfo_file = io.open("/proc/meminfo", "r")
            local meminfo = meminfo_file:read("*a")
            meminfo_file:close()
            local memtotal  = string.match(meminfo, "MemTotal: +(%d+)")
            local memfree   = string.match(meminfo, "MemFree: +(%d+)")
            local membuffer = string.match(meminfo, "Buffers: +(%d+)")
            local memcache  = string.match(meminfo, "Cached: +(%d+)")
            local memsrec   = string.match(meminfo, "SReclaimable: +(%d+)")
            local used = memtotal - memfree - membuffer - memcache - memsrec
            if used ~= nil then
                memory_widget:get_children()[2]:set_text(
                    math.ceil(used / 1024) .. "MiB"
                )
            else
                memory_widget:get_children()[2]:set_text("Err")
            end
        end
    }


    ---------------------------------------------------------------------------
    -- CLICK FUNCTION
    ---------------------------------------------------------------------------
    memory_widget:buttons(gears.table.join(
        awful.button({}, 1, function()
            local f = io.popen("free --mebi")
            local str = "free"
            for line in f:lines() do
                str = str .. "\n" .. line
            end
            str = str .. "\nRight click to open htop."
            naughty.notify {
                preset = naughty.config.presets.normal,
                title = "Memory Info",
                text = str
            }
        end),
        awful.button({}, 3, function()
            awful.spawn('alacritty -e htop')
        end)
    ))

    return memory_widget
end

return setmetatable(
    memory, 
    {__call = function(_, ...) return worker(...) end}
)
