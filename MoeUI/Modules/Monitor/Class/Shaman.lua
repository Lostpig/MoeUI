if select(2,UnitClass("player")) ~= "SHAMAN" then return end

local addon, namespace = ...
local Modules = namespace.Moe.Modules
local Lib = namespace.Moe.Lib
local Media = namespace.Moe.Media
local MM = Modules:Get("Monitor")

local MonitorSet = {
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
        size = 28, margin = 0, spacing = 4, column = 6,
        anchor = "TOP", relative = "TOP", x = 0, y = -15,
        frequentUpdates = false
    },
    Power = {
        unit = "player",
        width = 228, height = 8, 
        anchor = "TOP", relative = "TOP", x = 0, y = -2,
        frequentUpdates = false,
		text = {
			enable = true,
			fontsize = 14
		}
    }
}

local CDSpellList = {
    --[1] = {	--元素    },
    [2] = {	--增强
        {SpellID = 201897}, -- 石拳
        {SpellID = 193796}, -- 火舌
        {SpellID = 197214}, -- 裂地
        {SpellID =  17364}, -- 风暴打击
		{SpellID = 187874}, -- 毁灭闪电
		{SpellID = 204945, Force = true}, -- 毁灭闪电
    },
    [3] = {   --恢复    
		{SpellID =  61295}, -- 激流
		{SpellID =   5394}, -- 治疗之泉
		{SpellID = 207778}, -- 女王的恩赐
		{SpellID =  73920}, -- 治疗之雨
	},
}

local StyleBar = function(self, unit, powertype)
    Lib.CreateBorder(self, 1, {0,0,0,0}, {1,1,1,.8})
    
    local background = self:CreateTexture(nil, "BACKGROUND")
    background:SetTexture(Media.Bar.Armory)
    background:SetAllPoints(self)
    
    local color = PowerBarColor['FOCUS']
    background:SetVertexColor(color.r, color.g, color.b, .5)
    self.bg = background
end

local Create = function()
    for rname, rset in next, MonitorSet.Regions do
        MM:AddRegion(rname, rset)
    end
    
    local CDBar = MM:Spawn("Cooldown", "MonitorRegion", "MonitorCDBar", MonitorSet.Cooldown, CDSpellList)
    local PowerBar = MM:Spawn("Power"   , "MonitorRegion", "MonitorPower", MonitorSet.Power)
    
    StyleBar(PowerBar)
end
local Start = function()
    MM:EnableElements("MonitorRegion", "MonitorCDBar", "MonitorPower")
end
local Pause = function()
    MM:DisableElements("MonitorRegion", "MonitorCDBar", "MonitorPower")
end

MM:AddClassSet("SHAMAN", Create, Start, Pause)

