---@class Tile : Object
local Tile = Object:new()

function Tile:init(x, y)
    self.x = x
    self.y = y
    self.w = TILE_SIZE
    self.h = TILE_SIZE

    self.tags = {
        tile = true,
    }
end

function Tile:draw()
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end

return Tile