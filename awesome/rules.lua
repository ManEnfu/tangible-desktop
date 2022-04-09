-- rules.lua
-- Defines rules to apply to new clients

-------------------------------------------------------------------------------
-- IMPORTS
-------------------------------------------------------------------------------
local awful = require("awful")
local beautiful = require("beautiful")
local naughty       = require("naughty")


awful.rules.add_rule_source(
    'wm-decor-hints', 
    function(c, properties, callbacks)
        -- st = ''
        -- for k,v in pairs(properties) do
        --     st = st .. k .. ' ' .. tostring(v) .. '\n'
        -- end
        -- naughty.notify{
        --     title = c.name,
        --     text = '>' .. st
        -- }
        if c.motif_wm_hints then
            if c.motif_wm_hints.decorations then
                local all_dec_hints_false = true
                for _,v in pairs(c.motif_wm_hints.decorations) do
                    if v then
                            all_dec_hints_false = false
                        break
                    end
                end
                if all_dec_hints_false then
                    properties.request_no_titlebar = true
                    properties.titlebars_enabled = false
                end
                -- naughty.notify{
                --     title = c.name,
                --     text = '>>' .. tostring(properties.titlebars_enabled)
                -- }
            end
        end
    end,
    {}, {'awful.rules'}
)

-------------------------------------------------------------------------------
-- RULES
-------------------------------------------------------------------------------
awful.rules.rules = {
    ---------------------------------------------------------------------------
    -- ANY CLIENTS
    ---------------------------------------------------------------------------
    { 
        rule = { },
        properties = { 
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap +
                awful.placement.no_offscreen,
        }
    },

    ---------------------------------------------------------------------------
    -- FLOATING CLIENTS
    ---------------------------------------------------------------------------
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid 
                         -- fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop 
        -- might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    ---------------------------------------------------------------------------
    -- TITLE BAR
    ---------------------------------------------------------------------------
    { rule_any = {type = { "normal", "dialog" }},
      properties = { titlebars_enabled = true }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
    { 
        rule_any = { class = { "Firefox", "qutebrowser", "firefox" } }, 
        properties = { tag = "web" }
    },
    { 
        rule_any = { class = { "pcmanfm-qt" } }, 
        properties = { tag = "file" }
    },
    { 
        rule_any = { class = { "Virt-manager", "virt-manager" } }, 
        properties = { tag = "virt" }
    },
    { 
        rule_any = { class = { "mpv", "vlc" } }, 
        properties = { tag = "media", focus = true },
        callback = function(c) c:jump_to() end
    }
}
