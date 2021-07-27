-------------------------------------------------------------------------------
-- IMPORTS
-------------------------------------------------------------------------------
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local shapes = require("util.shapes")

-------------------------------------------------------------------------------
-- SIGNALS
-------------------------------------------------------------------------------
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    c.shape = shapes.roundedrect
    if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c, { size = 4, position = "left" }) : setup {
        buttons = buttons,
        layout = wibox.layout.align.vertical,
        nil,
        nil,
        nil,
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
-- client.connect_signal("mouse::enter", function(c)
--     c:emit_signal("request::activate", "mouse_enter", {raise = false})
-- end)

client.connect_signal("focus", 
    function(c) 
        c.border_color = beautiful.border_focus 
    end
)

client.connect_signal(
    "unfocus", 
    function(c) 
        c.border_color = beautiful.border_normal 
    end
)

screen.connect_signal("arrange", function(s)
    local one_tiled_client = #s.tiled_clients == 1
    for _, c in pairs(s.clients) do
        if (one_tiled_client and not c.floating and 
            c.first_tag.layout ~= awful.layout.suit.floating) or 
            c.maximized or (
            -- client.focus == c and
            not c.floating and
            c.first_tag.layout == awful.layout.suit.max) then
            c.shape = gears.shape.rectangle
            -- awful.titlebar.hide(c, 'left')
        else
            c.shape = shapes.roundedrect
            -- awful.titlebar.show(c, 'left')
        end
    end
end)