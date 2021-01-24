-------------------------------------------------------------------------------
-- IMPORTS
-------------------------------------------------------------------------------
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local module_path = (...):match ("(.+/)[^/]+$") or ""

local tasklist = {}

-------------------------------------------------------------------------------
-- TASKLIST MOUSE CLICK BEHAVIOR
-------------------------------------------------------------------------------
local tasklist_buttons = gears.table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal(
                "request::activate",
                "tasklist",
                {raise = true}
            )
        end
    end),
    awful.button({ }, 3, function()
        awful.menu.client_list({ theme = { width = 250 } })
    end),
    awful.button({ }, 4, function ()
        awful.client.focus.byidx(1)
    end),
    awful.button({ }, 5, function ()
        awful.client.focus.byidx(-1)
    end)
)

-------------------------------------------------------------------------------
-- TASKLIST
-------------------------------------------------------------------------------
local function worker(args)
    local new_tasklist = awful.widget.tasklist {
        screen  = args.screen,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        layout  = {
            layout = wibox.layout.fixed.horizontal,
        },
        widget_template = {
            layout = wibox.layout.stack,
            {
                widget = wibox.container.place,
                valign = "bottom",
                {
                    widget = wibox.container.background,
                    id = 'background_role',
                    forced_height = 2,
                    forced_width = 20,
                    wibox.widget {},
                },
            },
            {
                widget = wibox.container.margin,
                margins = 4,
                {
                    id = 'clienticon',
                    widget = awful.widget.clienticon,
                }
            },
            -- Set icon for each newly created clients
            create_callback = function(self, c, index, objects)
                self:get_children_by_id('clienticon')[1].client = c
            end,
        }
    }
    return new_tasklist
end

return setmetatable(
    tasklist, 
    {__call = function(_, ...) return worker(...) end}
)
