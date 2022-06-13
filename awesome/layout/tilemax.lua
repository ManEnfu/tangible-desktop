local mouse = mouse
local screen = screen
local mousegrabber = mousegrabber


local tilemax = {}

-- Similar to tile layout, but the windows in each region are stacked in 
-- max/monocle layout

tilemax.name = "tilemax"

local function apply_size_hints(c, width, height, useless_gap)
    local bw = c.border_width
    width, height = width - 2 * bw - useless_gap, height - 2 * bw - useless_gap
    width, height = c:apply_size_hints(math.max(1, width), math.max(1, height))
    return width + 2 * bw + useless_gap, height + 2 * bw + useless_gap
end

function do_tilemax(param)
    local t = param.tag or screen[param.screen].selected_tag


    local gs = param.geometries
    local cls = param.clients
    if #cls == 0 then return end
    local useless_gap = param.useless_gap
    local nmaster = math.min(t.master_count, #cls)
    local nother = math.max(#cls - nmaster,0)

    local mwfact = t.master_width_factor
    local wa = param.workarea
    local ncol = t.column_count

    -- local data = tag.getdata(t).windowfact

    -- if not data then
    --     data = {}
    --     tag.getdata(t).windowfact = data
    -- end

    local coord = wa.x

    -- Master region width
    local master_width = wa.width
    local stack_width = 0
    if nother > 0 then
        master_width = math.max(math.floor(wa.width * mwfact), 1)
        stack_width = wa.width - master_width
    end

    -- Arrange master region
    for i = 1, nmaster do
        local c = cls[i]
        local geom = {}
        geom.width = master_width
        geom.height = wa.height
        geom.x = wa.x
        geom.y = wa.y
        gs[c] = geom
    end

    -- Arrange stack
    for i = nmaster+1, nmaster+nother do
        local c = cls[i]
        local geom = {}
        geom.width = stack_width
        geom.height = wa.height
        geom.x = master_width + math.floor(useless_gap / 2)
        geom.y = wa.y
        gs[c] = geom
    end
end

function tilemax.skip_gap(nclients, t)
    return nclients == 1 and t.master_fill_policy == "expand"
end

function tilemax.arrange(p)
    do_tilemax(p)
end

return tilemax
