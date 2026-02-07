local Selection = require("objects.mouse.selection")

local Mouse = Object:new()

function Mouse:init()
    self.group_name = "mouse"

    self.x = 0
    self.y = 0
    self.w = 1
    self.h = 1
    
    self.tile_x = 0
    self.tile_y = 0

    self.dx = 0
    self.dy = 0
    self.selection = Selection:new()
    self.selection:init(self)
    
    self.tile_mode = true
    self.current_name = "tile"
    self.current_i = 1
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
        self.selection.selected_objects = {}
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
        Camera:snap_back()
    end
    
    if Input.mb[1].released or Input.mb[2].released or Input.delete.pressed then
        Game:undo_push()
    end
    
    if self.tile_mode then
        if Input.mb[1].down then
            Game:add_tile(self.tile_x, self.tile_y, self.current_name)
        elseif Input.mb[2].down then
            Game:remove_tile(self.tile_x, self.tile_y)
        end
    else
        if Input.shift.down and Input.mb[1].pressed then
            if IMG_TABLE[self.current_name] == nil then
                Game:add_object(self.tile_x*TILE_SIZE, self.tile_y*TILE_SIZE, self.current_name)
            else
                Game:add_img_object(self.tile_x*TILE_SIZE, self.tile_y*TILE_SIZE, self.current_name)
            end
            Game:undo_push()
        end
        self.selection:update(dt)
    end

    self.dx = Res:getX()
    self.dy = Res:getY()
end

function Mouse:draw()
    local x, y = Res:getX()+Camera.x, Res:getY()+Camera.y
    love.graphics.circle("fill", x, y, 2)
    love.graphics.setFont(Font)
    love.graphics.print(self.current_name, x+10, y+10)
    
    self.selection:draw()
    
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

-- 외부에서 접근
function Mouse:deselect_all()
    self.selection.selected_objects = {}
end

return Mouse