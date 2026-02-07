local lume = require("modules.lume")

local Edit = {}

local Mouse = require("objects.mouse")

function Edit.init(self)
    self.editing = false
    self.mouse = Mouse:new()
    self.mouse:init()
    self.undo = {}
    self.undo_i = 1
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
        if Input.ctrl.down then
            if Input.undo.pressed then
                self.mouse:deselect_all()
                self:undo_undo()
            end
        end
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
    local data = {
        x = x,
        y = y,
        type = type,
    }
    self.level.objects[tostring(data):sub(8)] = data
    self:reload()
end

function Edit.add_img_object(self, x, y, type)
    local data = {
        x = x,
        y = y,
        type = type,
    }
    self.level.img_objects[tostring(data):sub(8)] = data
    self:reload()
end

function Edit.remove_object(self, key)
    self.level.objects[key] = nil
    self:reload()
end

function Edit.remove_img_object(self, key)
    self.level.img_objects[key] = nil
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

function Edit.move_object(self, x, y, key)
    self.level.objects[key].x = x
    self.level.objects[key].y = y
    self:reload()
end

function Edit.move_img_object(self, x, y, key)
    self.level.img_objects[key].x = x
    self.level.img_objects[key].y = y
    self:reload()
end

function Edit.undo_push(self)
    for i = #self.undo, self.undo_i+1, -1 do
        table.remove(self.undo, i)
    end
    table.insert(self.undo, lume.serialize(self.level))
    self.undo_i = #self.undo
end

function Edit.undo_undo(self)
    if self.undo_i-1 >= 1 then
        self.undo_i = self.undo_i-1
        self.level = lume.deserialize(self.undo[self.undo_i])
        self:reload()
    end
end

function Edit.save(self)
    local data = "return "..lume.serialize(self.level)
    local path = "assets/levels/"..self.level_index..".lua"
    local file, err = io.open(path, "w")
    if file then
        file:write(data)
        file:close()
        Log("saved to "..path)
    else
        Log(err)
    end
end

return Edit