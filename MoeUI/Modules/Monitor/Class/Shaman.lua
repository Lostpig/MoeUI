if select(2,UnitClass("player")) ~= "SHAMAN" then return end

local addon, namespace = ...
local Modules = namespace.Moe.Modules
local Lib = namespace.Moe.Lib
local Media = namespace.Moe.Media
local MM = Modules:Get("Monitor")

local ShamanSet = {
    Regions = {
        ["ShamanRegion"] = {
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
        anchor = "TOP", relative = "TOP", x = 0, y = -2,
        frequentUpdates = false
    },
    Power = {
        unit = "player",
        width = 228, height = 6, 
        anchor = "TOP", relative = "TOP", x = 0, y = -15,
        frequentUpdates = false,
    }
}

local CDSpellList = {
    --[1] = {	--ÔªËØ    },
    [2] = {	--ÔöÇ¿
        {SpellID = 17364}, -- ·ç±©´ò»÷
        {SpellID = 60103}, -- ÈÛÑÒÃÍ»÷
        {SpellID =  8050}, -- ÁÒÑæÕð»÷
        {SpellID = 73680}, -- ÔªËØÊÍ·Å
        --{SpellID = 73680}, -- ÔªËØÊÍ·Å
    },
    --[3] = {   --»Ö¸´    },
}

local StyleBar = function(self, unit, powertype)
    Lib.CreateBorder(self, 1, {0,0,0,0}, {1,1,1,.8})
end

local Create = function()
    for rname, rset in next, ShamanSet.Regions do
        MM:AddRegion(rname, rset)
    end
    
    local CDBar = MM:Spawn("Cooldown", "ShamanRegion", "ShamanCDBar", ShamanSet.Cooldown, CDSpellList)
end
local Start = function()
    MM:EnableElements("ShamanRegion", "ShamanCDBar")
end
local Pause = function()
    MM:DisableElements("ShamanRegion", "ShamanCDBar")
end

MM:AddClassSet("SHAMAN", Create, Start, Pause)

