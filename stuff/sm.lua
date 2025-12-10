SM = {}
Current = nil

function SM:load(name)
    Current = require("scenes."..name)
    Current:init()
end

function SM:update(dt)
    Current:update(dt)
end

function SM:draw()
    Current:draw()
end