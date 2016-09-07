if(select(2, UnitClass('player')) ~= 'WARLOCK') then return end

local parent, ns = ...
local oUF = ns.oUF

local SPELL_POWER_SOUL_SHARDS = SPELL_POWER_SOUL_SHARDS

local Update = function(self, event, unit, powerType)
	if(self.unit ~= unit or (powerType and powerType ~= 'SOUL_SHARDS')) then return end

	local ss = self.SoulShards
	if(ss.PreUpdate) then ss:PreUpdate(unit) end

	local num = UnitPower('player', SPELL_POWER_SOUL_SHARDS)
	for i = 1, UnitPowerMax(unit, SPELL_POWER_SOUL_SHARDS) do
		if(i <= num) then
			ss.points[i]:SetAlpha(1)
		else
			ss.points[i]:SetAlpha(.2)
		end
	end

	if(ss.PostUpdate) then
		return ss:PostUpdate(unit)
	end
end

local Path = function(self, ...)
	return (self.SoulShards.Override or Update) (self, ...)
end

local ForceUpdate = function(element)
	return Path(element.__owner, 'ForceUpdate', element.__owner.unit, 'SOUL_SHARDS')
end

local newpoint = function(bar)
	local point = CreateFrame("StatusBar", nil, bar)
    local texture = bar.points[1]:GetStatusBarTexture()
	point:SetHeight(bar.points[1]:GetHeight())
	point:SetStatusBarTexture(texture:GetTexture())	
	point:SetStatusBarColor(texture:GetStatusBarColor())
	point:GetStatusBarTexture():SetHorizTile(texture:GetHorizTile())
	return point
end
local maxchange = function(self,event,unit,powerType)
	if unit ~= 'player' or (powerType and powerType ~= 'SOUL_SHARDS') then return end
	local ssmax = UnitPowerMax('player', SPELL_POWER_SOUL_SHARDS)
	local maxnum = UnitPowerMax(unit, SPELL_POWER_SOUL_SHARDS)
	local bar = self.SoulShards
	
	for i = 1, maxnum do
		if not bar.points[i] then 
			bar.points[i] = newpoint(bar)
			bar.points[i]:SetPoint("LEFT",bar[i-1],"RIGHT",1,0)
		end
		bar.points[i]:SetWidth((bar:GetWidth() - (maxnum - 1))/maxnum)
	end
	
	for j = maxnum + 1, 10 do
		if bar.points[i] then bar.points[i]:Hide() end
	end
	
	Path(self,event,'player')
end

local isvisable = function(self,...)
	local ptt = GetSpecialization()
	local ss = self.SoulShards
	if(ptt and ptt == 1) then -- player has balance spec
		ss:Show()
	else
		ss:Hide()
	end
end

local function Enable(self)
	local ss = self.SoulShards
	if(ss) then
		ss.__owner = self
		ss.ForceUpdate = ForceUpdate

		self:RegisterEvent('UNIT_POWER', Path)
		--self:RegisterEvent('PLAYER_TALENT_UPDATE',isvisable)
		self:RegisterEvent('UNIT_MAXPOWER',maxchange)
		--isvisable(self,'PLAYER_TALENT_UPDATE')
		maxchange(self,'UNIT_MAXPOWER','player','SOUL_SHARDS')

		return true
	end
end

local function Disable(self)
	local ss = self.SoulShards
	if(ss) then
		self:UnregisterEvent('UNIT_POWER', Path)
	end
end

oUF:AddElement('SoulShards', Path, Enable, Disable)
