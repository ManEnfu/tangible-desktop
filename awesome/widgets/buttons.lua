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
local icon_dir = gears.filesystem.get_configuration_dir() .. "/"
    .. module_path .. "/icons/"

local buttons = {}

function buttons.padded_button(img, padding, action)
    local ret = wibox.widget {
        widget = wibox.container.margin,
        margins = padding,
        {
            widget = wibox.widget.imagebox,
            image = img
        }
    }
    function ret:set_image(new_img)
        self:get_children()[1].image = new_img
    end
    ret:buttons(gears.table.join(
        awful.button({}, 1, action)
    ))
    return ret
end

function buttons.close_button(c, padding)
    return buttons.padded_button(
        icon_dir .. "close-button.png",
        padding,
        function()
            c:kill()
        end
    )
end

function buttons.maximize_button(c, padding)
    local ret = buttons.padded_button(
        c.maximized and icon_dir .. "restore-button.png"
            or icon_dir .. "max-button.png",
        padding,
        function()
            c.maximized = not c.maximized
        end
    )
    c:connect_signal("property::maximized", function()
        ret:set_image(
            c.maximized and icon_dir .. "restore-button.png"
                or icon_dir .. "max-button.png"
        )
    end)
    return ret
end

function buttons.minimize_button(c, padding)
    return buttons.padded_button(icon_dir .. "min-button.png", padding, function()
        c.minimized = not c.minimized
    end)
end

return buttons
