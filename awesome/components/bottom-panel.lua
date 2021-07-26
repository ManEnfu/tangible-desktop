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

local bottom_panel = {}

-------------------------------------------------------------------------------
-- TOP PANEL
-------------------------------------------------------------------------------
local function worker(args)
    local panel = awful.wibar({
        position = "bottom", 
        screen = args.screen,
        bg = "#00000000", 
        height = dpi(24) + bargap
    })

    -- status_panel = wibox.widget {
    --     layout = wibox.layout.fixed.horizontal,
    --     spacing = dpi(4)
    -- }
    -- for _,w in ipairs(args.widgets) do
    --     status_panel:add(w)
    -- end
    -- status_panel:add(wibox.widget.textbox("|  awesome4.3"))

    panel:setup {
        widget = wibox.container.margin,
        bottom = bargap,
        left = bargap,
        right = bargap,
        {
            layout = wibox.layout.stack,
            {
                layout = wibox.layout.align.horizontal,
                {
                    layout = wibox.layout.fixed.horizontal,
                    spacing = bargap,
                    {
                        layout = wibox.layout.fixed.horizontal,
                        {
                            widget = wibox.container.background,
                            bg = beautiful.bg_focus,
                            forced_width = dpi(4),
                            wibox.widget {}
                        },
                        {
                            widget = wibox.container.background,
                            bg = beautiful.bg_normal,
                            -- shape = shapes.roundedrect,
                            {
                                widget = wibox.container.margin,
                                left = dpi(8),
                                right = dpi(8),
                                myschedule
                            }
                        }
                    },
                },
                {
                    widget = wibox.container.margin,
                    left = bargap,
                    right = bargap,
                    {
                        widget = wibox.container.background,
                        bg = beautiful.bg_normal,
                        -- shape = shapes.roundedrect,
                        {
                            widget = wibox.container.margin,
                            left = dpi(8),
                            wibox.widget {}
                        },
                    },
                },
                {
                    layout = wibox.layout.fixed.horizontal,
                    spacing = bargap,
                    {
                        layout = wibox.layout.fixed.horizontal,
                        {
                            widget = wibox.container.background,
                            bg = beautiful.bg_normal,
                            -- shape = shapes.roundedrect,
                            {
                                widget = wibox.container.margin,
                                left = dpi(8),
                                right = dpi(8),
                                wibox.widget.textbox("awesome-4.3"),
                            },
                        },
                        {
                            widget = wibox.container.background,
                            bg = beautiful.bg_focus,
                            forced_width = dpi(4),
                            wibox.widget {}
                        },
                    }
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
                            left = dpi(8),
                            right = dpi(8),
                            myapptitle
                        }
                    },
            },
        }
    }
     
    return panel
end

return setmetatable(
    bottom_panel, 
    {__call = function(_, ...) return worker(...) end}
)
