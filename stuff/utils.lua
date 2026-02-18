function rgb(r, g, b)
    return {r/255, g/255, b/255}
end

function rgba(r, g, b, a)
    return {r/255, g/255, b/255, a}
end

function Alpha(rgb, a)
    return {rgb[1], rgb[2], rgb[3], a}
end

function ResetColor()
    love.graphics.setColor(1, 1, 1, 1)
end

function Dist(a, b)
    local ax = a.x+a.w/2
    local ay = a.y+a.h/2
    local bx = b.x+b.w/2
    local by = b.y+b.h/2
    return math.sqrt((ax-bx)^2+(ay-by)^2)
end

function Sign(x)
    if x > 0 then
        return 1
    elseif x < 0 then
        return -1
    end
    return 0
end

function AABB(a, b)
    return a.x < b.x+b.w and
           b.x < a.x+a.w and
           a.y < b.y+b.h and
           b.y < a.y+a.h
end

Logs = {}
LogTime = 240
function Log(...)
    local text = os.date().." : "
    for i, t in ipairs({...}) do
        text = text..t.." "
    end
    table.insert(Logs, {text=text, timer=0})
    print(text)
end

function DrawLog()
    love.graphics.setFont(LogFont)
    for i, log in ipairs(Logs) do
        love.graphics.setColor(1, 1, 1, 1-log.timer/LogTime)
        love.graphics.print(log.text, 0, (#Logs-i)*LogFont:getHeight())
    end
    ResetColor()
end

function UpdateLog(dt)
    for i=#Logs, 1, -1 do
        Logs[i].timer = Logs[i].timer+dt
        if Logs[i].timer > LogTime then
            table.remove(Logs, i)
        end
    end
end

function NewImage(name)
    local path = "assets/imgs/"..name..".png"
    if love.filesystem.getInfo(path) then
        return love.graphics.newImage(path)
    else
        Log("failed to load "..path)
        return love.graphics.newImage("assets/imgs/error.png")
    end 
end

function NewSound(name, volume)
    volume = volume or 0.5
    local sound = {
        source = love.audio.newSource("assets/sounds/"..name..".ogg", "static"),
        volume = volume
    }
    function sound:play(v)
        v = v or self.volume
        self.source:setVolume(v)
        self.source:stop()
        self.source:play()
    end
    Sounds[name] = sound
    return sound
end