local addon, namespace = ...
local BMB = namespace.BMB
local Func = BMB.Func

local FormatNumberText = function (val, style)
    if style == 'full' then
        local valm, valk, vals = floor(val/1e6), floor(mod(val/1e3, 1e3)), floor(mod(val, 1e3))
        if val >= 1e6 then return ("|cffff3333%d|r'|cffffff33%03d|r'|cff33ff33%03d|r"):format(valm,valk,vals)
        elseif val >= 1e3 then return ("|cffffff33%d|r'|cff33ff33%03d|r"):format(valk,vals)
        else return ("|cff33ff33%d|r"):format(vals) end
    elseif style == 'cn' then
        local valy, valw, vals = val/1e8, mod(val/1e4, 1e4), mod(val, 1e4)
        if val >= 1e8 then return ("|cffffff33%.2f|r亿"):format(valy)
        elseif val >= 1e4 then return ("|cffffff33%.1f|r万"):format(valw)
        else return ("|cffffff33%d|r"):format(vals) end
    elseif style == 'en' then
        local valm, valk, vals = val/1e6, mod(val/1e3, 1e3), mod(val, 1e3)
        if val >= 1e6 then return ("|cffffff33%.2f|rm"):format(valm)
        elseif val >= 1e3 then return ("|cffffff33%.1f|rk"):format(valk)
        else return ("|cffffff33%d|r"):format(vals) end
    end
end
local GetDemage = function () 
	local index = 1
	local val, pval, level = 0, 0, 1
	while true do
		local name, _, _, _, _, _, _, _, _, _, spellID, _, _, _, _, _, pdamage, damage = UnitDebuff('player', index)
		if not name then break end
		if spellID == 124275 or spellID == 124274 or spellID == 124273 then  	--轻中重
			val = damage
            pval = pdamage
			level = spellID == 124275 and 1 or ( spellID == 124274 and 2 or 3 )
			break
		end
		index = index + 1
	end

	return val, pval, level
end

local colors = {
	[1] = { r = 0.05, g = 1, b = 0.2 },
	[2] = { r = 1, g = 1, b = 0.2 },
	[3] = { r = 1, g = 0.2, b = 0.2 }
}
local points = {
    ['CENTER']=      { a = 'CENTER',      r = 'CENTER',      j = 'CENTER', x = 0, y = 0 },
    ['TOP']=         { a = 'BOTTOM',      r = 'TOP',         j = 'CENTER', x = 0, y = 4 },
    ['BOTTOM']=      { a = 'TOP',         r = 'BOTTOM',      j = 'CENTER', x = 0, y = -4 },
    
    ['LEFTIN']=      { a = 'LEFT',        r = 'LEFT',        j = 'LEFT',   x = 2, y = 0 },
    ['LEFTOUT']=     { a = 'RIGHT',       r = 'LEFT',        j = 'RIGHT',  x = -2, y = 0 },
    ['TOPLEFT']=     { a = 'BOTTOMLEFT',  r = 'TOPLEFT',     j = 'LEFT',   x = 2, y = 4 },
    ['BOTTOMLEFT']=  { a = 'TOPLEFT',     r = 'BOTTOMLEFT',  j = 'LEFT',   x = 2, y = -4 },
    
    ['RIGHTIN']=     { a = 'RIGHT',       r = 'RIGHT',       j = 'RIGHT',  x = -2, y = 0 },
    ['RIGHTOUT']=    { a = 'LEFT',        r = 'RIGHT',       j = 'LEFT',   x = 2, y = 0 },
    ['TOPRIGHT']=    { a = 'BOTTOMRIGHT', r = 'TOPRIGHT',    j = 'RIGHT',  x = -2, y = 4 },
    ['BOTTOMRIGHT']= { a = 'TOPRIGHT',    r = 'BOTTOMRIGHT', j = 'RIGHT',  x = -2, y = -4 },
}
local texts = {
    'dmg', 'dmgperc', 'dpl', 'winetime', 'winecount'
}
local textsUpdater = {
    ['dmg'] = function ()
        local val = GetDemage()
        return FormatNumberText(val, BMBDB['dmg'].numformat)
    end,
    ['dmgperc'] = function ()
        local val = GetDemage()
        local maxVal = UnitHealthMax('player')
        local perc = val / maxVal * 100;
        
        if (perc > 0.1) then
            return ('%.1f%%'):format(perc)
        else
            return '0%'
        end
    end,
    ['dpl'] = function ()
        local _, val = GetDemage()
        return FormatNumberText(val, BMBDB['dpl'].numformat)
    end,
    ['winetime'] = function ()
        local index = 1
        local time = 0
        while true do
            local name, _, icon, count, _, duration, expires, caster, _, _, spellID = UnitBuff('player', index)
            if not name then break end
            if spellID == 215479 then
                time = math.floor(expires - GetTime())
                break
            end
            index = index + 1
        end
        
        if time > 10 then return ("|cff33ff33%d|r"):format(time)
        elseif time > 5 then return ("|cffffff33%d|r"):format(time)
        elseif time > 0 then return ("|cffff3333%d|r"):format(time)
        else return '' end
    end,
    ['winecount'] = function ()
        return GetSpellCharges(119582)
    end
}

local Main = {}

local Visible = function(self)
    if GetSpecialization() == 1 then
        self:Show()
        self.isVisible = true
    else
        self:Hide()
        self.isVisible = false
    end
end
local MaxChange = function (self)
	local maxVal = UnitHealthMax('player')
	self:SetMinMaxValues(0, maxVal)
	self.maxVal = maxVal
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

local UpdateText = function(self)
    for index, text in pairs(texts) do
        if not BMBDB[text].show then break end
        self[text..'Text']:SetText(textsUpdater[text]())
    end
end
local Update = function (self, elapsed) 
	self.Timer = self.Timer + elapsed
	if self.Timer > BMBDB.timer then
		local val, pval, level = GetDemage()
		if (val > self.maxVal) then val = self.maxVal end
		self:SetValue(val)
		
		local color = colors[level]
		self:SetStatusBarColor(color.r, color.g, color.b)
        
        UpdateText(self)
		
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

local Fade = function(self, event)
    if not Main.Bar.isVisible then return end
    if event == "PLAYER_REGEN_DISABLED" then
        UIFrameFadeOut(Main.Bar, 1, self.lcalpha, 1)
    elseif event == "PLAYER_REGEN_ENABLED" then
        UIFrameFadeOut(Main.Bar, 1, 1, self.lcalpha)
    end
end
local SetCombat = function(self)
    self:RegisterEvent("PLAYER_REGEN_ENABLED")
    self:RegisterEvent("PLAYER_REGEN_DISABLED")
    self:SetScript("OnEvent", Fade)
end

Main.ApplySetting = function (self)
    local Region = self.Region
    local Bar = self.Bar
    
    Region.lcalpha = BMBDB.uncombat == 'show' and 1 or (BMBDB.uncombat == 'fade' and .3 or 0)
    if UnitAffectingCombat("player") then Bar:SetAlpha(1)
    else Bar:SetAlpha(Region.lcalpha) end
    
    Region:SetHeight(BMBDB.height + 20)
    Region:SetWidth(BMBDB.width + 20)
    
    Bar:SetHeight(BMBDB.height)
    Bar:SetWidth(BMBDB.width)
    Bar:SetStatusBarTexture(BMBDB.texture)
	Bar:GetStatusBarTexture():SetHorizTile(false)
    
    Bar.bg:SetTexture(BMBDB.texture, true)
    
    local textObj, textOpt
    for index, text in pairs(texts) do
        textObj, textOpt = Bar[text..'Text'], BMBDB[text]
        if not textOpt.show then 
            textObj:Hide() 
        else
            textObj:ClearAllPoints()
            textObj:SetPoint(textOpt.align, Bar, textOpt.point, textOpt.x, textOpt.y)
            --textObj:SetJustifyH(textOpt.align)
            textObj:SetFont(textOpt.font, textOpt.fontsize, textOpt.fontflags)
            textObj:Show() 
        end
    end
end
Main.Locked = function (self)
    local Region = self.Region

    if not BMBDB.locked then
        Func.CreateShadow(Region, 1, {.9,.1,.1, .3}, {.9,.1,.1, 0})
        Region:EnableMouse(true)
        Region:SetMovable(true)
        Region:SetScript("OnMouseDown", Region.StartMoving)
        Region:SetScript("OnMouseUp", Region.StopMovingOrSizing)
    else
        Func.RemoveBorder(Region)
        Region:EnableMouse(false)
        Region:SetMovable(false)
        Region:SetScript("OnMouseDown", nil)
        Region:SetScript("OnMouseUp", nil)
        
        local a, _, r, x, y = Region:GetPoint()
        BMBDB.anchor = a
        BMBDB.relative = r
        BMBDB.x = x
        BMBDB.y = y
    end
end
Main.Create = function (self)
    local Region = CreateFrame("Frame", 'BMBRegion', UIParent)
    Region:SetPoint(BMBDB.anchor, UIParent, BMBDB.relative, BMBDB.x, BMBDB.y)

    local Bar = CreateFrame("StatusBar", 'BMBBar', Region)
    Bar:SetPoint('CENTER', Region, 'CENTER', 0, 0)
    Func.CreateBorder(Bar, 1, {0,0,0,0}, {.8,.8,.8,.3})
    
    Bar.bg = Bar:CreateTexture(nil, "BACKGROUND")
    Bar.bg:SetVertexColor(.3,.3,.3,.3)
	Bar.bg:SetAllPoints()
	
    local textObj, textOpt
    for index, text in pairs(texts) do
        textOpt = BMBDB[text]
        textObj = Func.EasyFontString(Bar, textOpt.font, textOpt.fontsize, textOpt.fontflags)
        textObj:SetText(nil)
        Bar[text..'Text'] = textObj
    end

	Bar.Timer = 0
    Bar.isVisible = false
    Bar.enable = Enable
    Bar.disable = Disable
    
    self.Region = Region
    self.Bar = Bar
    self:ApplySetting()
    self:Locked()
    SetCombat(Region)
end

BMB.Main = Main