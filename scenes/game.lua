local Game = {}

local Player = require("objects.player")
local Tile = require("objects.tile")

function Game:add(object, ...)
    local o = object:new()
    o:init(...)
    table.insert(self.objects, o)
    return o
end

function Game:init()
    self.objects = {}
    self:add(Player, 100, 100)
    self:add(Tile, 200, 100)
end

function Game:update(dt)
    for i = 1, #self.objects do
        local object = self.objects[i]
        if object.update then
            object:update(dt)
        end
        if object.remove then
            table.remove(self.objects, i)
        end
    end
end

function Game:draw()
    love.graphics.setColor(0.2, 0.2, 0.6)
    love.graphics.rectangle("fill", 0, 0, Res.w, Res.h)
    ResetColor()
    
    Camera:start()
    -- table.sort(self.objects, function (a, b)
    --     return a.z < b.z
    -- end)
    for i, object in ipairs(self.objects) do
        if object.draw then
            object:draw()
        end
    end

    Camera:stop()
end

return Game