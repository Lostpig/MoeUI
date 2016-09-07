if select(2,UnitClass("player")) ~= "MONK" then return end

local addon, namespace = ...
local Modules = namespace.Moe.Modules
local Lib = namespace.Moe.Lib
local Media = namespace.Moe.Media
local MM = Modules:Get("Monitor")

local MonkSet = {
    Regions = {
        ["MonkRegion"] = {
            width = 232,
            height = 42,
            fadecombat = true, 
            showcombat = false,
            bg = {
                texture = Media.Texture.Blank,
                color = { r = .2, g = .2, b = .2, a = 0}
            },
            point = {
                anchor = "BOTTOM", relative = "CENTER", parent = "UIParent",
                x = 0, y = -126,
            }
        }
    }, 
    Cooldown = {
        size = 25, margin = 0, spacing = 4, column = 8,
        anchor = "TOP", relative = "TOP", x = 0, y = -15,
        frequentUpdates = false
    },
    Chi = {
        width = 228, height = 8, spacing = 5,
        anchor = "TOP", relative = "TOP", x = 0, y = -2,
        texture = Media.Texture.Blank,
        customcolor = {
            [1] = {r = 0.16, g = 0.96, b = 0.04},
            [2] = {r = 0.64, g = 0.96, b = 0.04},
            [3] = {r = 0.96, g = 0.96, b = 0.04},
            [4] = {r = 0.96, g = 0.32, b = 0.04},
            [5] = {r = 0.96, g = 0.04, b = 0.04},
            [6] = {r = 0.96, g = 0.04, b = 0.84},
        }
    },
    Power = {
        unit = "player",
        width = 228, height = 6, 
        anchor = "TOP", relative = "TOP", x = 0, y = -15,
        frequentUpdates = false,
    }
}
local CDSpellList = {
    [2] = {	--织雾

    },
    [3] = { --踏风
        {SpellID =  107428}, -- 旭日东升踢
        {SpellID =  113656}, -- 怒雷破
        {SpellID =  115080}, -- 轮回之触
        {SpellID =  152175}, -- 升龙霸
        {SpellID =  123904}, -- 白虎
		{SpellID =  205320}, -- 风领主之击
    },
}

local StylePoint = function(self, unit, powertype, maxnum)
    for i = 1 , maxnum do 
        Lib.CreateBorder(self.points[i], 1, {0,0,0,0}, {1,1,1,.8})
    end
end
local StyleBar = function(self, unit, powertype)
    Lib.CreateBorder(self, 1, {0,0,0,0}, {1,1,1,.8})
end

local Create = function()
    for rname, rset in next, MonkSet.Regions do
        MM:AddRegion(rname, rset)
    end
    
    local CDBar    = MM:Spawn("Cooldown",   "MonkRegion", "MonkCDBar", MonkSet.Cooldown, CDSpellList)
    local ChiBar   = MM:Spawn("ClassIcons", "MonkRegion", "MonkChi",   MonkSet.Chi)
    --local PowerBar = MM:Spawn("Power"   , "MonkRegion", "MonkPower", MonkSet.Power)
    
    ChiBar.PostChange = StylePoint
    --PowerBar.PostChange = StyleBar
end
local Start = function()
    MM:EnableElements("MonkRegion", "MonkCDBar", "MonkChi")
end
local Pause = function()
    MM:DisableElements("MonkRegion", "MonkCDBar", "MonkChi")
end

MM:AddClassSet("MONK", Create, Start, Pause)