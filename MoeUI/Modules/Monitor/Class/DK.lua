if select(2,UnitClass("player")) ~= "DEATHKNIGHT" then return end

local addon, namespace = ...
local Modules = namespace.Moe.Modules
local Lib = namespace.Moe.Lib
local Media = namespace.Moe.Media
local MM = Modules:Get("Monitor")

local DKSet = {
    Regions = {
        ["DKRegion"] = {
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
    Rune = {
        width = 228, height = 8, spacing = 5,
        anchor = "TOP", relative = "TOP", x = 0, y = -2,
        texture = Media.Texture.Blank
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
        Lib.CreateBorder(self.points[i], 1, {0,0,0,0}, {1,1,1,.8})
    end
end
local StyleBar = function(self, unit, powertype)
    Lib.CreateBorder(self, 1, {0,0,0,0}, {1,1,1,.8})
end

local Create = function()
    for rname, rset in next, DKSet.Regions do
        MM:AddRegion(rname, rset)
    end
    
    local CDBar    = MM:Spawn("Cooldown", "DKRegion", "DKCDBar", DKSet.Cooldown, CDSpellList)
    local RuneBar   = MM:Spawn("RuneBar" , "DKRegion", "DKRune" , DKSet.Rune)
    local PowerBar = MM:Spawn("Power"   , "DKRegion", "DKPower", DKSet.Power)
    
    StylePoint(RuneBar, 'player', '', 6)
    PowerBar.PostChange = StyleBar
end
local Start = function()
    MM:EnableElements("DKRegion", "DKCDBar", "DKRune", "DKPower")
end
local Pause = function()
    MM:DisableElements("DKRegion", "DKCDBar", "DKRune", "DKPower")
end

MM:AddClassSet("DEATHKNIGHT", Create, Start, Pause)