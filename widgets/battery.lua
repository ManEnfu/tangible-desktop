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

local battery = {}

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
    
    local icons = {
        wibox.widget.imagebox(icon_dir .. "battery-0.png"),
        wibox.widget.imagebox(icon_dir .. "battery-1.png"),
        wibox.widget.imagebox(icon_dir .. "battery-2.png"),
        wibox.widget.imagebox(icon_dir .. "battery-3.png"),
        wibox.widget.imagebox(icon_dir .. "battery-4.png"),
        wibox.widget.imagebox(icon_dir .. "battery-charge-0.png"),
        wibox.widget.imagebox(icon_dir .. "battery-charge-1.png"),
        wibox.widget.imagebox(icon_dir .. "battery-charge-2.png"),
        wibox.widget.imagebox(icon_dir .. "battery-charge-3.png"),
        wibox.widget.imagebox(icon_dir .. "battery-charge-4.png"),
    }

    ---------------------------------------------------------------------------
    -- WIDGET DEFINITION
    ---------------------------------------------------------------------------
    batt_widget = wibox.widget {
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
    gears.timer {
        timeout = timeout,
        call_now = true,
        autostart = true,
        callback = function()
            local status_file = io.open(battery_path .. "status")
            local status = status_file:read()
            status_file:close()
            local charge_file = io.open(battery_path .. "capacity")
            local charge = charge_file:read()
            charge_file:close()
            local children = batt_widget:get_children()
            if status ~= nil then
                local charge_value = tonumber(charge)
                if status == "Charging" then
                    if charge_value >= 0 and charge_value < 12.5 then
                        children[1]:set_widget(icons[6])
                    elseif charge_value >= 12.5 and charge_value < 37.5 then
                        children[1]:set_widget(icons[7])
                    elseif charge_value >= 37.5 and charge_value < 62.5 then
                        children[1]:set_widget(icons[8])
                    elseif charge_value >= 62.5 and charge_value < 87.5 then
                        children[1]:set_widget(icons[9])
                    else
                        children[1]:set_widget(icons[10])
                    end
                else
                    if charge_value >= 0 and charge_value < 12.5 then
                        children[1]:set_widget(icons[1])
                    elseif charge_value >= 12.5 and charge_value < 37.5 then
                        children[1]:set_widget(icons[2])
                    elseif charge_value >= 37.5 and charge_value < 62.5 then
                        children[1]:set_widget(icons[3])
                    elseif charge_value >= 62.5 and charge_value < 87.5 then
                        children[1]:set_widget(icons[4])
                    else
                        children[1]:set_widget(icons[5])
                    end
                end
                children[2]:set_text(charge_value .. "%")
            else
                children[2]:set_text("Err")
            end
        end,
    }

    ---------------------------------------------------------------------------
    -- CLICK FUNCTION
    ---------------------------------------------------------------------------
    batt_widget:buttons(gears.table.join(
        awful.button({}, 1, function()
            local f = io.popen("acpi -i")
            local str = "ACPI"
            for line in f:lines() do
                str = str .. "\n" .. line
            end
            naughty.notify {
                preset = naughty.config.presets.normal,
                title = "Battery Info",
                text = str
            }
        end)
    ))

    return batt_widget
end

return setmetatable(
    battery, 
    {__call = function(_, ...) return worker(...) end}
)
