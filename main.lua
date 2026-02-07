Object = require("stuff.object")
Physics = require("objects.physics")
Particle = require("objects.particle")
require("stuff.camera")
require("stuff.input")
require("stuff.res")
require("stuff.sm")
require("stuff.utils")

function love.load()
    LogFont = love.graphics.newFont(20)
    
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setLineStyle("rough")

    Font = love.graphics.newFont("assets/fonts/Galmuri9.ttf", 10)
    TILE_SIZE = 32

    Sounds = {}
    -- NewSound("jump")

    Res:init()
    SM:load("game.game")
end

function love.update(dt)
    dt = math.min(dt*60, 1.5)
    UpdateInputs()
    Camera:update(dt)
    SM:update(dt)
    ResetWheelInput()
    UpdateLog(dt)
end

function love.draw()
    Res:before()
    SM:draw()
    Res:after()
    DrawLog()
end