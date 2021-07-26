---------------------------
-- Default awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gears = require("gears")
local gfs = require("gears.filesystem")
local icon_dir = gears.filesystem.get_configuration_dir() .. "/icons/"

local theme = {}

theme.font          = "Ubuntu 8"

theme.bg_normal     = "#161616"
theme.bg_normal_bright     = "#242424"
theme.bg_focus      = "#0d8cb2" --"#416879" --"#cd823d"
theme.bg_focus_bright      = "#04323f" --"#263238" --"#e29654"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#dfdfdf"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

theme.useless_gap   = dpi(2)
theme.border_width  = dpi(0)
theme.border_normal = "#242424"
theme.border_focus  = "#139d2c"
theme.border_marked = "#91231c"

theme.systray_icon_spacing = dpi(4)
-- There are other variable sets
-- overriding the custom one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Generate taglist squares:
local taglist_square_size = dpi(4)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)
theme.tasklist_plain_task_name = true

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]
theme.notification_border_color = theme.bg_normal
theme.notification_max_width = 640
theme.notification_max_height = 160
theme.notification_icon_size = 64


-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = icon_dir.."submenu.png"
theme.menu_height = dpi(20)
theme.menu_width  = dpi(160)
theme.menu_bg_normal = "#161616"
theme.menu_bg_focus = "#323232"

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = icon_dir .. "close-button.png"
theme.titlebar_close_button_focus  = icon_dir .. "close-button.png"

theme.titlebar_minimize_button_normal = icon_dir.."titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = icon_dir.."titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = icon_dir.."titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = icon_dir.."titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = icon_dir.."titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = icon_dir.."titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = icon_dir.."titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = icon_dir.."titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = icon_dir.."titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = icon_dir.."titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = icon_dir.."titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = icon_dir.."titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = icon_dir.."titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = icon_dir.."titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = icon_dir .. "max-button.png"
theme.titlebar_maximized_button_focus_inactive  = icon_dir .. "max-button.png" 
theme.titlebar_maximized_button_normal_active = icon_dir .. "restore-button.png"
theme.titlebar_maximized_button_focus_active  = icon_dir .. "restore-button.png"

-- You can use your own layout icons like this:
theme.layout_fairh = icon_dir.."layouts/fairhw.png"
theme.layout_fairv = icon_dir.."layouts/fairvw.png"
theme.layout_floating  = icon_dir.."layouts/floatingw.png"
theme.layout_magnifier = icon_dir.."layouts/magnifierw.png"
theme.layout_max = icon_dir.."layouts/maxw.png"
theme.layout_fullscreen = icon_dir.."layouts/fullscreenw.png"
theme.layout_tilebottom = icon_dir.."layouts/tilebottomw.png"
theme.layout_tileleft   = icon_dir.."layouts/tileleftw.png"
theme.layout_tile = icon_dir.."layouts/tilew.png"
theme.layout_tiletop = icon_dir.."layouts/tiletopw.png"
theme.layout_spiral  = icon_dir.."layouts/spiralw.png"
theme.layout_dwindle = icon_dir.."layouts/dwindlew.png"
theme.layout_cornernw = icon_dir.."layouts/cornernww.png"
theme.layout_cornerne = icon_dir.."layouts/cornernew.png"
theme.layout_cornersw = icon_dir.."layouts/cornersww.png"
theme.layout_cornerse = icon_dir.."layouts/cornersew.png"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = "Tela"

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
