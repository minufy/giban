---@class PhysicsObject : Object
local PhysicsObject = Object:new()

function PhysicsObject:init()
    self.x = 0
    self.y = 0
    self.w = 0
    self.h = 0
end

function PhysicsObject:dist(group_names, r)
    local found = {}
    for _, group_names in ipairs(group_names) do
        local group = Current.objects[group_names]
        if group ~= nil then
            for _, other in ipairs(Current.objects[group]) do
                if self ~= other and Dist(self, other) <= r then
                    table.insert(found, other)
                end
            end
        end
    end
    return found
end

function PhysicsObject:col(group_names)
    for _, group_names in ipairs(group_names) do
        local group = Current.objects[group_names]
        if group ~= nil then
            local col = self:col_table(group)
            if col ~= nil then
                return col
            end
        end
    end
    return nil
end

function PhysicsObject:col_table(table)
    for _, other in ipairs(table) do
        if self ~= other and AABB(self, other) then
            return other
        end
    end
    return nil
end

function PhysicsObject:move_x(x)
    self.x = self.x+x
    local tiles = Current.objects["tiles"][1]
    local around = tiles:around(math.floor(self.x/TILE_SIZE+0.5), math.floor(self.y/TILE_SIZE+0.5))
    local col = self:col_table(around)
    if col then
        if x > 0 then
            self.x = col.x-self.w
        else
            self.x = col.x+col.w
        end
    end
    return col
end

function PhysicsObject:move_y(y)
    self.y = self.y+y
    local tiles = Current.objects["tiles"][1]
    local around = tiles:around(math.floor(self.x/TILE_SIZE+0.5), math.floor(self.y/TILE_SIZE+0.5))
    local col = self:col_table(around)
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