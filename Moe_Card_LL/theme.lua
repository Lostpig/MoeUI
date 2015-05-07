local _, ns = ...
local Moe = _G["Moe"]
local Card = Moe.Modules:Get("Card")

local stylepanel
local function Style(frame)
    if not stylepanel then 
        stylepanel = Moe.Lib.CreatePanel({
            name = "LLCard_Bottom",
            parent = "UIParent",	
            width = 150, height = 2,
            texture = Moe.Media.Bar.GradCE,
            color = {1,1,1,.9},
            point = {"TOP", frame, "BOTTOM", 0, 2},
            level = 3, button = false,
        })
    end
end

local LLTheme = {
    name = "Love Live!",
    path = "Interface\\Addons\\Moe_Card_LL\\Cards\\",
    randomcard = true,
    cardcount = 9,
    speed = 0.9,
    
    height = 160,
    width = 160,
    color = {1,0.9,0.8},
    showfont = true,
    font = Moe.Media.Fonts.T,
    fontsize = 16,
    fontflag = "OUTLINE",
    fontpos= {"BOTTOM", 0, -17},
    fontcolor = {1,.9,0},
    SetTheme = Style,
}

Card.Main:RegisterTheme("LoveLive", LLTheme)