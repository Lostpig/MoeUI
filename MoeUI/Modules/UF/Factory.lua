local addon, namespace = ...
local Moe = namespace.Moe
local Lib = Moe.Lib
local MoeUF = Moe.Modules:Get("UnitFrame")
local Theme = Moe.Theme
local oUF = namespace.oUF

local Config = Moe.Config["UnitFrame"]
local F = MoeUF.F
local Specific = MoeUF.Specific
MoeUF.FrameList = {}

MoeUF.PrefixName = "MoeUF_"
local PrefixName = MoeUF.PrefixName
local function spawn(self, unit)
	local realunit = unit:match("[^%d]+")
    self:SetActiveStyle(PrefixName..realunit)
    local frame = self:Spawn(unit, PrefixName..unit)
    frame:SetScale(Config[realunit].scale or 1)
    frame:UpdateAllElements("PLAYER_ENTERING_WORLD", unit) --moe uf 在PLAYER_ENTERING_WORLD之后加载，所以需要刷新
    MoeUF.FrameList[unit] = frame
end
local function point(...)
	for _, unit in next, {...} do
		local realunit = unit:match("[^%d]+")
		local c = Config[realunit]
		if c.show and MoeUF.FrameList[unit] and not MoeUF.FrameList[unit].locked then
			local anchorto = UIParent
			if c.anchorTo and MoeUF.FrameList[c.anchorTo] then
				anchorto = MoeUF.FrameList[c.anchorTo]
			elseif c.anchorTo then
				anchorto = _G[c.anchorTo]
			end
			MoeUF.FrameList[unit]:SetPoint(c.anchor, anchorto, c.relative, c.x, c.y)			
		end
	end
end
local function Start()
	F.BaseInfo:Load()

	for unit, layout in next, Specific do
		oUF:RegisterStyle(PrefixName..unit, layout)
	end

	oUF:Factory(function(self)
		spawn(self, "player")
		spawn(self, "target")
		if Config.pet.show          then spawn(self, "pet") end
		if Config.targettarget.show then spawn(self, "targettarget") end
		if Config.focus.show        then spawn(self, "focus") end
		if Config.focustarget.show  then spawn(self, "focustarget") end
				
		if Config.boss.show then
			local anchor, relative, x, y = F.GetRelativePoint(Config.boss.relativepos)
			for i = 1, MAX_BOSS_FRAMES do
				spawn(self, "boss"..i)
				if i > 1 then
					MoeUF.FrameList["boss"..i]:SetPoint(anchor, MoeUF.FrameList["boss"..(i-1)], relative, x, y)
				end
			end
		end
		--考虑到相对定位的缘故，在所有Frame创建完毕后再进行定位
		point("player","target","pet","targettarget","focus","focustarget","boss1")
        local theme = Theme:Get("UnitFrame")
        if theme.Global.style and type(theme.Global.style) == "function" then theme.Global.style(MoeUF.FrameList) end
	end)
end

Moe.Modules:AddModule("UnitFrame", Start, nil)

SLASH_MOEUF1 = "/moeuf"
SlashCmdList["MOEUF"] = function(msg)
	if msg == "test" then F.Test() end
end
