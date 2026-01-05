local PhysicsObject = require("objects.physics_object")

---@class Mouse : PhysicsObject
local Mouse = PhysicsObject:new()

function Mouse:init()
    self.group_name = "mouse"

    PhysicsObject.init(self)
    self.x = 0
    self.y = 0

    self.tile_x = 0
    self.tile_y = 0

    self.dx = 0
    self.dy = 0
    
    self.w = 1
    self.h = 1

    self.start_x = self.x
    self.start_y = self.y
    self.end_x = self.x
    self.end_y = self.y
    self.selection = PhysicsObject:new()
    self.selection:init()
    self.selected_objects = {}
    
    self.tile_mode = true
    self.current_name = "tile"
    self.current_i = 1
end

local function get_group_names()
    local group_names = {}
    for i, type in ipairs(OBJECT_TYPES) do
        table.insert(group_names, type)
    end
    table.insert(group_names, "img")
    return group_names
end

function Mouse:draw_selection()
    if not self.tile_mode and Input.mb[1].down then
        love.graphics.setColor(1, 1, 1, 0.2)
        love.graphics.rectangle("fill", self.selection.x, self.selection.y, self.selection.w, self.selection.h)
    end
end

function Mouse:update_selection(dt)
    if Input.mb[1].pressed then
        local col = self:col(get_group_names())
        if #col > 0 then
            self.selected_objects = col
            return
        end
    end

    if Input.mb[1].down then
        self.end_x = self.x
        self.end_y = self.y
    end

    if self.start_x < self.end_x then
        self.selection.w = self.end_x-self.start_x
        self.selection.x = self.start_x
    else
        self.selection.w = self.start_x-self.end_x
        self.selection.x = self.start_x-self.selection.w
    end
    if self.start_y < self.end_y then
        self.selection.h = self.end_y-self.start_y
        self.selection.y = self.start_y
    else
        self.selection.h = self.start_y-self.end_y
        self.selection.y = self.start_y-self.selection.h
    end
    
    if Input.mb[1].released then
        local col = self.selection:col(get_group_names())
        self.selected_objects = col
    end
end

function Mouse:draw_selected_objects()
    for i, object in ipairs(self.selected_objects) do
        love.graphics.setLineWidth(4)
        love.graphics.setColor(0, 1, 1, 0.6)
        love.graphics.rectangle("line", object.x, object.y, object.w, object.h)
    end
end

function Mouse:update_selected_objects(dt)
    if Input.mb[1].pressed then
        local col = self:col(get_group_names())
        if #col == 0 then
            self.selected_objects = {}
            return
        end
    end
    for i, object in ipairs(self.selected_objects) do
        if Input.mb[1].down then
            object.x = object.x-self.dx
            object.y = object.y-self.dy
        elseif Input.mb[1].up then
            local grid = TILE_SIZE/2
            local x = math.floor(object.x/grid+0.5)*grid
            local y = math.floor(object.y/grid+0.5)*grid
            object.x = x
            object.y = y
            if object.group_name == "img" then
                Game:move_img_object(x, y, object.key)
            else
                Game:move_object(x, y, object.key)
            end
        end
        if Input.delete.pressed then
            if object.group_name == "img" then
                Game:remove_img_object(object.key)
            else
                Game:remove_object(object.key)
            end
        end
    end
    if Input.deselect.pressed or Input.delete.pressed then
        self.selected_objects = {}
    end
end

function Mouse:update(dt)
    self.x = Res:getX()+Camera.x
    self.y = Res:getY()+Camera.y

    self.dx = self.dx-Res:getX()
    self.dy = self.dy-Res:getY()
    
    self.tile_x = math.floor(self.x/TILE_SIZE)
    self.tile_y = math.floor(self.y/TILE_SIZE)

    if Input.swap_mode.pressed then
        self.tile_mode = not self.tile_mode
        self.selected_objects = {}
        self.current_i = 1
        self:set()
    end
    
    if Input.wheel.up then
        self.current_i = self.current_i+1
        self:set()
    end
    if Input.wheel.down then
        self.current_i = self.current_i-1
        self:set()
    end

    if Input.mb[3].down then
        Camera:add(self.dx, self.dy)
    end
    
    if self.tile_mode then
        if Input.mb[1].down then
            Game:add_tile(self.tile_x, self.tile_y, self.current_name)
        elseif Input.mb[2].down then
            Game:remove_tile(self.tile_x, self.tile_y)
        end
    else
        if Input.shift.down and Input.add.pressed then
            if IMG_TABLE[self.current_name] == nil then
                Game:add_object(self.tile_x*TILE_SIZE, self.tile_y*TILE_SIZE, self.current_name)
            else
                Game:add_img_object(self.tile_x*TILE_SIZE, self.tile_y*TILE_SIZE, self.current_name)
            end
        end

        if Input.mb[1].pressed then
            self.start_x = self.x
            self.start_y = self.y
        end
        if #self.selected_objects > 0 then
            self:update_selected_objects(dt)
        else
            self:update_selection(dt)
        end
        if Input.mb[1].released then
            self.selection.w = 0
            self.selection.h = 0
        end
    end

    self.dx = Res:getX()
    self.dy = Res:getY()
end

function Mouse:draw()
    local x, y = Res:getX()+Camera.x, Res:getY()+Camera.y
    love.graphics.circle("fill", x, y, 2)
    love.graphics.setFont(Font)
    love.graphics.print(self.current_name, x+10, y+10)
    
    if #self.selected_objects > 0 then
        self:draw_selected_objects()
    else
        self:draw_selection()
    end
    ResetColor()
end

function Mouse:set()
    self:bound_i()
    self:find_name()
end

function Mouse:find_name()
    if self.tile_mode then
        self.current_name = TILE_TYPES[self.current_i]
    else
        if self.current_i > #OBJECT_TYPES then
            self.current_name = IMG_TYPES[self.current_i-#OBJECT_TYPES]
        else
            self.current_name = OBJECT_TYPES[self.current_i]
        end
    end
end

function Mouse:bound_i()
    if self.current_i < 1 then
        self.current_i = 1
    end
    if self.tile_mode then
        if self.current_i > #TILE_TYPES then
            self.current_i = #TILE_TYPES
        end
    else
        if self.current_i > #OBJECT_TYPES+#IMG_TYPES then
            self.current_i = #OBJECT_TYPES+#IMG_TYPES
        end
    end
end

return Mouse