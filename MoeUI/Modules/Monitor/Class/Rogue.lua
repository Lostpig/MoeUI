if select(2,UnitClass("player")) ~= "ROGUE" then return end

local addon, namespace = ...
local Modules = namespace.Moe.Modules
local Lib = namespace.Moe.Lib
local Media = namespace.Moe.Media
local MM = Modules:Get("Monitor")

local RogueSet = {
    Regions = {
        ["MonitorRegion"] = {
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
    CPoint = {
        width = 228, height = 8, spacing = 5,
        anchor = "TOP", relative = "TOP", x = 0, y = -2,
        texture = Media.Texture.Blank,
        customcolor = {
            [1] = {r = 0.96, g = 0.96, b = 0.04},
            [2] = {r = 0.96, g = 0.96, b = 0.04},
            [3] = {r = 0.96, g = 0.96, b = 0.04},
            [4] = {r = 0.96, g = 0.96, b = 0.04},
            [5] = {r = 0.96, g = 0.64, b = 0.04},
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
    for rname, rset in next, MonkSet.Regions do
        MM:AddRegion(rname, rset)
    end
    
    local CDBar      = MM:Spawn("Cooldown"  , "MonitorRegion", "CDBar"  , RogueSet.Cooldown, CDSpellList)
    local CpointsBar = MM:Spawn("ClassIcons", "MonitorRegion", "Cpoints", RogueSet.CPoint)
    local PowerBar   = MM:Spawn("Power"     , "MonitorRegion", "Power"  , RogueSet.Power)
    
    CpointsBar.PostChange = StylePoint
    PowerBar.PostChange = StyleBar
end
local Start = function()
    MM:EnableElements("MonitorRegion", "CDBar", "Cpoints", "Power")
end
local Pause = function()
    MM:DisableElements("MonitorRegion", "CDBar", "Cpoints", "Power")
end

MM:AddClassSet("ROGUE", Create, Start, Pause)