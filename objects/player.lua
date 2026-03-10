local Player = Object:new()

local img = NewImage("player")

function Player:init(x, y)
    self.group_name = "player"

    self.x = x
    self.y = y
    self.w = img:getWidth()
    self.h = img:getHeight()

    if not Game.editing then
        Camera:offset(Res.w/2, Res.h/2)
        Camera:set(self.x-self.w/2, self.y-self.h/2)
        Camera:snap_back()
    end
end

function Player:update(dt)
    Camera:set(self.x-self.w/2, self.y-self.h/2)
    local ix = 0
    if Input.right.down then
        ix = ix+1
    end
    if Input.left.down then
        ix = ix-1
    end
    local found_x = Physics.move_and_col(self, ix*2*dt, 0)
    Physics.solve_x(self, ix, found_x[1])
end

function Player:draw()
    love.graphics.draw(img, self.x, self.y)
end

return Player