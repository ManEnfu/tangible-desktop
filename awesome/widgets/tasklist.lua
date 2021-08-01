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
-- TASKLIST CUSTOM FILTER
-------------------------------------------------------------------------------
local function get_filter_per_tag(tag)
    return function(c, screen)
        if c.screen ~= screen then return false end
        if tag.screen ~= screen then return false end
        if tag ~= c.first_tag then return false end
        return true
    end
end

-------------------------------------------------------------------------------
-- TASKLIST UPDATE CALLBACK
-------------------------------------------------------------------------------
local function tasklist_callback(self, c, index, ctable)
    self:get_children_by_id('selected_background')[1].bg =
        (c == client.focus) and beautiful.fg_focus or nil
end

-------------------------------------------------------------------------------
-- TASKLIST
-------------------------------------------------------------------------------
local function worker(args)
    local new_tasklist = awful.widget.tasklist {
        screen  = args.screen,
        filter  = get_filter_per_tag(args.tag),
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
                    id = 'selected_background',
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
            create_callback = function(self, c, index, ctable)
                self:get_children_by_id('clienticon')[1].client = c
                tasklist_callback(self, c, index, ctable)
            end,
            update_callback = tasklist_callback,
        },
    }
    return new_tasklist
end

return setmetatable(
    tasklist, 
    {__call = function(_, ...) return worker(...) end}
)
