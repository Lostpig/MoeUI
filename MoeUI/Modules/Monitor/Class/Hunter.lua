if select(2,UnitClass("player")) ~= "HUNTER" then return end

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
    }
}
local CDSpellList = {
    [2] = {	--射击
        {SpellID = 185901}, -- 标记
        {SpellID = 214579}, -- 响尾蛇
        {SpellID = 131894}, -- 黑鸦
        {SpellID = 120360}, -- 弹幕
    },
    [3] = {	--生存
        {SpellID = 185855}, -- 裂痕
        {SpellID = 190928},	-- 猫鼬
        {SpellID = 186270}, -- 猛禽
        {SpellID = 202800},	-- 侧翼
        {SpellID = 191433}, -- 爆炸陷阱
    }
}

local StylePoint = function(self, unit, powertype, maxnum)
    for i = 1 , maxnum do 
        Lib.CreateBorder(self[i], 1, {0,0,0,0}, {1,1,1,.8})
    end
end
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

    local CDBar    = MM:Spawn("Cooldown", "MonitorRegion", "MonitorCDBar", MonitorSet.Cooldown, CDSpellList)
    local PowerBar = MM:Spawn("Power"   , "MonitorRegion", "MonitorPower", MonitorSet.Power)
    
    StyleBar(PowerBar)
end
local Start = function()
    MM:EnableElements("MonitorRegion", "MonitorCDBar", "MonitorPower")
end
local Pause = function()
    MM:DisableElements("MonitorRegion", "MonitorCDBar", "MonitorPower")
end

MM:AddClassSet("HUNTER", Create, Start, Pause)
