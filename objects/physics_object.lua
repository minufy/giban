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
        local group = Game.objects[group_names]
        if group ~= nil then
            for _, other in ipairs(group) do
                if self ~= other and Dist(self, other) <= r then
                    table.insert(found, other)
                end
            end
        end
    end
    return found
end

function PhysicsObject:col(group_names)
    local found_all = {}
    for _, group_names in ipairs(group_names) do
        local group = Game.objects[group_names]
        if group ~= nil then
            local found = self:col_group(group)
            for _, other in ipairs(found) do
                table.insert(found_all, other)
            end
        end
    end
    return found_all
end

function PhysicsObject:col_group(group)
    local found = {}
    for _, other in ipairs(group) do
        if self ~= other and AABB(self, other) then
            table.insert(found, other)
        end
    end
    return found
end

function PhysicsObject:solve_x(x, col)
    if col then
        if x > 0 then
            self.x = col.x-self.w
        else
            self.x = col.x+col.w
        end
    end
end

function PhysicsObject:solve_y(y, col)
    if col then
        if y > 0 then
            self.y = col.y-self.h
        else
            self.y = col.y+col.h
        end
    end
end

function PhysicsObject:move_x(x, f)
    local ox = self.x
    self.x = self.x+x
    local tiles = Game.objects["tiles"][1]
    local around = tiles:around(math.floor(self.x/TILE_SIZE+0.5), math.floor(self.y/TILE_SIZE+0.5))
    local col = self:col_group(around)[1]
    if f ~= nil then
        local col_f = f()
        if #col_f > 0 then
            table.sort(col_f, function (a, b)
                return math.abs(a.x-ox) < math.abs(b.x-ox)
            end)
            col = col or col_f[1]
        end
    end
    self:solve_x(x, col)
    return col
end

function PhysicsObject:move_y(y, f)
    local oy = self.y
    self.y = self.y+y
    local tiles = Game.objects["tiles"][1]
    local around = tiles:around(math.floor(self.x/TILE_SIZE+0.5), math.floor(self.y/TILE_SIZE+0.5))
    local col = self:col_group(around)[1]
    if f ~= nil then
        local col_f = f()
        if #col_f > 0 then
            table.sort(col_f, function (a, b)
                return math.abs(a.y-oy) < math.abs(b.y-oy)
            end)
            col = col or col_f[1]
        end
    end
    self:solve_y(y, col)
    return col
end

return PhysicsObject