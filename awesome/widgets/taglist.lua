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
    local task_bg = 
        self:get_children_by_id('task_background')[1]

    self:get_children_by_id('tasklist')[1].visible = 
        #tag:clients() > 0
    if selected then
        tag_bg.bg = beautiful.bg_focus
        task_bg.bg = beautiful.bg_focus_bright
    else
        tag_bg.bg = beautiful.bg_normal
        task_bg.bg = beautiful.bg_normal_bright
    end
    touch_left = false
    touch_right = false
    touch_middle = false
    if index ~= 1 then
        if selected and 
            (#(ttable[index-1]:clients()) > 0 or ttable[index-1].selected) then
            touch_left = true
        end
    end
    if index ~= #ttable then
        if ttable[index+1].selected then
            touch_right = true
        end
    end
    touch_middle = selected and #tag:clients() > 0

    if touch_right then
        if touch_middle then
            task_bg.shape = gears.shape.rectangle
        else
            task_bg.shape = shapes.roundedleft
        end
    else
        if touch_middle then
            task_bg.shape = shapes.roundedright
        else
            task_bg.shape = shapes.roundedrect
        end
    end

    if touch_left then
        if touch_middle then
            tag_bg.shape = gears.shape.rectangle
        else
            tag_bg.shape = shapes.roundedright
        end
    else
        if touch_middle then
            tag_bg.shape = shapes.roundedleft
        else
            tag_bg.shape = shapes.roundedrect
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
            layout = wibox.layout.fixed.horizontal,
            {
                id = "tag_background",
                widget = wibox.container.background,
                bg = beautiful.bg_normal,
                {
                    widget = wibox.container.margin,
                    left  = 6,
                    right = 6,
                    top = 6,
                    bottom = 6,
                    {
                        layout = wibox.layout.fixed.horizontal,
                        {
                            id     = 'icon_role',
                            widget = wibox.widget.imagebox,
                        }
                    }
                }
            },
            {
                id = "task_background",
                widget = wibox.container.background,
                bg = nil,
                {
                    id = 'tasklist',
                    widget = wibox.container.margin,
                    right = 2,
                    left = 2,
                    wibox.widget {}
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
