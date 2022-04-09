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

local dpi = beautiful.xresources.apply_dpi
local bargap = dpi(4)

local top_panel = {}

-------------------------------------------------------------------------------
-- TOP PANEL
-------------------------------------------------------------------------------
local function worker(args)
    local panel = awful.wibar({
        position = "top", 
        screen = args.screen,
        bg = beautiful.bg_normal, 
        height = dpi(32)
    })

    status_panel = wibox.widget {
        layout = wibox.layout.fixed.horizontal,
        spacing = dpi(4)
    }
    for _,w in ipairs(args.widgets) do
        status_panel:add(w)
    end
    -- status_panel:add(wibox.widget.textbox("|  awesome4.3"))

    panel:setup {
        widget = wibox.container.margin,
        top = dpi(4),
        left = bargap,
        right = bargap,
        bottom = dpi(4),
        {
            layout = wibox.layout.stack,
            {
                layout = wibox.layout.align.horizontal,
                {
                    layout = wibox.layout.fixed.horizontal,
                    spacing = bargap,
                    {
                        layout = wibox.layout.fixed.horizontal,
                        -- {
                        --     widget = wibox.container.background,
                        --     bg = beautiful.bg_focus,
                        --     forced_width = dpi(4),
                        --     shape = shapes.roundedleft,
                        --     wibox.widget {}
                        -- },
                        {
                            widget = wibox.container.background,
                            bg = beautiful.bg_normal_bright,
                            forced_width = dpi(24),
                            shape = shapes.roundedrect,
                            {
                                widget = wibox.container.margin,
                                margins = dpi(4),
                                mylauncher
                            }
                        }
                    },
                    {
                        widget = wibox.container.background,
                        bg = "#00000000",
                        shape = shapes.roundedrect,
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
                    left = bargap + dpi(6),
                    right = bargap,
                    {
                        widget = wibox.container.background,
                        -- bg = beautiful.bg_normal,
                        shape = shapes.roundedrect,
                        {
                            layout = wibox.layout.align.horizontal,
                            nil,
                            widgets.apptitle { screen = args.screen },
                            {
                                widget = wibox.container.margin,
                                left = dpi(8),
                                right = dpi(8),
                                status_panel
                            }
                        }
                    },
                },
                {
                    layout = wibox.layout.fixed.horizontal,
                    spacing = bargap,
                    {
                        widget = wibox.container.background,
                        -- bg = beautiful.bg_normal,
                        shape = shapes.roundedrect,
                        {
                            widget = wibox.container.margin,
                            top = dpi(4),
                            bottom = dpi(4),
                            left = dpi(8),
                            right = dpi(8),
                            wibox.widget.systray(),
                        },
                    },
                    {
                        layout = wibox.layout.fixed.horizontal,
                        {
                            widget = wibox.container.background,
                            bg = beautiful.bg_normal_bright,
                            shape = shapes.roundedrect,
                            {
                                widget = wibox.container.margin,
                                margins = dpi(4),
                                awful.widget.layoutbox(args.screen),
                            },
                        },
                        -- {
                        --     widget = wibox.container.background,
                        --     bg = beautiful.bg_focus,
                        --     forced_width = dpi(4),
                        --     shape = shapes.roundedright,
                        --     wibox.widget {}
                        -- },
                    }
                }
            },
            {
                widget = wibox.container.place,
                halign = "center",
                content_fill_vertical = true,
                    {
                        widget = wibox.container.background,
                        -- bg = beautiful.bg_normal_bright,
                        shape = shapes.roundedrect,
                        {
                            widget = wibox.container.margin,
                            left = dpi(8),
                            right = dpi(8),
                            -- myschedule,
                            wibox.widget.textclock("<b>%a, %d %b %y | %H:%M</b>"),
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
