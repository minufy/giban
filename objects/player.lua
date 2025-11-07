local PhysicsObject = require("objects.physics_object")
local Player = PhysicsObject:new()

local img = NewImage("player")

function Player:init(x, y)
    PhysicsObject.init(self)

    self.x = x
    self.y = y
    self.w = img:getWidth()
    self.h = img:getHeight()

    Camera:offset(Res.w/2, Res.h/2)
    Camera:set(self.x, self.y)
    Camera:snap_back()

    self.tags = {
        player = true,
    }
end

function Player:update(dt)
    Camera:set(self.x, self.y)
    if Input.right.down then
        self:move_x(4*dt, "tile")
    end
    if Input.left.down then
        self:move_x(-4*dt, "tile")
    end
end

function Player:draw()
    love.graphics.draw(img, self.x, self.y)
end

return Player