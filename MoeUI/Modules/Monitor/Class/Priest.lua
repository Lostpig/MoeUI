if select(2,UnitClass("player")) ~= "PRIEST" then return end

local addon, namespace = ...
local Modules = namespace.Moe.Modules
local Lib = namespace.Moe.Lib
local Media = namespace.Moe.Media
local MM = Modules:Get("Monitor")

local PriestSet = {
    Regions = {
        ["PriestRegion"] = {
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
        size = 28, margin = 0, spacing = 4, column = 6,
        anchor = "TOP", relative = "TOP", x = 0, y = -15,
        frequentUpdates = false
    },
    ShadowOrbs = {
        width = 228, height = 8, spacing = 5,
        anchor = "TOP", relative = "TOP", x = 0, y = -2,
        texture = Media.Texture.Blank,
        customcolor = {
            [1] = {r = 0.72, g = 0.17, b = 0.96},
            [2] = {r = 0.72, g = 0.17, b = 0.96},
            [3] = {r = 0.72, g = 0.17, b = 0.96},
            [4] = {r = 0.72, g = 0.17, b = 0.96},
            [5] = {r = 0.96, g = 0.17, b = 0.34},
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
    [1] = {	--戒律
        {SpellID =  47540}, -- 苦修
        {SpellID = 129250}, -- 真言术:慰
        {SpellID =  81700}, -- 天使长
        {SpellID = 120517}, -- 光晕
        {SpellID = 110744}, -- 神圣之星
        {SpellID = 121135}, -- 瀑流
        {SpellID =  10060},	-- 能量灌注
        {SpellID =  62618}, -- 真言术：障
    },
    [3] = {	--暗影
        {SpellID =   8092},	-- 心爆
        {SpellID =  32379},	-- 灭
        {SpellID = 120644}, -- 光晕
        {SpellID = 122121}, -- 神圣之星
        {SpellID = 127632}, -- 瀑流
        {SpellID = 123040}, -- 摧心魔
        {SpellID =  34433}, -- 暗影魔
    },
}

local StylePoint = function(self, unit, powertype, maxnum)
    for i = 1 , maxnum do 
        Lib.CreateBorder(self[i], 1, {0,0,0,0}, {1,1,1,.8})
    end
end
local StyleBar = function(self, unit, powertype)
    Lib.CreateBorder(self, 1, {0,0,0,0}, {1,1,1,.8})
end

local Create = function()
    for rname, rset in next, PriestSet.Regions do
        MM:AddRegion(rname, rset)
    end
    print(123)
    local CDBar     = MM:Spawn("Cooldown",   "PriestRegion", "PriestCDBar",   PriestSet.Cooldown, CDSpellList)
    local ShadowOrb = MM:Spawn("ClassIcons", "PriestRegion", "ShadowOrbsBar", PriestSet.ShadowOrbs)
    
    ShadowOrb.PostChange = StylePoint
    --PowerBar.PostChange = StyleBar
end
local Start = function()
    MM:EnableElements("PriestRegion", "PriestCDBar", "ShadowOrbsBar")
end
local Pause = function()
    MM:DisableElements("PriestRegion", "PriestCDBar", "ShadowOrbsBar")
end

MM:AddClassSet("PRIEST", Create, Start, Pause)
