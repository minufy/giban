---@class Object
Object = {}

function Object:new(obj)
    obj = obj or {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end