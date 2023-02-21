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

local nightmode = {}

-------------------------------------------------------------------------------
-- WORKER FUNCTION
-------------------------------------------------------------------------------
local function worker(args)
    ---------------------------------------------------------------------------
    -- ARGUMENTS
    ---------------------------------------------------------------------------
    local args = args or {}
    
    local timeout = args.timeout or 5
    local card = args.card or 0
    local use_buttons = args.use_buttons or false
    local keys = args.keys or nil
    local play = args.play or ""

    ---------------------------------------------------------------------------
    -- ICONS
    ---------------------------------------------------------------------------
    local icon_dir = gears.filesystem.get_configuration_dir() .. "/"
        .. module_path .. "/icons/"

    local icons = {
        wibox.widget.imagebox(icon_dir .. "nightmode-off.png"),
        wibox.widget.imagebox(icon_dir .. "nightmode-on.png"),
        -- wibox.widget.textbox("D"),
        -- wibox.widget.textbox("N"),
    }

    ---------------------------------------------------------------------------
    -- WIDGET DEFINITION
    ---------------------------------------------------------------------------
    local light_widget = wibox.widget {
        layout = wibox.layout.fixed.horizontal,
        {
            widget = wibox.container.margin,
            margins = 6,
            icons[1],
        },
        {
            widget =  wibox.widget.textbox
        },
        nightmode_enabled = false
    }

    ---------------------------------------------------------------------------
    -- UPDATE BRIGHTNESS
    ---------------------------------------------------------------------------
    local function update_brightness(widget, stdout)
        local brightness_level = string.match(stdout, '(%d+)%%')
        local children = widget:get_children()
        if brightness_level ~= nil then
            children[2]:set_text(brightness_level .. "%")
        else
            children[2]:set_text("--%")
        end
    end

    awful.widget.watch("tgd-brightness get", timeout,
    function(widget, stdout)
        update_brightness(widget, stdout)
    end, light_widget)

    light_widget.force_update_brightness = function(self)
        awful.spawn.easy_async_with_shell(
            "tgd-brightness get",
            function(stdout, stderr, exr, exc)
                update_brightness(self, stdout)
            end
        )
    end

    awesome.connect_signal("signal::brightness", function()
        light_widget:force_update_brightness()
    end)

    ---------------------------------------------------------------------------
    -- CLICK FUNCTION
    ---------------------------------------------------------------------------
    light_widget:buttons(gears.table.join(
        awful.button({}, 1, function()
            light_widget:nightmode_toggle()
        end
        )
    ))

    light_widget.nightmode_toggle = function(self)
        local children = self:get_children()
        self.nightmode_enabled = not (self.nightmode_enabled)
        if self.nightmode_enabled == false then
            children[1]:set_widget(icons[1])
            awful.spawn.with_shell("redshift -x")
        else
            children[1]:set_widget(icons[2])
            awful.spawn.with_shell("redshift -PO 4500")
        end
    end

    awesome.connect_signal("signal::nightmode", function()
        light_widget:nightmode_toggle()
    end)

    return light_widget
end

return setmetatable(
    nightmode, 
    {__call = function(_, ...) return worker(...) end}
)
