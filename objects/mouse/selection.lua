local Selection = Object:new()

function Selection:init(mouse)
    self.mouse = mouse

    self.x = 0
    self.y = 0
    self.w = 0
    self.h = 0

    self.start_x = self.x
    self.start_y = self.y
    self.end_x = self.x
    self.end_y = self.y
    self.selected_objects = {}
end

local function get_group_names()
    local group_names = {}
    for i, type in ipairs(OBJECT_TYPES) do
        table.insert(group_names, type)
    end
    table.insert(group_names, "img")
    return group_names
end

function Selection:draw_selection()
    if not self.mouse.tile_mode and Input.mb[1].down then
        love.graphics.setColor(1, 1, 1, 0.2)
        love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    end
end

function Selection:update_selection(dt)
    if Input.mb[1].pressed then
        local col = self.mouse:col(get_group_names())
        if #col > 0 then
            self.selected_objects = {col[1]}
            return
        end
    end

    if Input.mb[1].down then
        self.end_x = self.mouse.x
        self.end_y = self.mouse.y
    end

    if self.start_x < self.end_x then
        self.w = self.end_x-self.start_x
        self.x = self.start_x
    else
        self.w = self.start_x-self.end_x
        self.x = self.start_x-self.w
    end
    if self.start_y < self.end_y then
        self.h = self.end_y-self.start_y
        self.y = self.start_y
    else
        self.h = self.start_y-self.end_y
        self.y = self.start_y-self.h
    end
    
    if Input.mb[1].released then
        local col = Physics.col(self, get_group_names())
        self.selected_objects = col
    end
end

function Selection:draw_selected_objects()
    for i, object in ipairs(self.selected_objects) do
        love.graphics.setLineWidth(2)
        love.graphics.setColor(0, 1, 1, 0.6)
        love.graphics.rectangle("line", object.x, object.y, object.w, object.h)
    end
end

function Selection:update_before_selected_objects()
    if Input.mb[1].pressed then
        local col = Physics.col(self.mouse, get_group_names())
        if #col <= 0 then
            self.selected_objects = {}
            return
        end
        
        if Input.ctrl.down then
            local existed = false
            for i, object in ipairs(self.selected_objects) do
                if object.key == col[1].key then
                    existed = true
                    table.remove(self.selected_objects, i)
                    break
                end
            end
            if not existed then
                table.insert(self.selected_objects, col[1])
            end
        else
            if #self.selected_objects <= 1 then
                self.selected_objects = {}
                table.insert(self.selected_objects, col[1])
            end
        end
    end
end

function Selection:update_selected_objects(dt)
    for i, object in ipairs(self.selected_objects) do
        if Input.mb[1].down then
            object.x = object.x-self.mouse.dx
            object.y = object.y-self.mouse.dy
        elseif Input.mb[1].up then
            local grid = TILE_SIZE/2
            local x = math.floor(object.x/grid+0.5)*grid
            local y = math.floor(object.y/grid+0.5)*grid
            object.x = x
            object.y = y
            if object.group_name == "img" then
                Game:move_img_object(x, y, object.key)
            else
                Game:move_object(x, y, object.key)
            end
        end
        if Input.delete.pressed then
            if object.group_name == "img" then
                Game:remove_img_object(object.key)
            else
                Game:remove_object(object.key)
            end
        end
    end
    if Input.deselect.pressed or Input.delete.pressed then
        self.selected_objects = {}
    end
end

function Selection:update(dt)
    if Input.mb[1].pressed then
        self.start_x = self.mouse.x
        self.start_y = self.mouse.y
    end
    if #self.selected_objects > 0 then
        self:update_before_selected_objects()
        self:update_selected_objects(dt)
    else
        self:update_selection(dt)
    end
    if Input.mb[1].released then
        self.w = 0
        self.h = 0
    end
end

function Selection:draw()
    if #self.selected_objects > 0 then
        self:draw_selected_objects()
    else
        self:draw_selection()
    end
end

return Selection