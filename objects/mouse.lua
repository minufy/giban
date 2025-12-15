local PhysicsObject = require("objects.physics_object")

---@class Mouse : PhysicsObject
local Mouse = PhysicsObject:new()

function Mouse:init()
    PhysicsObject.init(self)
    self.x = 0
    self.y = 0

    self.tile_x = 0
    self.tile_y = 0

    self.dx = 0
    self.dy = 0
    
    self.w = 1
    self.h = 1

    self.tile_mode = true
    self.current_name = "tile"
    self.current_i = 1
end

function Mouse:update(dt)
    self.x = Res:getX()+Camera.x
    self.y = Res:getY()+Camera.y

    self.tile_x = math.floor(self.x/TILE_SIZE)
    self.tile_y = math.floor(self.y/TILE_SIZE)
    
    if Input.swap_mode.pressed then
        self.tile_mode = not self.tile_mode
        self.current_i = 1
        self:bound_i()
        self:find_name()
    end

    if Input.mb[3].down then
        self.dx = self.dx-Res:getX()
        self.dy = self.dy-Res:getY()
        Camera:add(self.dx, self.dy)
    end
    self.dx = Res:getX()
    self.dy = Res:getY()

    if self.tile_mode then
        if Input.mb[1].down then
            Current:add_tile(self.tile_x, self.tile_y, self.current_name)
        elseif Input.mb[2].down then
            Current:remove_tile(self.tile_x, self.tile_y)
        end
    else
        if Input.mb[1].pressed then
            Current:add_object(self.x, self.y, self.current_name)
        elseif Input.mb[2].pressed then
            local col = self:col({self.current_name})
            if col ~= nil then
                Current:remove_object(col.key)
            end
        end
    end
end

function Mouse:draw()
    love.graphics.circle("fill", Res:getX(), Res:getY(), 2)
    love.graphics.print(self.current_name)
end

function Mouse:find_name()
    if self.tile_mode then
        self.current_name = TILE_TYPES[self.current_i]
    else
        self.current_name = OBJECT_TYPES[self.current_i]
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
        if self.current_i > #OBJECT_TYPES then
            self.current_i = #OBJECT_TYPES
        end
    end
end

return Mouse