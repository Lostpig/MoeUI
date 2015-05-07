--武僧真气,圣骑圣能,术士灵魂,牧师黑球 监视组件
local PClass = select(2, UnitClass('player'))
if      PClass ~= 'MONK'    and PClass ~= 'PALADIN' 
    and PClass ~= 'DRUID'   and PClass ~= 'ROGUE'
    and PClass ~= 'WARLOCK' and PClass ~= 'PRIEST' 
then return end

local addon, namespace = ...
local Modules = namespace.Moe.Modules
local Media = namespace.Moe.Media
local MM = Modules:Get("Monitor")

local PowerBarColor = PowerBarColor
local ClassPowerID, ClassPowerType, ClassPowerSpec
do
	if (PClass == 'MONK') then
		ClassPowerID = SPELL_POWER_CHI
		ClassPowerType = "CHI"
	elseif (PClass == 'PALADIN') then
		ClassPowerID = SPELL_POWER_HOLY_POWER
		ClassPowerType = "HOLY_POWER"
	elseif (PClass == 'PRIEST') then
		ClassPowerID = SPELL_POWER_SHADOW_ORBS
		ClassPowerType = "SHADOW_ORBS"
		ClassPowerSpec = SPEC_PRIEST_SHADOW
        PowerBarColor["SHADOW_ORBS"] = {r = .45, g = .6, b = .44}
	elseif (PClass == 'WARLOCK') then
		ClassPowerID = SPELL_POWER_SOUL_SHARDS
		ClassPowerType = "SOUL_SHARDS"
        ClassPowerSpec = SPEC_WARLOCK_AFFLICTION
    elseif (PClass == 'DRUID' or PClass == 'ROGUE') then
		ClassPowerID = SPELL_POWER_COMBO_POINTS
		ClassPowerType = "COMBO_POINTS"
        if (PClass == 'DRUID') then
            ClassPowerSpec = 3 --SPEC_DRUID_AFFLICTION
        end
	end 
end

local NewPoint = function(bar, index)
    local Set = bar.Set
    local r, g, b = PowerBarColor[ClassPowerType].r, PowerBarColor[ClassPowerType].g, PowerBarColor[ClassPowerType].b
    if Set.customcolor and Set.customcolor[index] then
        r, g, b = Set.customcolor[index].r, Set.customcolor[index].g, Set.customcolor[index].b
    elseif Set.customcolor and Set.customcolor.r then
        r, g, b = Set.customcolor.r, Set.customcolor.g, Set.customcolor.b
    end
    
	local point = CreateFrame("StatusBar", nil, bar)
	point:SetHeight(Set.height)
	point:SetStatusBarTexture(Set.texture or Media.Bar.Armory)	
	point:SetStatusBarColor(r, g, b)
	point:GetStatusBarTexture():SetHorizTile(false)
	return point
end
local isVisible = function()
    if ClassPowerSpec ~= nil then
        local currenspec = GetSpecialization()
        return currenspec == ClassPowerSpec
    end
    return true
end
local Visible = function(self)
    if isVisible() then
        self:enable()
    else
        self:disable()
    end
end

local Update = function(self, event, unit)
	if unit ~= 'player' then return end
	if self.PreUpdate then self:PreUpdate(unit, ClassPowerID) end
	
	local num = UnitPower(unit, ClassPowerID)
	for index = 1, UnitPowerMax(unit, ClassPowerID) do
		if(index <= num) then
			self[index]:SetAlpha(.9)
		else
			self[index]:SetAlpha(.2)
		end
	end
	
	if self.PostUpdate then return self:PostUpdate(unit, ClassPowerID) end
end
local Change = function(self, event, unit, powerType)
    if unit ~= 'player' or (powerType and powerType ~= ClassPowerType) then return end
    local maxnum = UnitPowerMax(unit, ClassPowerID)
	local pointwidth = (self.Set.width - self.Set.spacing * (maxnum - 1)) / maxnum
    
	for i = 1, maxnum do
		self[i]:SetWidth(pointwidth)
        self[i]:Show()
	end
	for j = maxnum + 1, 6 do
        if not self[j] then break end
		self[j]:Hide()
	end
	
    if self.PostChange then self:PostChange(unit, powerType, maxnum) end
	Update(self, event, 'player')
end
local Event = function(self, event, ...)
    if event == "PLAYER_TALENT_UPDATE" then
        Visible(self)
    elseif event == "UNIT_MAXPOWER" then
        return (self.Change or Change)(self, event, ...)
    else
        return (self.Override or Update)(self, event, ...)
    end
end

local Enable = function(self)
    self:RegisterEvent('PLAYER_TALENT_UPDATE')
    if isVisible() then
        self:RegisterEvent('UNIT_POWER')
        self:RegisterEvent('UNIT_DISPLAYPOWER')
        self:RegisterEvent('UNIT_MAXPOWER')
        Change(self, 'UNIT_MAXPOWER', 'player', ClassPowerType)
        self:Show()
    end
    self:SetScript("OnEvent", Event)
end
local Disable = function(self)
    self:UnregisterEvent('UNIT_POWER')
    self:UnregisterEvent('UNIT_DISPLAYPOWER')
    self:UnregisterEvent('UNIT_MAXPOWER')
    
    self:Hide()
end

local Create = function(region, name, sets)
    local Bar = CreateFrame("Frame", name, region)
    Bar:SetPoint(sets.anchor, region, sets.relative, sets.x, sets.y)
    Bar:SetHeight(sets.height)
    Bar:SetWidth(sets.width)
    
    Bar.Set = sets
    for i = 1, 6 do 
        Bar[i] = NewPoint(Bar, i)
        if i == 1 then Bar[i]:SetPoint( "LEFT", Bar, "LEFT", 0, 0)
        else Bar[i]:SetPoint( "LEFT", Bar[i-1], "RIGHT", sets.spacing, 0) end
    end
    
    Bar.enable = Enable
    Bar.disable = Disable
    region[name] = Bar
    return Bar
end

MM:AddElement("ClassIcons", Create)