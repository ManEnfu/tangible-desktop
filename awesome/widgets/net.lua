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

local net = {}

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
        wibox.widget.imagebox(icon_dir .. "net-up.png"),
        wibox.widget.imagebox(icon_dir .. "net-down.png"),
    }

    ---------------------------------------------------------------------------
    -- WIDGET DEFINITION
    ---------------------------------------------------------------------------
    net_widget = wibox.widget {
        cached_rx = -1,
        cached_tx = -1,
        layout = wibox.layout.fixed.horizontal,
        {
            widget = wibox.container.margin,
            margins = 6,
        },
        {
            widget = wibox.widget.textbox
        },
        {
            widget = wibox.widget.textbox
        },
    }

    ---------------------------------------------------------------------------
    -- UPDATE WIDGET PERIODICALLY
    ---------------------------------------------------------------------------
    -- awful.widget.watch("iwconfig " .. interface, timeout, 
    -- function(widget, stdout)
    --     local ssid = string.match(stdout, 'ESSID:"?(%w+)"?')
    --     local children = widget:get_children()
    --     if ssid ~= nil then
    --         if ssid == "off" then
    --             children[1]:set_widget(icons[2])
    --             children[2]:set_text("N/A")
    --         else
    --             local strength = string.match(stdout, 'Link Quality=(%d+)')
    --             children[1]:set_widget(icons[1])
    --             children[2]:set_text( 
    --                 math.ceil(tonumber(strength)*10/7) .. "%"
    --             )
    --         end
    --     else
    --         children[2]:set_text("Err")
    --     end
    -- end, net_widget)

    gears.timer {
        timeout = timeout,
        call_now = true,
        autostart = true,
        callback = function()
            local function readstat(path)
                local file = io.open(path, "r")
                local line = file:read()
                file:close()
                return line
            end
            local children = net_widget:get_children()
            local state = readstat(
                string.format("/sys/class/net/%s/operstate", interface))
            if state == "up" then
                local rx = readstat(
                    string.format("/sys/class/net/%s/statistics/rx_bytes", interface))
                local tx = readstat(
                    string.format("/sys/class/net/%s/statistics/tx_bytes", interface))
                if net_widget.cached_rx == -1 then
                    net_widget.cached_rx = rx
                    net_widget.cached_tx = tx
                end
                local rx_rate = (rx - net_widget.cached_rx) / timeout / 1024
                local tx_rate = (tx - net_widget.cached_tx) / timeout / 1024
                local st = string.format("%.1f|%.1fK/s", rx_rate, tx_rate)
                children[1]:set_widget(icons[1])
                if tx_rate > 1024.0 then
                    children[2]:set_text(string.format("%.1fM/s | ", tx_rate / 1024))
                else
                    children[2]:set_text(string.format("%.1fK/s | ", tx_rate))
                end
                if rx_rate > 1024.0 then
                    children[3]:set_text(string.format("%.1fM/s", rx_rate / 1024))
                else
                    children[3]:set_text(string.format("%.1fK/s", rx_rate))
                end
                net_widget.cached_rx = rx
                net_widget.cached_tx = tx
            else
                children[1]:set_widget(icons[2])
                children[2]:set_text("0.0K/s | ")
                children[3]:set_text("0.0K/s")
            end
        end
    }

    ---------------------------------------------------------------------------
    -- CLICK FUNCTION
    ---------------------------------------------------------------------------

    return net_widget
end

return setmetatable(
    net, 
    {__call = function(_, ...) return worker(...) end}
)
