local lume = require("modules.lume")

local Edit = {}

local Mouse = require("objects.mouse")

function Edit.init(self)
    self.editing = false
    self.mouse = Mouse:new()
    self.mouse:init()
end

function Edit.update(self, dt)
    if CONSOLE then
        if Input.toggle_editor.pressed then
            self.editing = not self.editing
        end
        if Input.ctrl.down then
            if Input.save.pressed then
                self:save()
            end
        end
    end
    
    if self.editing then
        self.mouse:update(dt)
        
        -- if Input.right.pressed then
        --     self.level_index = self.level_index+1
        --     if self.level_index == 0 then
        --         self.level_index = 1
        --     end
        --     self:load_level()
        -- end
        -- if Input.left.pressed then
        --     self.level_index = self.level_index-1
        --     self:load_level()
        -- end
    end
end

function Edit.draw(self)
    self.mouse:draw()
end

function Edit.add_object(self, x, y, type)
    self.level.objects[x..","..y..","..type] = {
        x = x,
        y = y,
        type = type,
    }
    self:reload()
end

function Edit.remove_object(self, key)
    self.level.objects[key] = nil
    self:reload()
end

function Edit.remove_tile(self, x, y)
    self.level.tiles[x..","..y] = nil
    self:reload()
end

function Edit.add_tile(self, x, y, type)
    self.level.tiles[x..","..y] = {
        x = x,
        y = y,
        type = type
    }
    self:reload()
end

function Edit.save(self)
    local data = "return "..lume.serialize(self.level)
    local path = "assets/levels/"..self.level_index..".lua"
    local file, err = io.open(path, "w")
    if file then
        file:write(data)
        file:close()
        print("saved to "..path)
    else
        print(err)
    end
end

function Edit.attach(Game)
    Game.remove_tile = Edit.remove_tile
    Game.add_tile = Edit.add_tile
    Game.remove_object = Edit.remove_object
    Game.add_object = Edit.add_object
    Game.save = Edit.save
end

return Edit