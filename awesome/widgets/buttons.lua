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
        awful.button({}, 1, nil, action)
    ))
    return ret
end

function buttons.close_button(c, padding)
    local ret = buttons.padded_button(
        icon_dir .. "close-button.png",
        padding,
        function()
            c:kill()
        end
    )
    local function update()
        ret:set_image(
            c == client.focus and icon_dir .. "close-button.png"
                or icon_dir .. "close-button-unfocus.png"
        )
    end
    update()
    c:connect_signal("focus", update)
    c:connect_signal("unfocus", update)
    return ret
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
    local function update()
        ret:set_image(
            c == client.focus and (
                c.maximized and icon_dir .. "restore-button.png"
                    or icon_dir .. "max-button.png"
            ) or (
                c.maximized and icon_dir .. "restore-button-unfocus.png"
                    or icon_dir .. "max-button-unfocus.png"
            )
        )
    end
    update()
    c:connect_signal("focus", update)
    c:connect_signal("unfocus", update)
    c:connect_signal("property::maximized", update)
    return ret
end

function buttons.minimize_button(c, padding)
    local ret =  buttons.padded_button(icon_dir .. "min-button.png", padding, function()
        c.minimized = true
    end)
    local function update()
        ret:set_image(
            c == client.focus and icon_dir .. "min-button.png"
                or icon_dir .. "min-button-unfocus.png"
        )
    end
    update()
    c:connect_signal("focus", update)
    c:connect_signal("unfocus", update)
    return ret
end

function buttons.floating_button(c, padding)
    local ret = buttons.padded_button(
        c.floating and icon_dir .. "float-on-button.png"
            or icon_dir .. "float-off-button.png",
        padding,
        function()
            c.floating = not c.floating
        end
    )
    local function update()
        ret:set_image(
            c == client.focus and (
                c.floating and icon_dir .. "float-on-button.png"
                    or icon_dir .. "float-off-button.png"
            ) or (
                c.floating and icon_dir .. "float-on-button-unfocus.png"
                    or icon_dir .. "float-off-button-unfocus.png"
            )
        )
    end
    update()
    c:connect_signal("focus", update)
    c:connect_signal("unfocus", update)
    c:connect_signal("property::floating", update)
    return ret
end

return buttons
