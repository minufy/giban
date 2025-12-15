---@class Tiles : Object
local Tiles = Object:new()

function Tiles:init(tiles)
    self.tiles = tiles
end

function Tiles:around(x, y)
    local found = {}
    for fx = x-1, x+1 do
        for fy = y-1, y+1 do
            if self.tiles[fx..","..fy] ~= nil then
                table.insert(found, {x = fx*TILE_SIZE, y = fy*TILE_SIZE, w = TILE_SIZE, h = TILE_SIZE})
            end
        end
    end
    return found
end

function Tiles:draw()
    for _, tile in pairs(self.tiles) do
        love.graphics.draw(TILE_IMGS[tile.type], tile.x*TILE_SIZE, tile.y*TILE_SIZE)
    end
end

return Tiles