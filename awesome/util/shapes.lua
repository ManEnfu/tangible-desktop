local gears = require("gears")
local module_path = (...):match ("(.+/)[^/]+$") or ""

local shapes = {}

shapes.roundedrect = function(cr, w, h) 
    return gears.shape.rounded_rect(cr, w, h, 4) 
end

shapes.roundedleft = function(cr, w, h) 
    return gears.shape.partially_rounded_rect(
        cr, w, h, 
        true, false, false, true, 4
    ) 
end

shapes.roundedright = function(cr, w, h) 
    return gears.shape.partially_rounded_rect(
        cr, w, h, 
        false, true, true, false, 4
    ) 
end

return shapes