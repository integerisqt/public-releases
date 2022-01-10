local Render = {}


local camera = workspace.CurrentCamera
local SETRENDERPROPERTY
local GETRENDERPROPERTY
local CREATERENDEROBJECT
local DESTROYRENDEROBJECT


local garbage = setmetatable({}, {
    __newindex = function(self, drawingObject, ...)
        task.spawn(function()
            runService.RenderStepped:Wait()
            DESTROYRENDEROBJECT(drawingObject)
            rawset(self, drawingObject, nil)
            drawingObject = nil
        end)
    end
})
do
    local upvals = debug.getupvalues(Drawing.new)
    local function getLastIdxOfTable(tbl)
        local last
        for i,v in next, tbl do
            last = i
        end
        return last
    end
    for i,v in next, upvals do
        if DESTROYRENDEROBJECT and GETRENDERPROPERTY and SETRENDERPROPERTY and CREATERENDEROBJECT then
            break
        end
        if type(v) == "table" then
            if rawget(v, "__type") then
                local __index = v.__index
                local __newindex = v.__newindex

                local iUpvals = debug.getupvalues(__index)

                for i2,v2 in next, iUpvals do
                    if type(v2) == "function" then
                        local suc, err = pcall(v2)
                        if not suc and type(err) == "string" and err:find("render object") and not GETRENDERPROPERTY then
                            GETRENDERPROPERTY = v2
                        end
                    end
                end
                for i2,v2 in next, debug.getupvalues(__newindex) do
                    if type(v2) == "function" then
                        local suc, err = pcall(v2)
                        if not suc and type(err) == "string" and err:find("render object") and not SETRENDERPROPERTY then
                            SETRENDERPROPERTY = v2
                        end
                    end
                end
                if not DESTROYRENDEROBJECT then
                    DESTROYRENDEROBJECT = iUpvals[getLastIdxOfTable(iUpvals) - 1]
                end
            end
        elseif type(v) == "function" then
            local suc, err = pcall(v, "bait")
            if not suc and type(err) == "string" and err:find("type does not exist") and not CREATERENDEROBJECT then
                CREATERENDEROBJECT = v
            end
        end
    end
end
do
    function Render.Rect(x, y, width, height, thickness, color, alpha)
        local rect = CREATERENDEROBJECT("Square")
        SETRENDERPROPERTY(rect, "Position", Vector2.new(x, y))
        SETRENDERPROPERTY(rect, "Size", Vector2.new(width, height))
        SETRENDERPROPERTY(rect, "Thickness", thickness)
        SETRENDERPROPERTY(rect, "Color", color)
        SETRENDERPROPERTY(rect, "Transparency", alpha/255)
        SETRENDERPROPERTY(rect, "Filled", false)
        SETRENDERPROPERTY(rect, "Visible", true)
        garbage[rect] = true
    end

    function Render.Line(x, y, x1, y1, thickness, color, alpha)
        local line = CREATERENDEROBJECT("Line")
        SETRENDERPROPERTY(line, "From", Vector2.new(x, y))
        SETRENDERPROPERTY(line, "To", Vector2.new(x1, y1))
        SETRENDERPROPERTY(line, "Thickness", thickness)
        SETRENDERPROPERTY(line, "Color", color)
        SETRENDERPROPERTY(line, "Transparency", alpha/255)
        SETRENDERPROPERTY(line, "Visible", true)
        garbage[line] = true
    end

    function Render.GetScreenSize()
        return camera.ViewportSize
    end

    function Render.Circle(x, y, r, color, alpha)
        local circle = CREATERENDEROBJECT("Circle")
        SETRENDERPROPERTY(circle, "Position", Vector2.new(x, y))
        SETRENDERPROPERTY(circle, "Radius", r)
        SETRENDERPROPERTY(circle, "Color", color)
        SETRENDERPROPERTY(circle, "Transparency", alpha/255)
        SETRENDERPROPERTY(circle, "Filled", false)
        garbage[circle] = true
    end
end

return Render
