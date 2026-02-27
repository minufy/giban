local Physics = {}

function Physics.dist(self, group_names, r)
    local found_all = {}
    for _, group_name in ipairs(group_names) do
        local group = Game.objects[group_name]
        if group ~= nil then
            for _, other in ipairs(group) do
                if self ~= other and Dist(self, other) <= r then
                    table.insert(found_all, other)
                end
            end
        end
    end
    return found_all
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

function Physics.solve_x(self, col)
    if col then
        if self.vx > 0 then
            self.x = col.x-self.w
        else
            self.x = col.x+col.w
        end
    end
end

function Physics.solve_y(self, col)
    if col then
        if self.vy > 0 then
            self.y = col.y-self.h
        else
            self.y = col.y+col.h
        end
    end
end

function Physics.move_and_col(self, layers)
    self.x = self.x+self.vx
    self.y = self.y+self.vy
    layers = layers or {1}
    local found_all = {}
    for i, layer in ipairs(layers) do
        local tiles = Game.objects["tiles"][layer]
        local around = tiles:around(math.floor(self.x/TILE_SIZE+0.5), math.floor(self.y/TILE_SIZE+0.5))
        local found = Physics.col_group(self, around)
        for _, other in ipairs(found) do
            table.insert(found_all, other)
        end
    end
    return found_all
end

return Physics