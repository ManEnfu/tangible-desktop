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
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
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
    self:get_children_by_id('occ_indicator')[1].visible =
        #tag:clients() > 0
    local selected = tag.selected
    self:get_children_by_id('tasklist')[1].visible = selected
    self:get_children_by_id('select_separate')[1]
        .right = (selected and index < #ttable) and 4 or 0
    self:get_children_by_id('select_separate')[1]
        .left = (selected and index > 1) and 4 or 0
    local sel_bg = 
        self:get_children_by_id('selected_background')[1]
    local tag_bg = 
        self:get_children_by_id('tag_background')[1]
    if selected then
        sel_bg.bg = beautiful.bg_focus
        tag_bg.shape = shapes.roundedrect
    else
        sel_bg.bg = nil
        local ps = false
        if index > 1 then ps = ttable[index - 1].selected 
        else ps = true 
        end
        local ns = false
        if index < #ttable then ns = ttable[index + 1].selected
        else ns = true
        end
        if ps then
            if ns then
                tag_bg.shape = shapes.roundedrect
            else
                tag_bg.shape = shapes.roundedleft
            end
        else
            if ns then
                tag_bg.shape = shapes.roundedright
            else
                tag_bg.shape = gears.shape.rectangle
            end
        end
    end
end

-------------------------------------------------------------------------------
-- TAGLIST
-------------------------------------------------------------------------------
function worker(args)
    local new_tasklist = tasklist { 
        screen = args.screen 
    }
    local new_taglist = awful.widget.taglist {
        screen  = args.screen,
        filter  = awful.widget.taglist.filter.all,
        style   = {
        },
        layout   = {
            layout  = wibox.layout.fixed.horizontal
        },
        widget_template = {
            id = 'select_separate',
            widget = wibox.container.margin,
            right = 0,
            left = 0,
            {
                id = "tag_background",
                widget = wibox.container.background,
                bg = beautiful.bg_normal,
                shape = shapes.roundedrect,
                {
                    layout = wibox.layout.fixed.horizontal,
                    {
                        layout = wibox.layout.stack,
                        {
                            id = "selected_background",
                            widget = wibox.container.background,
                            shape = shapes.roundedleft,
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
                            widget = wibox.container.place,
                            valign = "top",
                            halign = "left",
                            {
                                widget = wibox.container.margin,
                                margins = 2,
                                {
                                    id = "occ_indicator",
                                    widget = wibox.container.background,
                                    bg = beautiful.fg_normal,
                                    forced_height = 4,
                                    forced_width = 4,
                                    shape = shapes.roundedrect,
                                    wibox.widget {}
                                }
                            }
                        }
                    },
                    {
                        id = 'tasklist',
                        widget = wibox.container.margin,
                        left = 4,
                        right = 4,
                        visible = true,
                        new_tasklist,
                    },
                }
            },
            create_callback = taglist_callback,
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
