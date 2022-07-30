local module_path = (...):match ("(.+/)[^/]+$") or ""


local mod = {
    apptitle = require(module_path .. "widgets.apptitle"),
    battery  = require(module_path .. "widgets.battery"),
    sensors  = require(module_path .. "widgets.sensors"),
    volume   = require(module_path .. "widgets.volume"),
    memory   = require(module_path .. "widgets.memory"),
    cpu      = require(module_path .. "widgets.cpu"),
    wifi     = require(module_path .. "widgets.wifi"),
    net      = require(module_path .. "widgets.net"),
    disk     = require(module_path .. "widgets.disk"),
    taglist  = require(module_path .. "widgets.taglist"),
    tasklist = require(module_path .. "widgets.tasklist"),
    schedule = require(module_path .. "widgets.schedule"),
    nightmode= require(module_path .. "widgets.nightmode"),
    buttons  = require(module_path .. "widgets.buttons"),
    light    = require(module_path .. "widgets.light"),
}

return mod
