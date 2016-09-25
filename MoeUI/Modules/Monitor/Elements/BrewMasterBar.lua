local addon, namespace = ...
local Modules = namespace.Moe.Modules
local Media = namespace.Moe.Media
local Lib = namespace.Moe.Lib
local MM = Modules:Get("Monitor")
local Media = namespace.Moe.Media

local colors = {
	[1] = { r = 0.05, g = 1, b = 0.2 },
	[2] = { r = 1, g = 1, b = 0.2 },
	[3] = { r = 1, g = 0.2, b = 0.2 }
}

local Visible = function(self)
    if GetSpecialization() == 1 then
        self:Show()
    else
        self:Hide()
    end
end
local MaxChange = function (self)
	local maxVal = math.ceil(UnitHealthMax('player') * 0.66)
	self:SetMinMaxValues(0, maxVal)
	self.maxVal = maxVal
end
local GetDemage = function () 
	local index = 1
	local val, level = 0, 1
	while true do
		local name, _, _, _, _, _, _, _, _, _, spellID, _, _, _, _, _, _, damage = UnitDebuff('player', index)
		if not name then break end
		if spellID == 124275 or spellID == 124274 or spellID == 124273 then  	--轻中重
			val = damage
			level = spellID == 124275 and 1 or ( spellID == 124274 and 2 or 3 )
			break
		end
		index = index + 1
	end
	
	--print(val)
	return val, level
end

local Disable = function(self)    
	self:UnregisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	self:UnregisterEvent("UNIT_MAXHEALTH")
end
local Event = function(self, event, unit)
	if (unit ~= 'player') then return end
	if (event == 'PLAYER_SPECIALIZATION_CHANGED') then
		Visible(self)
	else 
		MaxChange(self)
	end
end
local Update = function (self, elapsed) 
	self.Timer = self.Timer + elapsed
	if self.Timer > 0.5 then
		local val, level = GetDemage()
		if (val > self.maxVal) then val = self.maxVal end
		self:SetValue(val)
		self.text:SetText(val == 0 and '' or val)
		
		local color = colors[level]
		self:SetStatusBarColor(color.r, color.g, color.b)
		
		self.Timer = 0
	end	
end
local Enable = function(self)
	self:RegisterEvent('PLAYER_SPECIALIZATION_CHANGED')
	self:RegisterEvent('UNIT_MAXHEALTH')
	self:SetScript("OnEvent", Event)
	self:SetScript("OnUpdate", Update)
	
    if(self:IsObjectType('StatusBar') and not self:GetStatusBarTexture()) then
        self:SetStatusBarTexture[[Interface\TargetingFrame\UI-StatusBar]]
    end
	
	Event(self, 'PLAYER_SPECIALIZATION_CHANGED', 'player')
	Event(self, 'UNIT_MAXHEALTH', 'player')
end

local Create = function(region, name, sets)
    local Bar = CreateFrame("StatusBar", name, region)
    Bar:SetPoint(sets.anchor, region, sets.relative, sets.x, sets.y)
    Bar:SetHeight(sets.height)
    Bar:SetWidth(sets.width)
    Bar:SetStatusBarTexture(sets.texture or Media.Bar.Armory)	
	Bar:GetStatusBarTexture():SetHorizTile(false)
    Bar.text = Lib.EasyFontString(Bar, Media.Fonts.Default, sets.fontsize, "THINOUTLINE")
	Bar.text:SetPoint('CENTER', 0, 0)
	Bar.text:SetText(nil)
	
	Bar.Timer = 0
    Bar.Set = sets
    if not Bar.Set.unit then Bar.Set.unit = "player" end
    
    Bar.enable = Enable
    Bar.disable = Disable
    region[name] = Bar
    return Bar
end
MM:AddElement("BrewMasterBar", Create)