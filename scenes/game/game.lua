Game = {}

local Edit = require("scenes.game.edit")
Game.remove_tile = Edit.remove_tile
Game.add_tile = Edit.add_tile
Game.remove_object = Edit.remove_object
Game.remove_img_object = Edit.remove_img_object
Game.add_object = Edit.add_object
Game.add_img_object = Edit.add_img_object
Game.move_object = Edit.move_object
Game.move_img_object = Edit.move_img_object
Game.save = Edit.save

local Level = require("scenes.game.level")
Game.load_level = Level.load_level
Game.reload = Level.reload

function Game:add(object, ...)
    local o = object:new()
    o:init(...)
    local group_name = o.group_name
    if self.objects[group_name] == nil then
        self.objects[group_name] = {}
    end
    table.insert(self.objects[group_name], o)
    return o
end

function Game:init()
    self.objects = {}
    Edit.init(self)
    Level.init(self)
end

function Game:update(dt)
    Edit.update(self, dt)

    if not self.editing then
        for group_name, _ in pairs(self.objects) do
            for i = #self.objects[group_name],  1, -1 do
                local object = self.objects[group_name][i]
                if object.update then
                    object:update(dt)
                end
                if object.remove then
                    table.remove(self.objects[group_name], i)
                end
            end
        end
    end
end

function Game:draw()
    love.graphics.setColor(rgb(49, 77, 121))
    love.graphics.rectangle("fill", 0, 0, Res.w, Res.h)
    ResetColor()
    
    Camera:start()
    
    for group_name, group in pairs(self.objects) do
        for _, object in ipairs(group) do
            if object.draw then
                object:draw()
            end
        end
    end
    
    if self.editing then
        Edit.draw(self)
    end

    Camera:stop()
end

return Game