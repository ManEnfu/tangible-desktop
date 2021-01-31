-------------------------------------------------------------------------------
-- IMPORTS
-------------------------------------------------------------------------------
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local widgets = require("widgets")
local shapes = require("util.shapes")
local module_path = (...):match ("(.+/)[^/]+$") or ""

local top_panel = {}

-------------------------------------------------------------------------------
-- TOP PANEL
-------------------------------------------------------------------------------
local function worker(args)
    local panel = awful.wibar({
        position = "top", 
        screen = args.screen,
        bg = "#00000000", 
        height = 28
    })

    status_panel = wibox.widget {
        layout = wibox.layout.fixed.horizontal,
        spacing = beautiful.xresources.apply_dpi(4)
    }
    for _,w in ipairs(args.widgets) do
        status_panel:add(w)
    end
    -- status_panel:add(wibox.widget.textbox("|  awesome4.3"))

    panel:setup {
        widget = wibox.container.margin,
        top = beautiful.xresources.apply_dpi(4),
        left = beautiful.xresources.apply_dpi(4),
        right = beautiful.xresources.apply_dpi(4),
        {
            layout = wibox.layout.stack,
            {
                layout = wibox.layout.align.horizontal,
                {
                    layout = wibox.layout.fixed.horizontal,
                    spacing = beautiful.xresources.apply_dpi(4),
                    {
                        widget = wibox.container.background,
                        bg = beautiful.bg_normal,
                        -- shape = shapes.roundedrect,
                        forced_width = 24,
                        {
                            widget = wibox.container.margin,
                            margins = 4,
                            mylauncher
                        }
                    },
                    {
                        widget = wibox.container.background,
                        bg = "#00000000",
                        -- shape = shapes.roundedrect,
                        {
                            layout = wibox.layout.fixed.horizontal,
                            widgets.taglist { screen = args.screen },
                        },
                    },
                    -- {
                    --     widget = wibox.container.background,
                    --     bg = beautiful.bg_normal,
                    --     shape = shapes.roundedrect,
                    --     {
                    --         layout = wibox.layout.fixed.horizontal,
                    --         awful.widget.prompt(args.screen),
                    --     },
                    -- },
                },
                {
                    widget = wibox.container.margin,
                    left = beautiful.xresources.apply_dpi(4),
                    right = beautiful.xresources.apply_dpi(4),
                    {
                        widget = wibox.container.background,
                        bg = beautiful.bg_normal,
                        -- shape = shapes.roundedrect,
                        {
                            widget = wibox.container.margin,
                            left = beautiful.xresources.apply_dpi(4),
                            myschedule,
                        }
                    },
                },
                {
                    layout = wibox.layout.fixed.horizontal,
                    spacing = beautiful.xresources.apply_dpi(4),
                    {
                        widget = wibox.container.background,
                        bg = beautiful.bg_normal,
                        -- shape = shapes.roundedrect,
                        {
                            widget = wibox.container.margin,
                            left = 8,
                            right = 8,
                            status_panel
                        }
                    },
                    {
                        widget = wibox.container.background,
                        bg = beautiful.bg_normal,
                        -- shape = shapes.roundedrect,
                        {
                            widget = wibox.container.margin,
                            top = 4,
                            bottom = 4,
                            left = 8,
                            right = 8,
                            wibox.widget.systray(),
                        },
                    },
                    {
                        widget = wibox.container.background,
                        bg = beautiful.bg_normal,
                        -- shape = shapes.roundedrect,
                        {
                            widget = wibox.container.margin,
                            margins = 4,
                            awful.widget.layoutbox(args.screen),
                        },
                    },
                }
            },
            {
                widget = wibox.container.place,
                halign = "center",
                content_fill_vertical = true,
                    {
                        widget = wibox.container.background,
                        bg = beautiful.bg_normal,
                        -- shape = shapes.roundedrect,
                        {
                            widget = wibox.container.margin,
                            left = 8,
                            right = 8,
                            wibox.widget.textclock("%A, %d %B %Y | %H:%M"),
                        }
                    },
            },
        }
    }
     
    return panel
end

return setmetatable(
    top_panel, 
    {__call = function(_, ...) return worker(...) end}
)
