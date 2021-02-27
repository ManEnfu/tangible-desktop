-------------------------------------------------------------------------------
-- IMPORTS
-------------------------------------------------------------------------------
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local shapes = require("util.shapes")
local tasklist = require("widgets.tasklist")
local module_path = (...):match ("(.+/)[^/]+$") or ""

local taglist = {}

-------------------------------------------------------------------------------
-- TAGLIST MOUSE CLICK BEHAVIOR
-------------------------------------------------------------------------------
local taglist_buttons = gears.table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({ "Control" }, 1, awful.tag.viewtoggle),
    awful.button({ modkey, "Control" }, 1, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

-------------------------------------------------------------------------------
-- TAGLIST UPDATE CALLBACK
-------------------------------------------------------------------------------
local function taglist_callback(self, tag, index, ttable)
    local selected = tag.selected
    local sel_bg = 
        self:get_children_by_id('selected_background')[1]
    local tag_bg = 
        self:get_children_by_id('tag_background')[1]

    self:get_children_by_id('tasklist_container')[1].visible = 
        #tag:clients() > 0
    if selected then
        sel_bg.bg = beautiful.bg_focus
        sel_bg.bg = beautiful.bg_focus
        tag_bg.bg = beautiful.bg_focus
    else
        sel_bg.bg = beautiful.bg_normal
        tag_bg.bg = beautiful.bg_normal
    end
end

local function taglist_oncreate(self, tag, index, ttable)
    self:get_children_by_id('tasklist')[1]:set_children {
        tasklist {
            screen = tag.screen,
            tag = tag
        }
    }
    taglist_callback(self, tag, index, ttable)
end

-------------------------------------------------------------------------------
-- TAGLIST
-------------------------------------------------------------------------------
function worker(args)
    local new_taglist = awful.widget.taglist {
        screen  = args.screen,
        filter  = awful.widget.taglist.filter.all,
        style   = {
        },
        layout   = {
            layout  = wibox.layout.fixed.horizontal
        },
        widget_template = {
            id = "tag_background",
            widget = wibox.container.background,
            bg = beautiful.bg_normal,
            -- shape = shapes.roundedrect,
            {
                layout = wibox.layout.fixed.horizontal,
                {
                    id = "selected_background",
                    widget = wibox.container.background,
                    -- shape = shapes.roundedleft,
                    bg = nil,
                    {
                        widget = wibox.container.margin,
                        left  = 4,
                        right = 4,
                        top = 4,
                        bottom = 4,
                        {
                            layout = wibox.layout.fixed.horizontal,
                            {
                                id     = 'icon_role',
                                widget = wibox.widget.imagebox,
                            },
                        },
                    },
                },
                {
                    id = 'tasklist_container',
                    widget = wibox.container.margin,
                    right = 2,
                    top = 2,
                    bottom = 2,
                    visible = true,
                    {
                        widget = wibox.container.background,
                        bg = "#323232",
                        {
                            id = 'tasklist',
                            widget = wibox.container.margin,
                            right = 2,
                            left = 2,
                            wibox.widget {}
                        }
                    }
                }
            },
            create_callback = taglist_oncreate,
            update_callback = taglist_callback
        },
        buttons = taglist_buttons
    }
    return new_taglist
end

return setmetatable(
    taglist, 
    {__call = function(_, ...) return worker(...) end}
)
