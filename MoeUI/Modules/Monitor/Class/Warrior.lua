if select(2,UnitClass("player")) ~= "WARRIOR" then return end

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
        size = 28, margin = 0, spacing = 4, column = 8,
        anchor = "BOTTOM", relative = "BOTTOM", x = 0, y = 15,
        frequentUpdates = false
    },
    Power = {
        unit = "player",
        width = 228, height = 6, 
        anchor = "BOTTOM", relative = "BOTTOM", x = 0, y = 3,
        frequentUpdates = false,
    }
}
local CDSpellList = {
	[1] = {	--����    
		{SpellID =   12294}, -- �������
		{SpellID =  167105}, -- ���˴��
		{SpellID =    5308}, -- նɱ
	},
    [2] = {	--��ŭ	  
		{SpellID =   23881}, -- ��Ѫ
		{SpellID =   85288}, -- ŭ��
		{SpellID =    5308}, -- նɱ
	},
    [3] = {   	--����    
		{SpellID =   2565}, -- ���Ƹ�
        {SpellID =  23922}, -- �����ͻ�
        {SpellID =  34428}, -- ��ʤ׷��
		{SpellID =   6572}, -- ����
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
    for rname, rset in next, MonitorSet.Regions do
        MM:AddRegion(rname, rset)
    end
    
    local CDBar      = MM:Spawn("Cooldown"  , "MonitorRegion", "CDBar"  , MonitorSet.Cooldown, CDSpellList)
    local PowerBar   = MM:Spawn("Power"     , "MonitorRegion", "Power"  , MonitorSet.Power)
    
    PowerBar.PostChange = StyleBar
end
local Start = function()
    MM:EnableElements("MonitorRegion", "CDBar", "Power")
end
local Pause = function()
    MM:DisableElements("MonitorRegion", "CDBar", "Power")
end

MM:AddClassSet("WARRIOR", Create, Start, Pause)