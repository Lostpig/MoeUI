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
        size = 28, margin = 0, spacing = 4, column = 7,
        anchor = "TOP", relative = "TOP", x = 0, y = -15,
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
    [1] = {	--戒律
        {SpellID =  47540}, -- 苦修
        {SpellID = 120517}, -- 光晕
        {SpellID = 110744}, -- 神圣之星
        {SpellID =  10060},	-- 能量灌注
        {SpellID =  62618}, -- 真言术：障
		--{SpellID =  47536}, -- 全神贯注
		{SpellID =  33206}, -- 痛苦压制
		{SpellID = 207946}, -- 圣光之怒
		{SpellID = 123040}, -- 摧心魔
    },
    [2] = {	--神圣
        {SpellID =   2050}, -- 圣言术:静
		{SpellID =  34861}, -- 圣言术:灵
        {SpellID = 204883}, -- 环
        {SpellID =  33076}, -- 愈合
        {SpellID = 120517}, -- 光晕
        {SpellID = 110744}, -- 神圣之星
        {SpellID =  64843}, -- 赞美诗
		{SpellID =  47788}, -- 守护之魂
    },
    [3] = {	--暗影
        {SpellID =   8092},	-- 心爆
		{SpellID = 205351},	-- 暗言术：虚
        {SpellID = function () 
				local spec_add = Lib.IsSpellLearned(199853)
				return spec_add and 199911 or 32379
			end, Force = true
		},	-- 暗言术：灭
        {SpellID = 123040}, -- 摧心魔
        {SpellID =  34433}, -- 暗影魔
		{SpellID = 205448, Force = true}, -- 虚空箭
		{SpellID = 205065, Force = true}, -- 虚空洪流
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

    local CDBar     = MM:Spawn("Cooldown", "PriestRegion", "PriestCDBar",   PriestSet.Cooldown, CDSpellList)
end
local Start = function()
    MM:EnableElements("PriestRegion", "PriestCDBar")
end
local Pause = function()
    MM:DisableElements("PriestRegion", "PriestCDBar")
end

MM:AddClassSet("PRIEST", Create, Start, Pause)
