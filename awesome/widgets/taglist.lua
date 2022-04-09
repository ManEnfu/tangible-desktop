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
    local tag_bg =
        self:get_children_by_id('tag_background')[1]
    local sel_bg =
        self:get_children_by_id('sel_background')[1]
    local empty_icon =
        self:get_children_by_id('empty_icon')[1]

    self:get_children_by_id('tasklist')[1].visible =
        #tag:clients() > 0
    empty_icon.visible = #tag:clients() == 0

    if selected then
        sel_bg.bg = beautiful.bg_focus
        tag_bg.bg = beautiful.bg_focus_bright
    else
        sel_bg.bg = beautiful.bg_normal
        if #tag:clients() > 0 then
            tag_bg.bg = beautiful.bg_normal_bright
        else
            tag_bg.bg = beautiful.bg_normal
        end
    end

    local touch_left = false
    local touch_right = false
    if index ~= 1 then
        if #(ttable[index-1]:clients()) > 0 or ttable[index-1].selected then
            touch_left = true
        end
    end
    if index ~= #ttable then
        if #(ttable[index+1]:clients()) > 0 or ttable[index+1].selected then
            touch_right = true
        end
    end

    if touch_right then
        if touch_left then
            tag_bg.shape = gears.shape.rectangle
        else
            tag_bg.shape = selected and shapes.roundedbottomleft or
                shapes.roundedleft
        end
    else
        if touch_left then
            tag_bg.shape = selected and shapes.roundedbottomright or
                shapes.roundedright
        else
            tag_bg.shape = selected and shapes.roundedbottom or
                shapes.roundedrect
        end
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
local function worker(args)
    local new_taglist = awful.widget.taglist {
        screen  = args.screen,
        filter  = awful.widget.taglist.filter.all,
        style   = {
        },
        layout   = {
            layout  = wibox.layout.fixed.horizontal
        },
        widget_template = {
            layout = wibox.layout.stack,
            {
                widget = wibox.container.margin,
                bottom = args.vmargins * 2,
                {
                    id = "sel_background",
                    widget = wibox.container.background,
                    bg = beautiful.bg_focus,
                    wibox.widget {},
                }
            },
            {
                widget = wibox.container.margin,
                bottom = args.vmargins,
                top = args.vmargins,
                {
                    id = "tag_background",
                    widget = wibox.container.background,
                    bg = beautiful.bg_normal,
                    {
                        layout = wibox.layout.fixed.horizontal,
                        {
                            id = "empty_icon",
                            widget = wibox.container.margin,
                            margins = 6,
                            {
                                id     = 'icon_role',
                                widget = wibox.widget.imagebox,
                            }
                        },
                        {
                            id = 'tasklist',
                            widget = wibox.container.margin,
                            right = 2,
                            left = 2,
                            -- this will be replaced with tasklist widget
                            wibox.widget {}
                        }
                    }
                },
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
