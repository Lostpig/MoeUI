local addon, namespace = ...
local Lib = namespace.Moe.Lib

local Anime = {}
Lib.Anime = Anime

local PI = math.pi

local function NewAnimeGroup(frame, groupname)
    return frame:CreateAnimationGroup(groupname)
end
local AnimeActions = {
    Fade = function (anime, duration, order, params)
        local change = params.to - params.from
        local mode = change > 0 and "IN" or "OUT"
        
        local act = anime:CreateAnimation("ALPHA")
        act:SetOrder(order)
        act:SetDuration(duration)
        act:SetFromAlpha(params.from) 
        act:SetToAlpha(params.to) 
        --act:SetChange(change)
        act:SetSmoothing(mode)
        return act
    end,
    Flash = function (anime, duration, order, params)
        local change = params.from - params.to
        local mode1 = change > 0 and "IN" or "OUT"
        local mode2 = change > 0 and "OUT" or "IN"
        
        local act1 = anime:CreateAnimation("ALPHA")
        act1:SetOrder(order)
        act1:SetDuration(duration/2)
        act1:SetChange(change)
        act1:SetSmoothing(mode1)
        if params.delay and params.delay > 0 then act1:SetEndDelay(params.delay) end
        
        local act2 = anime:CreateAnimation("ALPHA")
        act2:SetOrder(order  + 1)
        act2:SetDuration(duration/2)
        act2:SetChange(-change)
        act2:SetSmoothing(mode2)
        
        return act2
    end,
    Move = function (anime, duration, order, params)
        local mode = params.mode or "IN"
        local act = anime:CreateAnimation("Translation")
        
        act:SetDuration(duration)
        act:SetOrder(order)
        act:SetOffset(params.x, params.y)
        act:SetSmoothing(mode)
        
        return act
    end,
    Scale = function (anime, duration, order, params)
        local act = anime:CreateAnimation("Scale")
        
        act:SetDuration(duration)
        act:SetOrder(order)
        act:SetFromScale(params.fromh, params.fromv)
        act:SetToScale(params.toh, params.tov)
        return act
    end,
    Rotation = function(anime, duration, order, params)
        local act = anime:CreateAnimation("Rotation")
        
        act:SetDuration(duration)
        act:SetOrder(order)
        act:SetRadians(params.radians) 
        return act
    end,
}
local function NewAnime(group, sets)
    local actname = sets.Action
    if AnimeActions[actname] then
        return AnimeActions[actname](group, sets.duration, sets.order, sets.params)
    end
end
Anime.New = function(frame, groupname, animelist, callback)
    frame[groupname] = NewAnimeGroup(frame, groupname)

    for i = 1, #animelist do
        if animelist[i].Action == "Rotation" and animelist[i].degrees then
            animelist[i].radians = (animelist[i].degrees/180) * PI
        end
        local newact = NewAnime(frame[groupname], animelist[i])
        
        if animelist[i].startdelay and animelist[i].startdelay > 0 then
            newact:SetStartDelay(animelist[i].startdelay)
        end
        if animelist[i].enddelay and animelist[i].enddelay > 0 then
            newact:SetEndDelay(animelist[i].enddelay)
        end
        
        if animelist[i].callback and type(animelist[i].callback) == "function" then
            newact:SetScript("OnFinished", animelist[i].callback)
        end
        if animelist[i].name then
            frame[groupname][animelist[i].name] = newact
        end
    end
    if callback and type(callback) == "function" then 
        frame[groupname]:SetScript("OnFinished", callback)
    end
end

Anime.FadeIn = function(frame, duration, from, to, callback)
    frame:SetAlpha(from)
    frame.anime = NewAnimeGroup(frame, "FadeIn")
    AnimeActions.Fade(frame.anime, duration, 1, {from = from, to = to})
    
    frame.anime:SetScript("OnFinished", function(self)
        frame:SetAlpha(to)
        if callback then callback(frame) end
    end)
    frame.anime:Play()
end
Anime.FadeOut = function(frame, duration, from, to, callback)
    frame:SetAlpha(from)
    frame.anime = NewAnimeGroup(frame, "FadeOut")
    AnimeActions.Fade(frame.anime, duration, 1, {from = from, to = to})
    
    frame.anime:SetScript("OnFinished", function(self)
        frame:SetAlpha(to)
        if callback then callback(frame) end
    end)
    frame.anime:Play()
end
Anime.Flash = function(frame, duration, from, to, delay, callback)
    frame.anime = NewAnimeGroup(frame, "Flash")
    AnimeActions.Flash(frame.anime, duration, 1, {from = from, to = to, delay = delay})
    
    frame.anime:SetScript("OnFinished", function(self)
        frame:SetAlpha(from)
        if callback then callback(frame) end
    end)
    frame.anime:Play()
end
Anime.Move = function(frame, duration, x, y, callback)
    local a1, p, a2, startx, starty = frame:GetPoint()
    frame.anime = NewAnimeGroup(frame, "Move")
    AnimeActions.Move(frame.anime, duration, 1, {x = x, y = y})
    
    frame.anime:SetScript("OnFinished", function(self)
        frame:SetPoint(a1, p, a2, startx + x, starty + y)
        if callback then callback(frame) end
    end)
    frame.anime:Play()
end
Anime.Rotation = function(frame, duration, degrees, callback)
    local radians = (degrees/180) * PI
    frame.anime = NewAnimeGroup(frame, "Move")
    AnimeActions.Move(frame.anime, duration, 1, {radians = radians})
    
    frame.anime:SetScript("OnFinished", function(self)
        frame:GetTexture():SetRotation(radians)
        if callback then callback(frame) end
    end)
    frame.anime:Play()
end

--/run MoeLib.Anime.Test()
local testf
Anime.Test = function()
    if not testf then
        testf = MoeLib.CreatePanel({
            name = "Anime_Tester",
            parent = "UIParent",	
            width = 150, height = 150,
            texture = namespace.Moe.Media.Path .. "texture\\MainButton",
            color = {1,1,1,1},
            point = {"CENTER", UIParent, "CENTER", 0, 2},
            level = 3, button = false,
        })
    end
    if not testf.anim then
        testf.anim = NewAnimeGroup(testf,"testanime")
        local a = AnimeActions.Scale(testf.anim, 2, 1, {fromv = 1, tov = 1, fromh = 1, toh = 0.05})
        a:SetScript("OnFinished",function() 
            print(testf:GetScale(), testf:GetWidth())
        end)
        AnimeActions.Scale(testf.anim, 2, 2, {fromv = 1, tov = 1, fromh = 1, toh = 20})
    end
    testf.anim:Play()
end











