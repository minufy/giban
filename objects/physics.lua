local Physics = {}

function Physics.dist(self, group_names, r)
    local found = {}
    for _, group_name in ipairs(group_names) do
        local group = Game.objects[group_name]
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

function Physics.col(self, group_names)
    local found_all = {}
    for _, group_name in ipairs(group_names) do
        local group = Game.objects[group_name]
        if group ~= nil then
            local found = Physics.col_group(self, group)
            for _, other in ipairs(found) do
                table.insert(found_all, other)
            end
        end
    end
    return found_all
end

function Physics.col_group(self, group)
    local found = {}
    for _, other in ipairs(group) do
        if self ~= other and AABB(self, other) then
            table.insert(found, other)
        end
    end
    return found
end

function Physics.solve_x(self, x, col)
    if col then
        if x > 0 then
            self.x = col.x-self.w
        else
            self.x = col.x+col.w
        end
    end
end

function Physics.solve_y(self, y, col)
    if col then
        if y > 0 then
            self.y = col.y-self.h
        else
            self.y = col.y+col.h
        end
    end
end

function Physics.move_x(self, x, f)
    local ox = self.x
    self.x = self.x+x
    local tiles = Game.objects["tiles"][1]
    local around = tiles:around(math.floor(self.x/TILE_SIZE+0.5), math.floor(self.y/TILE_SIZE+0.5))
    local col = Physics.col_group(self, around)[1]
    if f ~= nil then
        local col_f = f()
        if #col_f > 0 then
            table.sort(col_f, function (a, b)
                return math.abs(a.x-ox) < math.abs(b.x-ox)
            end)
            col = col or col_f[1]
        end
    end
    Physics.solve_x(self, x, col)
    return col
end

function Physics.move_y(self, y, f)
    local oy = self.y
    self.y = self.y+y
    local tiles = Game.objects["tiles"][1]
    local around = tiles:around(math.floor(self.x/TILE_SIZE+0.5), math.floor(self.y/TILE_SIZE+0.5))
    local col = Physics.col_group(self, around)[1]
    if f ~= nil then
        local col_f = f()
        if #col_f > 0 then
            table.sort(col_f, function (a, b)
                return math.abs(a.y-oy) < math.abs(b.y-oy)
            end)
            col = col or col_f[1]
        end
    end
    Physics.solve_y(self, y, col)
    return col
end

return Physics