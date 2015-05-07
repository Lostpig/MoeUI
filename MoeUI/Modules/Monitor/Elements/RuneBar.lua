if select(2, UnitClass("player")) ~= "DEATHKNIGHT" then return end

local addon, namespace = ...
local Modules = namespace.Moe.Modules
local Media = namespace.Moe.Media
local MM = Modules:Get("Monitor")

local RuneColor = {
	{1, 0, 0},   -- blood
	{0, .5, 0},  -- unholy
	{0, 1, 1},   -- frost
	{.9, .1, 1}, -- death
}

local NewPoint = function(bar, index)
    local Set = bar.Set
    
	local point = CreateFrame('StatusBar', nil, bar)
	point:SetHeight(Set.height)
	point:SetStatusBarTexture(Set.texture or Media.Bar.Armory)	
	point:SetStatusBarColor(1, 1, 1)
	point:GetStatusBarTexture():SetHorizTile(false)
	return point
end

local UpdateType = function(self, event, rid, alt)
	local rune = self[rid]
	local colors = RuneColor[GetRuneType(rid) or alt]
	local r, g, b = colors[1], colors[2], colors[3]

	rune:SetStatusBarColor(r, g, b)
	if(self.PostUpdateType) then
		return self:PostUpdateType(rune, rid, alt)
	end
end

local OnUpdate = function(self, elapsed)
	local duration = self.duration + elapsed
	if(duration >= self.max) then
		return self:SetScript("OnUpdate", nil)
	else
		self.duration = duration
		return self:SetValue(duration)
	end
end
local UpdateRune = function(self, event, rid)
	local rune = self[rid]
	if(not rune) then return end

	local start, duration, runeReady = GetRuneCooldown(rid)
	if(runeReady) then
		rune:SetMinMaxValues(0, 1)
		rune:SetValue(1)
		rune:SetScript("OnUpdate", nil)
	else
		rune.duration = GetTime() - start
		rune.max = duration
		rune:SetMinMaxValues(1, duration)
		rune:SetScript("OnUpdate", OnUpdate)
	end

	if(self.PostUpdateRune) then
		return self:PostUpdateRune(rune, rid, start, duration, runeReady)
	end
end
local Update = function(self, event)
	for i=1, 6 do
		UpdateRune(self, event, i)
	end
end

local Event = function(self, event, ...)
    if event == "RUNE_TYPE_UPDATE" then
        UpdateType(self, event, ...)
    else
        return (self.Override or Update)(self, event, ...)
    end
end

local Enable = function(self)
    self:RegisterEvent('RUNE_POWER_UPDATE')
    self:RegisterEvent('RUNE_TYPE_UPDATE')
    
    for i=1, 6 do
        UpdateType(self, nil, i, math.floor((i+1)/2))
    end
    
    self:SetScript('OnEvent', Event)
end
local Disable = function(self)
    self:UnregisterEvent('RUNE_POWER_UPDATE')
    self:UnregisterEvent('RUNE_TYPE_UPDATE')
    
    self:Hide()
end

local Create = function(region, name, sets)
    local Bar = CreateFrame("Frame", name, region)
    Bar:SetPoint(sets.anchor, region, sets.relative, sets.x, sets.y)
    Bar:SetHeight(sets.height)
    Bar:SetWidth(sets.width)
    
    Bar.Set = sets
    local pointwidth = (sets.width - sets.spacing * 5) / 6
    for i = 1, 6 do 
        Bar[i] = NewPoint(Bar, i)
        if i == 1 then Bar[i]:SetPoint( "LEFT", Bar, "LEFT", 0, 0)
        else Bar[i]:SetPoint( "LEFT", Bar[i-1], "RIGHT", sets.spacing, 0) end
        Bar[i]:SetWidth(pointwidth)
    end
    
    Bar.enable = Enable
    Bar.disable = Disable
    region[name] = Bar
    return Bar
end
MM:AddElement("RuneBar", Create)
