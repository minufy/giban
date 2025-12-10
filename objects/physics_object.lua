---@class PhysicsObject:Object
local PhysicsObject = Object:new()

function PhysicsObject:init(x, y, w, h)
    self.x = x or 0
    self.y = y or 0
    self.w = w or 0
    self.h = h or 0
end

function PhysicsObject:dist(tag, r)
    local found = {}
    for _, other in ipairs(Current.objects) do
        if other.tags[tag] then
            if self ~= other and Dist(self, other, r) then
                table.insert(found, other)
            end
        end
    end
    return found
end

function PhysicsObject:col(tag)
    for _, other in ipairs(Current.objects) do
        if other.tags[tag] then
            if self ~= other and AABB(self, other) then
                return other
            end
        end
    end
    return nil
end

function PhysicsObject:move_x(x, tag)
    self.x = self.x+x
    local col = self:col(tag)
    if col then
        if x > 0 then
            self.x = col.x-self.w
        else
            self.x = col.x+col.w
        end
    end
    return col
end

function PhysicsObject:move_y(y, tag)
    self.y = self.y+y
    local col = self:col(tag)
    if col then
        if y > 0 then
            self.y = col.y-self.h
        else
            self.y = col.y+col.h
        end
    end
    return col
end

return PhysicsObject