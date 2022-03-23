-------------------------------------------------------------------------------
-- IMPORTS
-------------------------------------------------------------------------------
local wibox         = require("wibox")
local awful         = require("awful")
local beautiful     = require("beautiful")
local naughty       = require("naughty")
local gears         = require("gears")
local cairo         = require("lgi").cairo
local wbuttons      = require("widgets.buttons")
local shapes = require("util.shapes")
local module_path = (...):match ("(.+/)[^/]+$") or ""

local theme = beautiful.get()

local apptitle = {}

-------------------------------------------------------------------------------
-- TASKLIST MOUSE CLICK BEHAVIOR
-------------------------------------------------------------------------------
local apptitle_buttons = gears.table.join(
    -- awful.button({ }, 1, function (c)
    --     if c == client.focus then
    --         c.minimized = true
    --     else
    --         c:emit_signal(
    --             "request::activate",
    --             "tasklist",
    --             {raise = true}
    --         )
    --     end
    -- end),
    -- awful.button({ }, 3, function()
    --     awful.menu.client_list({ theme = { width = 250 } })
    -- end),
    -- awful.button({ }, 4, function ()
    --     awful.client.focus.byidx(1)
    -- end),
    -- awful.button({ }, 5, function ()
    --     awful.client.focus.byidx(-1)
    -- end)
)

-------------------------------------------------------------------------------
-- APPTITLE UPDATE CALLBACK
-------------------------------------------------------------------------------
local function apptitle_oncreate(self, c, index, ctable)
    -- local button_container = self:get_children_by_id('button_container')[1]
    -- button_container:set_widget(wibox.widget {
    --     layout = wibox.layout.fixed.horizontal,
    --     -- awful.titlebar.widget.maximizedbutton(c),
    --     -- awful.titlebar.widget.closebutton(c)
    --     wbuttons.minimize_button(c, 6),
    --     wbuttons.maximize_button(c, 6),
    --     wbuttons.close_button(c, 6)
    -- })
    -- button_container:set_widget(wibox.widget.textbox("a"))
    -- button_container.bg = beautiful.bg_focus
end

-------------------------------------------------------------------------------
-- WORKER FUNCTION
-------------------------------------------------------------------------------
local function worker(args)
    ---------------------------------------------------------------------------
    -- ARGUMENTS
    ---------------------------------------------------------------------------
    local args = args or {}

    ---------------------------------------------------------------------------
    -- ICONS
    ---------------------------------------------------------------------------
    local icon_dir = gears.filesystem.get_configuration_dir() .. "/"
        .. module_path .. "/icons/"
    
    local new_apptitle = awful.widget.tasklist {
        screen = args.screen,
        buttons = apptitle_buttons,
        filter = awful.widget.tasklist.filter.focused,
        layout = {
            layout = wibox.layout.flex.horizontal,
        },
        widget_template = {
            widget = wibox.container.background,
            bg = beautiful.bg_normal_bright,
            shape = shapes.roundedrect,
            {
                layout = wibox.layout.align.horizontal,
                spacing = 6,
                {
                    widget = wibox.container.margin,
                    margins = 6,
                    {
                        id = 'text_role',
                        widget = wibox.widget.textbox,
                        forced_width = 200
                    },
                },
                nil,
                {
                    id = 'button_container',
                    widget = wibox.container.place,
                },
            },
            create_callback = apptitle_oncreate
        },
    }

    return new_apptitle
end

return setmetatable(
    apptitle, 
    {__call = function(_, ...) return worker(...) end}
)
