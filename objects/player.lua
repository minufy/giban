local PhysicsObject = require("objects.physics_object")

---@class Player : PhysicsObject
local Player = PhysicsObject:new()

local img = NewImage("player")

function Player:init(x, y)
    PhysicsObject.init(self)

    self.x = x
    self.y = y
    self.w = img:getWidth()
    self.h = img:getHeight()

    self.camera_init = false
end

function Player:update(dt)
    if not self.camera_init then
        self.camera_init = true
        Camera:offset(Res.w/2, Res.h/2)
        Camera:set(self.x, self.y)
        Camera:snap_back()
    end

    Camera:set(self.x, self.y)
    if Input.right.down then
        self:move_x(4*dt)
    end
    if Input.left.down then
        self:move_x(-4*dt)
    end
end

function Player:draw()
    love.graphics.draw(img, self.x, self.y)
end

return Player