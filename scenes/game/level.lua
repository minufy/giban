local Level = {}

local Tiles = require("objects.tiles")
local Img = require("objects.img")

TILE_TYPES = {
    "tile",
}
TILE_IMGS = {}
for i, type in ipairs(TILE_TYPES) do
    TILE_IMGS[type] = NewImage(type)
end

OBJECT_TYPES = {
    "player",
}
local object_table = {}
for i, type in ipairs(OBJECT_TYPES) do
    object_table[type] = require("objects."..type)
end

IMG_TYPES = {
    "test"
}
IMG_TABLE = {}
for i, type in ipairs(IMG_TYPES) do
    IMG_TABLE[type] = NewImage(type)
end

function Level.init(self)
    self.level_index = 1
    self:load_level()
end

function Level.load_level(self)
    self.level = require("assets.levels."..self.level_index)
    if self.level.tiles == nil then
        self.level.tiles = {}
    end
    if self.level.objects == nil then
        self.level.objects = {}
    end
    if self.level.img_objects == nil then
        self.level.img_objects = {}
    end
    self:reload()
end

function Level.reload(self)
    self.objects = {}
    self:add(Tiles, self.level.tiles)
    for k, o in pairs(self.level.objects) do
        local object = self:add(object_table[o.type], o.x, o.y)
        object.key = k
    end
    for k, o in pairs(self.level.img_objects) do
        local object = self:add(Img, o.x, o.y, o.type)
        object.key = k
    end
end

function Level.attach(Game)
    Game.load_level = Level.load_level
    Game.reload = Level.reload
end

return Level