local module_path = (...):match ("(.+/)[^/]+$") or ""

local mod = {
    tilemax = require(module_path .. "layout.tilemax")
}

return mod
