---@diagnostic disable: duplicate-set-field
require("stuff.object")
require("stuff.camera")
require("stuff.input")
require("stuff.res")
require("stuff.sm")
require("stuff.utils")

function love.load()
    -- load before setting filter
    -- FontHigh = love.graphics.newFont(60)
    
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setLineStyle("rough")

    Font = love.graphics.newFont("assets/fonts/Galmuri9.ttf", 10)
    TILE_SIZE = 32

    Sounds = {}

    Res:init()
    SM:init("game")
end

local function reload()
    if CONSOLE then
        if Input.ctrl.down and Input.reload.pressed then
            require("modules.lurker").update()
        end
    end
end

function love.update(dt)
    dt = math.min(dt*60, 1.5)
    reload()
    UpdateInputs()
    Camera:update(dt)
    SM:update(dt)
    ResetWheelInput()
end

function love.draw()
    Res:before()
    SM:draw()
    Res:after()
end