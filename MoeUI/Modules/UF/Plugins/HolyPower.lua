if(select(2, UnitClass('player')) ~= 'PALADIN') then return end

local parent, ns = ...
local oUF = ns.oUF

local SPELL_POWER_HOLY_POWER = SPELL_POWER_HOLY_POWER
local MAX_HOLY_POWER = UnitPowerMax('player', SPELL_POWER_HOLY_POWER)

local Update = function(self, event, unit, powerType)
	if(self.unit ~= unit or (powerType and powerType ~= 'HOLY_POWER')) then return end

	local hp = self.HolyPower
	if(hp.PreUpdate) then hp:PreUpdate(unit) end

	local num = UnitPower('player', SPELL_POWER_HOLY_POWER)
	local maxnum = UnitPowerMax(unit, SPELL_POWER_HOLY_POWER)
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
	return (self.HolyPower.Override or Update) (self, ...)
end

local ForceUpdate = function(element)
	return Path(element.__owner, 'ForceUpdate', element.__owner.unit, 'HOLY_POWER')
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
	if unit ~= 'player' or (powerType and powerType ~= 'HOLY_POWER') then return end
	local maxnum = UnitPowerMax(unit, SPELL_POWER_HOLY_POWER)
	local bar = self.HolyPower
	
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
	local hp = self.HolyPower
	if(hp) then
		hp.__owner = self
		hp.ForceUpdate = ForceUpdate

		self:RegisterEvent('UNIT_POWER', Path)
		self:RegisterEvent('UNIT_MAXPOWER',maxchange)
		maxchange(self,'UNIT_MAXPOWER','player','HOLY_POWER')

		return true
	end
end

local function Disable(self)
	local hp = self.HolyPower
	if(hp) then
		self:UnregisterEvent('UNIT_POWER', Path)
	end
end

oUF:AddElement('HolyPower', Path, Enable, Disable)
