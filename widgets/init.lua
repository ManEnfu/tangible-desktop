local module_path = (...):match ("(.+/)[^/]+$") or ""


local mod = {
    apptitle = require(module_path .. "widgets.apptitle"),
    battery  = require(module_path .. "widgets.battery"),
    sensors  = require(module_path .. "widgets.sensors"),
    volume   = require(module_path .. "widgets.volume"),
    memory   = require(module_path .. "widgets.memory"),
    cpu      = require(module_path .. "widgets.cpu"),
    wifi     = require(module_path .. "widgets.wifi"),
    taglist  = require(module_path .. "widgets.taglist"),
    tasklist = require(module_path .. "widgets.tasklist"),
    schedule = require(module_path .. "widgets.schedule"),
}

return mod
