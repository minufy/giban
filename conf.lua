WINDOW_W = 1280
WINDOW_H = 720
CONSOLE = true

function love.conf(t)
    t.window.resizable = true
    t.console = CONSOLE
    t.window.width = WINDOW_W
    t.window.height = WINDOW_H
end