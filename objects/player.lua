local Player = Object:new()

local img = NewImage("player")

function Player:init(x, y)
    self.group_name = "player"

    self.x = x
    self.y = y
    self.vx = 0
    self.vy = 0
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
    self.vx = 0
    if Input.right.down then
        self.vx = self.vx+3*dt
    end
    if Input.left.down then
        self.vx = self.vx-3*dt
    end
    local found = Physics.move_and_col(self)
    Physics.solve_x(self, found[1])
end

function Player:draw()
    love.graphics.draw(img, self.x, self.y)
end

return Player