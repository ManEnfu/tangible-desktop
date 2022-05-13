local wibox = require("wibox")
local gstring = require("gears.string")
local dpi = require("beautiful").xresources.apply_dpi
local surface = require("gears.surface")
local cairo = require("lgi").cairo
local string = string
local pairs = pairs
local type = type

local roundedmenu = {}

local table_update = function (t, set)
    for k, v in pairs(set) do
        t[k] = v
    end
    return t
end

function roundedmenu.entry(parent, args)
    args = args or {}
    args.text = args[1] or args.text or ""
    args.cmd = args[2] or args.cmd
    args.icon = args[3] or args.icon
    local ret = {}
    -- Create the item label widget
    local label = wibox.widget.textbox()
    local key = ''
    label:set_font(args.theme.font)
    label:set_markup(string.gsub(
        gstring.xml_escape(args.text), "&amp;(%w)",
        function (l)
            key = string.lower(l)
            return "<u>" .. l .. "</u>"
        end, 1))
    -- Set icon if needed
    local icon, iconbox
    local margin = wibox.container.margin()
    margin:set_widget(label)
    if args.icon then
        icon = surface.load(args.icon)
    end
    if icon then
        local iw = icon:get_width()
        local ih = icon:get_height()
        if iw > args.theme.width or ih > args.theme.height then
            local w, h
            if ((args.theme.height / ih) * iw) > args.theme.width then
                w, h = args.theme.height, (args.theme.height / iw) * ih
            else
                w, h = (args.theme.height / ih) * iw, args.theme.height
            end
            -- We need to scale the image to size w x h
            local img = cairo.ImageSurface(cairo.Format.ARGB32, w, h)
            local cr = cairo.Context(img)
            cr:scale(w / iw, h / ih)
            cr:set_source_surface(icon, 0, 0)
            cr:paint()
            icon = img
        end
        iconbox = wibox.widget.imagebox()
        if iconbox:set_image(icon) then
            margin:set_left(dpi(2))
        else
            iconbox = nil
        end
    end
    if not iconbox then
        margin:set_left(args.theme.height + dpi(2))
    end
    -- Create the submenu icon widget
    local submenu
    if type(args.cmd) == "table" then
        if args.theme.submenu_icon then
            submenu = wibox.widget.imagebox()
            submenu:set_image(args.theme.submenu_icon)
        else
            submenu = wibox.widget.textbox()
            submenu:set_font(args.theme.font)
            submenu:set_text(args.theme.submenu)
        end
    end
    -- Add widgets to the wibox
    local left = wibox.layout.fixed.horizontal()
    if iconbox then
        left:add(iconbox)
    end
    -- This contains the label
    left:add(margin)

    local layout = wibox.layout.align.horizontal()
    layout:set_left(left)
    if submenu then
        layout:set_right(submenu)
    end

    return table_update(ret, {
        label = label,
        sep = submenu,
        icon = iconbox,
        widget = layout,
        cmd = args.cmd,
        akey = key,
    })
end

return roundedmenu
