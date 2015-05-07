local PlayerClass = select(2, UnitClass('player'))
if PlayerClass ~= "DRUID" and PlayerClass ~= "ROGUE" then return end

local parent, ns = ...
local oUF = ns.oUF

local SPELL_POWER_COMBO_POINTS = SPELL_POWER_COMBO_POINTS
local MAX_COMBO_POINTS = UnitPowerMax('player', SPELL_POWER_COMBO_POINTS)

local Update = function(self, event, unit, powerType)
	if(self.unit ~= unit or (powerType and powerType ~= 'COMBO_POINTS')) then return end

	local hp = self.CPoints
	if(hp.PreUpdate) then hp:PreUpdate(unit) end

	local num = UnitPower('player', SPELL_POWER_COMBO_POINTS)
	local maxnum = UnitPowerMax(unit, SPELL_POWER_COMBO_POINTS)
	for i = 1, maxnum do
		if(i <= num) then
			hp[i]:SetAlpha(1)
		else
			hp[i]:SetAlpha(0.2)
		end
	end
	if(hp.PostUpdate) then
		return hp:PostUpdate(unit)
	end
end

local Path = function(self, ...)
	return (self.CPoints.Override or Update) (self, ...)
end

local ForceUpdate = function(element)
	return Path(element.__owner, 'ForceUpdate', element.__owner.unit, 'COMBO_POINTS')
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
	if unit ~= 'player' or (powerType and powerType ~= 'COMBO_POINTS') then return end
	local maxnum = UnitPowerMax(unit, SPELL_POWER_COMBO_POINTS)
	local bar = self.CPoints
	
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


local function Enable(self)
	local hp = self.CPoints
	if(hp) then
		hp.__owner = self
		hp.ForceUpdate = ForceUpdate

		self:RegisterEvent('UNIT_COMBO_POINTS', Path)
		self:RegisterEvent('UNIT_MAXPOWER',maxchange)
		maxchange(self,'UNIT_MAXPOWER','player','COMBO_POINTS')

		return true
	end
end

local function Disable(self)
	local hp = self.CPoints
	if(hp) then
		self:UnregisterEvent('UNIT_COMBO_POINTS', Path)
	end
end

oUF:AddElement('CPoints', Path, Enable, Disable)

