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

local wifi = {}

-------------------------------------------------------------------------------
-- WORKER FUNCTION
-------------------------------------------------------------------------------
local function worker(args)
    ---------------------------------------------------------------------------
    -- ARGUMENTS
    ---------------------------------------------------------------------------
    local args = args or {}

    local timeout = args.timeout or 2
    local interface = args.interface or " "
    
    ---------------------------------------------------------------------------
    -- ICONS
    ---------------------------------------------------------------------------
    local icon_dir = gears.filesystem.get_configuration_dir() .. "/"
        .. module_path .. "/icons/"

    local icons = {
        wibox.widget.imagebox(icon_dir .. "wifi-on.png"),
        wibox.widget.imagebox(icon_dir .. "wifi-off.png"),
    }

    ---------------------------------------------------------------------------
    -- WIDGET DEFINITION
    ---------------------------------------------------------------------------
    wifi_widget = wibox.widget {
        layout = wibox.layout.fixed.horizontal,
        {
            widget = wibox.container.margin,
            margins = 4,
        },
        {
            widget = wibox.widget.textbox
        },
    }

    ---------------------------------------------------------------------------
    -- UPDATE WIDGET PERIODICALLY
    ---------------------------------------------------------------------------
    awful.widget.watch("iwconfig " .. interface, timeout, 
    function(widget, stdout)
        local ssid = string.match(stdout, 'ESSID:"?(%w+)"?')
        local children = widget:get_children()
        if ssid ~= nil then
            if ssid == "off" then
                children[1]:set_widget(icons[2])
                children[2]:set_text("N/A")
            else
                local strength = string.match(stdout, 'Link Quality=(%d+)')
                children[1]:set_widget(icons[1])
                children[2]:set_text(ssid .. " " .. 
                    math.ceil(tonumber(strength)*10/7) .. "%")
            end
        else
            children[2]:set_text("Err")
        end
    end, wifi_widget)

    ---------------------------------------------------------------------------
    -- CLICK FUNCTION
    ---------------------------------------------------------------------------
    wifi_widget:buttons(gears.table.join(
        awful.button({}, 1, function()
            local f = io.popen("iwconfig " .. interface)
            local str = "iwconfig " .. interface
            for line in f:lines() do
                str = str .. "\n" .. line
            end
            naughty.notify {
                preset = naughty.config.presets.normal,
                title = "Wireless Info",
                text = str
            }
        end)
    ))

    return wifi_widget
end

return setmetatable(
    wifi, 
    {__call = function(_, ...) return worker(...) end}
)
