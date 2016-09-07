if(select(2, UnitClass('player')) ~= 'MONK') then return end

local addon, ns = ...
local oUF = ns.oUF

local color = {0.004, 0.086, 0.711, 0.875}
local SPELL_POWER_CHI = SPELL_POWER_CHI

local function Update(self,event,unit)
	if unit ~= 'player' then return end
	local chi = self.ChiBar
	
	if chi.PreUpdate then chi:PreUpdate(unit) end
	
	local chinum = UnitPower(unit, SPELL_POWER_CHI)
	for index = 1, UnitPowerMax(unit, SPELL_POWER_CHI) do
		if(index <= chinum) then
			chi.points[index]:SetAlpha(1)
		else
			chi.points[index]:SetAlpha(.2)
		end
	end
	
	if(chi.PostUpdate) then
		return chi:PostUpdate(unit)
	end
end

local Path = function(self, ...)
	return (self.ChiBar.Override or Update) (self, ...)
end

--/dump Moe_UF_player.ChiBar[1]:GetStatusBarTexture():GetHorizTile()
local newpoint = function(bar)
	local point = CreateFrame("StatusBar", nil, bar)
    local texture = bar.points[1]:GetStatusBarTexture()
	point:SetHeight(bar.points[1]:GetHeight())
	point:SetStatusBarTexture(texture:GetTexture())	
	point:SetStatusBarColor(bar.points[1]:GetStatusBarColor())
	point:GetStatusBarTexture():SetHorizTile(texture:GetHorizTile())
	return point
end
local maxchange = function(self,event,unit,powerType)
	if unit ~= 'player' or (powerType and powerType ~= 'CHI') then return end
	local maxnum = UnitPowerMax(unit, SPELL_POWER_CHI)
	local bar = self.ChiBar
	
	for i = 1, maxnum do
		if not bar.points[i] then 
			bar.points[i] = newpoint(bar)
			bar.points[i]:SetPoint("LEFT",bar.points[i-1],"RIGHT",1,0)
		end
		bar.points[i]:SetWidth((bar:GetWidth() - (maxnum - 1))/maxnum)
	end
	
	for j = maxnum + 1, 10 do
        if not bar.points[i] then break end
		bar.points[i]:Hide()
	end
	
	Path(self,event,'player')
end

local function Enable(self,unit)
	local chi = self.ChiBar
	
	if (chi and unit == 'player') then
		self:RegisterEvent('UNIT_POWER', Path)
		self:RegisterEvent('UNIT_DISPLAYPOWER', Path)
		self:RegisterEvent('PLAYER_TALENT_UPDATE', maxchange)
		self:RegisterEvent('UNIT_MAXPOWER', maxchange)
		maxchange(self,'UNIT_MAXPOWER','player','CHI')
		--self:RegisterEvent('CHARACTER_POINTS_CHANGED',chimaxchance)
		--chimaxchance(self,'PLAYER_TALENT_UPDATE')
		chi.color = color
		return true
	end
end

local function Disable(self,unit)
	local chi = self.ChiBar
	
	if chi then
		self:UnregisterEvent('UNIT_POWER', Path)
		self:UnregisterEvent('UNIT_DISPLAYPOWER', Path)
	end
end

oUF:AddElement('ChiBar', Path, Enable, Disable)