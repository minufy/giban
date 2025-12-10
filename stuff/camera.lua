Camera = {}
Camera.offset_x = 0
Camera.offset_y = 0
Camera.target_x = 0
Camera.target_y = 0
Camera.x = 0
Camera.y = 0
Camera.damp_x = 0.1
Camera.damp_y = 0.1
Camera.shake_damp = 0.1
Camera.shake_x = 0
Camera.shake_y = 0
Camera.shake_duration = 0
Camera.on = false

function Camera:set(x, y)
    self.target_x = x
    self.target_y = y
end

function Camera:offset(x, y)
    self.offset_x = x
    self.offset_y = y
end

function Camera:snap_back()
    self.x = -self.offset_x+self.target_x
    self.y = -self.offset_y+self.target_y
end

function Camera:shake(dur)
    self.shake_duration = dur
end

function Camera:start()
    love.graphics.push()
    if self.shake_duration > 0.1 then
        love.graphics.translate(self.shake_x, self.shake_y)
    end
    love.graphics.translate(-self.x, -self.y)
    self.on = true
end

function Camera:stop()
    love.graphics.pop()
    self.on = false
end

function Camera:update(dt)
    if self.shake_duration > 0.1 then
        self.shake_x = math.random(-self.shake_duration, self.shake_duration)
        self.shake_y = math.random(-self.shake_duration, self.shake_duration)
    end
    self.shake_duration = self.shake_duration+(0-self.shake_duration)*self.shake_damp*dt
    
    self.x = self.x+(-self.offset_x+self.target_x-self.x)*self.damp_x*dt
    self.y = self.y+(-self.offset_y+self.target_y-self.y)*self.damp_y*dt
end