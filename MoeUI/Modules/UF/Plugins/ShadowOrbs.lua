if(select(2, UnitClass('player')) ~= 'PRIEST') then return end

local addon, ns = ...
local oUF = ns.oUF

local SPELL_POWER_SHADOW_ORBS = SPELL_POWER_SHADOW_ORBS
local PRIEST_BAR_NUM_LARGE_ORBS = PRIEST_BAR_NUM_LARGE_ORBS
local PRIEST_BAR_NUM_SMALL_ORBS = PRIEST_BAR_NUM_SMALL_ORBS
local SPEC_PRIEST_SHADOW = SPEC_PRIEST_SHADOW
local SHADOW_ORB_MINOR_TALENT_ID = SHADOW_ORB_MINOR_TALENT_ID

local color = {0.457, 0.605, 0.445, 0.734}

local function Update(self,event,unit,powerType)
	if unit ~= 'player' or (powerType and powerType ~= 'SHADOW_ORBS') then return end
	local sbs = self.ShadowOrbs
	
	if sbs.PreUpdate then sbs:PreUpdate(unit) end
	
	local sbsnum = UnitPower(unit, SPELL_POWER_SHADOW_ORBS)
	local sbsmax = UnitPowerMax(unit, SPELL_POWER_SHADOW_ORBS)
	--local PRIEST_BAR_NUM_ORBS = 5--IsSpellKnown(SHADOW_ORB_MINOR_TALENT_ID) and PRIEST_BAR_NUM_SMALL_ORBS or PRIEST_BAR_NUM_LARGE_ORBS
	for index = 1, sbsmax do
		if(index <= sbsnum) then
			sbs[index]:SetAlpha(1)
		else
			sbs[index]:SetAlpha(.2)
		end
	end
	
	if(sbs.PostUpdate) then
		return sbs:PostUpdate(unit)
	end
end

local Path = function(self, ...)
	return (self.ShadowOrbs.Override or Update) (self, ...)
end

local isvisable = function(self,...)
	local ptt = GetSpecialization()
	local sbs = self.ShadowOrbs
	if(ptt and ptt == 3) then -- player has balance spec
		sbs:Show()
	else
		sbs:Hide()
	end
end

local newpoint = function(bar)
	local point = CreateFrame("StatusBar", nil, bar)
    local texture = bar[1]:GetStatusBarTexture()
	point:SetHeight(bar[1]:GetHeight())
	point:SetStatusBarTexture(texture:GetTexture())	
	point:SetStatusBarColor(texture:GetStatusBarColor())
	point:GetStatusBarTexture():SetHorizTile(texture:GetHorizTile())
	return point
end
local maxchange = function(self,event,unit,powerType)
	if unit ~= 'player' or (powerType and powerType ~= 'SHADOW_ORBS') then return end
	local maxnum = UnitPowerMax(unit, SPELL_POWER_SHADOW_ORBS)
	local bar = self.ShadowOrbs
	
	for i = 1, maxnum do
		if not bar[i] then 
			bar[i] = newpoint(bar)
			bar[i]:SetPoint("LEFT",bar[i-1],"RIGHT",1,0)
		end
		bar[i]:SetWidth((bar:GetWidth() - (maxnum - 1))/maxnum)
	end
	
	for j = maxnum + 1, 10 do
		if bar[i] then bar[i]:Hide() end
	end
	
	Path(self,event,'player')
end

local function Enable(self,unit)
	local sbs = self.ShadowOrbs
	
	if (sbs and unit == 'player') then
		self:RegisterEvent('UNIT_POWER', Path)
		self:RegisterEvent('UNIT_DISPLAYPOWER', Path)
		self:RegisterEvent('PLAYER_TALENT_UPDATE',isvisable)
		self:RegisterEvent('UNIT_MAXPOWER',maxchange)
		isvisable(self,'PLAYER_TALENT_UPDATE')
		maxchange(self,'UNIT_MAXPOWER','player','SHADOW_ORBS')
		sbs.color = color
		return true
	end
end

local function Disable(self,unit)
	local sbs = self.ShadowOrbs
	
	if sbs then
		self:UnregisterEvent('UNIT_POWER', Path)
		self:UnregisterEvent('UNIT_DISPLAYPOWER', Path)
	end
end

oUF:AddElement('ShadowOrbs', Path, Enable, Disable)