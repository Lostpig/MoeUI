local addon, namespace = ...
local Modules = namespace.Moe.Modules
local Media = namespace.Moe.Media
local Lib = namespace.Moe.Lib
local MM = Modules:Get("Monitor")

local PowerBarColor = PowerBarColor

local Disable = function(self)
    self:UnregisterEvent('UNIT_POWER_FREQUENT')
    self:UnregisterEvent('UNIT_POWER')
    
    self:UnregisterEvent('UNIT_POWER_BAR_SHOW')
    self:UnregisterEvent('UNIT_POWER_BAR_HIDE')
    self:UnregisterEvent('UNIT_DISPLAYPOWER')
    self:UnregisterEvent('UNIT_MAXPOWER')
    
    self:Hide()
end
local Update = function(self, event, unit)
	if unit ~= self.Set.unit then return end
	if self.PreUpdate then self:PreUpdate(unit) end
	
	local cur, max = UnitPower(self.Set.unit), UnitPowerMax(self.Set.unit)
	self:SetMinMaxValues(0, max)
    self:SetValue(cur)
	
	if (self.Set.text and self.Set.text.enable) then
		self.text:SetText(cur)
	end
	
	if self.PostUpdate then return self:PostUpdate(cur, max, unit) end
end
local Change = function(self, event, unit)
    if unit ~= self.Set.unit then return end
    local powerType, powerToken, altR, altG, altB = UnitPowerType(unit)
    local info = self.Set.customcolor or PowerBarColor[powerToken]
    self:SetStatusBarColor(info.r, info.g, info.b)
    
    if self.PostChange then self:PostChange(unit, powerType) end
	(self.Override or Update)(self, event, unit)
end
local Event = function(self, event, ...)
    if event == "UNIT_POWER_FREQUENT" or event == "UNIT_POWER" then
        return (self.Override or Update)(self, event, ...)
    else
        return (self.Change or Change)(self, event, ...)
    end
end
local Enable = function(self)
    if self.Set.frequentUpdates and self.Set.unit == "player" then
        self:RegisterEvent('UNIT_POWER_FREQUENT')
    else
        self:RegisterEvent('UNIT_POWER')
    end
    
    self:RegisterEvent('UNIT_POWER_BAR_SHOW')
    self:RegisterEvent('UNIT_POWER_BAR_HIDE')
    self:RegisterEvent('UNIT_DISPLAYPOWER')
    self:RegisterEvent('UNIT_MAXPOWER')
    
    if(self:IsObjectType('StatusBar') and not self:GetStatusBarTexture()) then
        self:SetStatusBarTexture[[Interface\TargetingFrame\UI-StatusBar]]
    end
    self:SetScript("OnEvent", Event)
    Change(self, 'UNIT_DISPLAYPOWER', self.Set.unit)
    
    self:Show()
end

local Create = function(region, name, sets)
    local Bar = CreateFrame("StatusBar", name, region)
    Bar:SetPoint(sets.anchor, region, sets.relative, sets.x, sets.y)
    Bar:SetHeight(sets.height)
    Bar:SetWidth(sets.width)
    Bar:SetStatusBarTexture(sets.texture or Media.Bar.Armory)	
	Bar:GetStatusBarTexture():SetHorizTile(false)
	
	if (sets.text and sets.text.enable) then
		Bar.text = Lib.EasyFontString(Bar, Media.Fonts.Default, sets.text.fontsize, "THINOUTLINE")
		Bar.text:SetPoint('CENTER', 0, 0)
		Bar.text:SetText(nil)
	end
    
    Bar.Set = sets
    if not Bar.Set.unit then Bar.Set.unit = "player" end
    
    Bar.enable = Enable
    Bar.disable = Disable
    region[name] = Bar
    return Bar
end
MM:AddElement("Power", Create)