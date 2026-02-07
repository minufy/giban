local Player = Object:new()

local img = NewImage("player")

function Player:init(x, y)
    self.group_name = "player"

    self.x = x
    self.y = y
    self.w = img:getWidth()
    self.h = img:getHeight()

    self.inited = false
end

function Player:update(dt)
    if not self.inited then
        self.inited = true
        Camera:offset(Res.w/2, Res.h/2)
        Camera:set(self.x-self.w/2, self.y-self.h/2)
        Camera:snap_back()
    end

    Camera:set(self.x, self.y)
    if Input.right.down then
        Physics.move_x(self, 4*dt)
    end
    if Input.left.down then
        Physics.move_x(self, -4*dt)
    end
end

function Player:draw()
    love.graphics.draw(img, self.x, self.y)
end

return Player