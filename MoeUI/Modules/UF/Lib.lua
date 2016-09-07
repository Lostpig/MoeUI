local addon, namespace = ...
local Moe = namespace.Moe
local Lib = Moe.Lib
local Media = Moe.Media
local MoeUF = Moe.Modules:Get("UnitFrame")
local oUF = namespace.oUF

local F = {}
MoeUF.F = F

local Cast = MoeUF.Cast

local function GetSetsTo(frame, to)
    local ancharto = frame
    if to and type(to) == "string" then
        if to == "UIParent" then ancharto = UIParent
        elseif to:match("(%w+)%.(%w+)") then
            local f,b = to:match("(%w+)%.(%w+)")
            if MoeUF.FrameList[f] and MoeUF.FrameList[f][b] then ancharto = MoeUF.FrameList[f][b] end
        elseif MoeUF.FrameList[to] then ancharto = MoeUF.FrameList[to]
        elseif frame[to] then ancharto = frame[to]
        elseif _G[to] then ancharto = _G[to]
        end
    end
    return ancharto
end
local function HighlightOnEnter(frame)
	UnitFrame_OnEnter(frame)
	frame.Highlight:Show()
end
local function HighlightOnLeave(frame)
	UnitFrame_OnLeave(frame)
	frame.Highlight:Hide()
end
--auras
local function formatTime(s)
	local day, hour, minute = 86400, 3600, 60
	if s >= day then
		return format("%dd", floor(s/day + 0.5)), s % day
	elseif s >= hour then
		return format("%dh", floor(s/hour + 0.5)), s % hour
	elseif s >= minute then
		return format("%dm", floor(s/minute + 0.5)), s % minute
	elseif s >= minute / 12 then
		return floor(s + 0.5), (s * 100 - floor(s * 100))/100
	end
	return format("%.1f", s), (s * 100 - floor(s * 100))/100
end
local function setTimer(self, elapsed)
	if self.timeLeft then
		self.elapsed = (self.elapsed or 0) + elapsed
		if self.elapsed >= 0.1 then
			if not self.first then
				self.timeLeft = self.timeLeft - self.elapsed
			else
				self.timeLeft = self.timeLeft - GetTime()
				self.first = false
			end
			if self.timeLeft > 0 then
				local time = formatTime(self.timeLeft)
					self.time:SetText(time)
				if self.timeLeft < 5 then
					self.time:SetTextColor(1, 0.5, 0.5)
				else
					self.time:SetTextColor(.7, .7, .7)
				end
			else
				self.time:Hide()
				self:SetScript("OnUpdate", nil)
			end
			self.elapsed = 0
		end
	end
end
local function updateTooltip(self)
	GameTooltip:SetUnitAura(self:GetParent():GetParent().unit, self:GetID(), self.filter)

	if self.owner and UnitExists(self.owner) then
		GameTooltip:AddLine(format("|cff1369ca* Cast by %s|r", UnitName(self.owner) or UNKNOWN))
	end

	GameTooltip:Show()
end
local function postCreateIcon(element, button)
	element.disableCooldown = true
	button.cd.noOCC = true
	button.cd.noCooldownCount = true
	Lib.CreateBorder(button, 1, {1,1,1,0}, {1,1,1,.9}, 2)
		
	button.time = Lib.EasyFontString(button, Media.Fonts.Default, 12, "THINOUTLINE")
	button.time:SetPoint("CENTER", button, "CENTER", 1, 0)
	button.time:SetJustifyH("CENTER")
	button.time:SetVertexColor(1,1,1)
	
	button.count = Lib.EasyFontString(button, Media.Fonts.Default, 12, "THINOUTLINE")
	button.count:SetPoint("CENTER", button, "BOTTOMRIGHT", 0, 3)
	button.count:SetJustifyH("RIGHT")

	button.UpdateTooltip = updateTooltip
	
	button.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	button.icon:SetDrawLayer("ARTWORK")
end
local function postUpdateIcon(element, unit, button, index)
	local _, _, _, _, _, duration, expirationTime, unitCaster, _ = UnitAura(unit, index, button.filter)
	
	if duration and duration > 0 then
		button.time:Show()
		button.timeLeft = expirationTime	
		button:SetScript("OnUpdate", setTimer)			
	else
		button.time:Hide()
		button.timeLeft = math.huge
		button:SetScript("OnUpdate", nil)
	end
	
	-- Desaturate non-Player Debuffs
	if(button.debuff) then
		if(unit == "target") then	
			if (unitCaster == "player" or unitCaster == "vehicle") then
				button.icon:SetDesaturated(false)                 
			elseif(not UnitPlayerControlled(unit)) then -- If Unit is Player Controlled don"t desaturate debuffs
				button:SetBackdropColor(0, 0, 0)
				button.overlay:SetVertexColor(0.3, 0.3, 0.3)      
				button.icon:SetDesaturated(true)  
			end
		end
	end
	button:SetScript('OnMouseUp', function(self, mouseButton)
		if mouseButton == 'RightButton' then
			CancelUnitBuff('player', index)
	end end)
	button.first = true
end
--class resources bar
local function BaseStyle(bar)
	Lib.CreateBorder(bar, 1, {1,1,1,0}, {.96,.96,.96,.9}, 2)
end
local function CPointsUpdate(self, event, unit)
	if(unit == "pet") then return end
	
	local cpoints = self.CPoints
	local cp
	if (UnitHasVehicleUI("player") or UnitHasVehicleUI("vehicle")) then
		cp = GetComboPoints('vehicle', 'target')
	else
		cp = GetComboPoints('player', 'target')
	end
	
	for i=1, MAX_COMBO_POINTS do
		if(i <= cp) then
			cpoints[i]:SetAlpha(1)
		else
			cpoints[i]:SetAlpha(0.15)
		end
	end
end
--altpower bar
function AltPowerBarPostUpdate(self, min, cur, max)
	local perc = math.floor((cur/max)*100)
		
	if perc < 35 then
		self:SetStatusBarColor(0, 1, 0)
	elseif perc < 70 then
		self:SetStatusBarColor(1, 1, 0)
	else
		self:SetStatusBarColor(1, 0, 0)
	end
		
	local unit = self:GetParent().unit or self:GetParent():GetParent().unit
	
	local type = select(10, UnitAlternatePowerInfo(unit))
end

F.BaseInfo = {
	Load = function(self)
		self.PlayerClassName, self.PlayerClass = UnitClass("player")
	end
}

F.GetRelativePoint = function(relativepos)
	if relativepos.direction == "UP" then 
		return "BOTTOM", "TOP", 0, relativepos.spacing
	elseif relativepos.direction == "DOWN" then 
		return "TOP", "BOTTOM", 0, -1 * relativepos.spacing
	elseif relativepos.direction == "LEFT" then 
		return "RIGHT", "LEFT", -1 * relativepos.spacing, 0
	else	--RIGHT
		return "LEFT", "RIGHT", relativepos.spacing, 0
	end
end
F.CreateHighlight = function(frame, basesets)
    frame:SetScript("OnEnter", HighlightOnEnter)
    frame:SetScript("OnLeave", HighlightOnLeave)
	
    local highlight = frame.Health:CreateTexture(nil, "OVERLAY")
    highlight:SetAllPoints(frame.Health)
    highlight:SetTexture(basesets.Texture)
    highlight:SetVertexColor(unpack(basesets.Color))
	
	if basesets.flipv or basesets.fliph then
		local flpmode
		if basesets.fliph and basesets.flipv then flpmode = "DIAGONAL"
		elseif basesets.flipv then flpmode = "VERTICAL"
		elseif basesets.fliph then flpmode = "HORIZONTAL" end
		
		Lib.Flip(highlight, flpmode)
	end
	
    highlight:SetBlendMode("ADD")
    highlight:Hide()
    frame.Highlight = highlight
end
F.InitFrame = function(frame)
	frame:RegisterForClicks("AnyDown")
	frame:SetScript("OnEnter", UnitFrame_OnEnter)
	frame:SetScript("OnLeave", UnitFrame_OnLeave)
    frame:SetFrameLevel(5)
end
F.CreateMainBar = function(frame, unit, barType, sets)
	local bar = CreateFrame("StatusBar", nil, frame)
	bar:SetStatusBarTexture(sets.texture)
	bar:GetStatusBarTexture():SetHorizTile(true)
    bar:SetFrameLevel(2)
	--bar:GetStatusBarTexture():SetVertTile(false)
	
	if sets.reverse then bar:SetReverseFill(true) end
	
	bar:SetHeight(sets.height)
	bar:SetWidth(sets.width)
	bar:SetStatusBarColor(sets.color.r, sets.color.g, sets.color.b, sets.color.a)
    
    local anchorto = frame
	if sets.to and frame[sets.to] then anchorto = frame[sets.to] end
    bar:SetPoint(sets.anchor, anchorto, sets.relative, sets.x, sets.y)
	
	if sets.background then
		local background = bar:CreateTexture(nil, "BACKGROUND")
		background:SetTexture(sets.background.texture)
		background:SetAllPoints(bar)
		background:SetVertexColor(sets.background.color.r,sets.background.color.g,sets.background.color.b,sets.background.color.a)
		bar.bg = background
	end
	
	if sets.flipv or sets.fliph then
		local flpmode
		if sets.fliph and sets.flipv then flpmode = "DIAGONAL"
		elseif sets.flipv then flpmode = "VERTICAL"
		elseif sets.fliph then flpmode = "HORIZONTAL" end
		
		Lib.Flip(bar:GetStatusBarTexture(), flpmode)
		if sets.background then Lib.Flip(bar.bg, flpmode) end
	end
	
	bar.frequentUpdates = sets.frequentUpdates
	bar.Smooth = sets.Smooth
	
	frame[barType] = bar
end
F.CreateMinorBar = function(frame, sets)
end
F.CreateCastingBar = function(frame, unit, sets, basesets)
	local castbar = CreateFrame("StatusBar", nil, frame)
    castbar:SetHeight(sets.height)
    castbar:SetWidth(sets.width)

    castbar:SetStatusBarTexture(basesets.Texture)
    castbar:GetStatusBarTexture():SetDrawLayer("BORDER")
    castbar:GetStatusBarTexture():SetHorizTile(true)
    --castbar:GetStatusBarTexture():SetVertTile(false)
    if sets.reverse then castbar:SetReverseFill(true) end
    
	local anchorto = frame
	if sets.to and sets.to == "UIParent" then anchorto = UIParent
	elseif sets.to and frame[sets.to] then anchorto = frame[sets.to] end
	castbar:SetPoint(sets.anchor, anchorto, sets.relative, sets.x, sets.y)
	    
	castbar:SetStatusBarColor(unpack(basesets.Color))
    castbar.CastingColor = basesets.CastingColor
    castbar.CompleteColor = basesets.CompleteColor--{20/255, 208/255, 0/255}
    castbar.FailColor = basesets.FailColor--{255/255, 12/255, 0/255}
    castbar.ChannelingColor = basesets.ChannelingColor
	
	local spark = castbar:CreateTexture(nil, "OVERLAY")
    spark:SetDrawLayer("OVERLAY", 7)
    spark:SetTexture(basesets.SparkTexture or [[Interface\CastingBar\UI-CastingBar-Spark]])
    spark:SetBlendMode("ADD")
    spark:SetAlpha(1)
	spark:SetHeight(sets.height)
	spark:SetWidth(2)
	spark:SetPoint("TOPLEFT", castbar:GetStatusBarTexture(), "TOPRIGHT", -1, 1)
    spark:SetPoint("BOTTOMRIGHT", castbar:GetStatusBarTexture(), "BOTTOMRIGHT", 1, -1)
    castbar.Spark = spark
	
	if sets.border then Lib.CreateBorder(castbar, 1, {0,0,0,0}, {.9,.9,.9,.9}) end
	castbar.bg = castbar:CreateTexture(nil, "BACKGROUND")
    castbar.bg:SetTexture(basesets.BGTexture)
    castbar.bg:SetAllPoints(true)
    castbar.bg:SetVertexColor(.12, .12, .12)
	
	castbar.Text = Lib.EasyFontString(castbar, sets.text.font, sets.text.size, sets.text.flag)
    castbar.Text:SetPoint(sets.text.anchor, castbar, sets.text.relative, sets.text.x, sets.text.y)
	castbar.Text:SetJustifyH(sets.text.align or "LEFT")

	castbar.Time = Lib.EasyFontString(castbar, sets.time.font, sets.time.size, sets.time.flag)
    castbar.Time:SetPoint(sets.time.anchor, castbar, sets.time.relative, sets.time.x, sets.time.y)
    castbar.Time:SetJustifyH(sets.time.align or "RIGHT")

	if sets.icon.show then
		castbar.Iconbg = CreateFrame("Frame", nil ,castbar)
		castbar.Iconbg:SetPoint(sets.icon.anchor, castbar, sets.icon.relative, sets.icon.x, sets.icon.y)
		castbar.Iconbg:SetSize(sets.icon.size, sets.icon.size)
		castbar.Icon = castbar:CreateTexture(nil, "ARTWORK")
		castbar.Icon:SetAllPoints(castbar.Iconbg)
		castbar.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	end
	
	if (unit == "player") then
		castbar.SafeZone = castbar:CreateTexture(nil,"OVERLAY")
        castbar.SafeZone:SetTexture(basesets.Texture)
        castbar.SafeZone:SetVertexColor(unpack(basesets.SafeZoneColor))
        castbar.SafeZone:SetPoint("TOPRIGHT")
        castbar.SafeZone:SetPoint("BOTTOMRIGHT")
	    castbar:SetFrameLevel(10)
		
		castbar.Lag = Lib.EasyFontString(castbar, sets.lag.font, sets.lag.size, sets.lag.flag)
		castbar.Lag:SetPoint(sets.lag.anchor, castbar, sets.lag.relative, sets.lag.x, sets.lag.y)
		castbar.Lag:SetJustifyH(sets.lag.align or "RIGHT")
		castbar.Lag:Hide()
		
		castbar.unit = unit
		castbar:RegisterEvent("UNIT_SPELLCAST_SENT")
		castbar:SetScript("OnEvent", Cast.OnCastSent)
	end
		
    castbar.OnUpdate = Cast.OnCastbarUpdate
    castbar.PostCastStart = Cast.PostCastStart
    castbar.PostChannelStart = Cast.PostCastStart
    castbar.PostCastStop = Cast.PostCastStop
    castbar.PostChannelStop = Cast.PostChannelStop
    --castbar.PostCastFailed = Cast.PostCastFailed
    castbar.PostCastInterrupted = Cast.PostCastFailed
    castbar.PostCastInterruptible = Cast.PostCastInterruptible
    castbar.PostCastNotInterruptible = Cast.PostCastNotInterruptible
	
	if sets.style and type(sets.style) == "function" then sets.style(castbar, unit) end
	
    frame.Castbar = castbar
end
F.CreateTag = function(frame, unit, sets)
	local tag = Lib.EasyFontString(frame, sets.font, sets.size, sets.flag)
	local anchorto = frame
	if sets.to and frame[sets.to] then anchorto = frame[sets.to] end
		
    tag:SetPoint(sets.anchor, anchorto, sets.relative, sets.x, sets.y)
	if (sets.frequentUpdates) then tag.frequentUpdates = sets.frequentUpdates end
	frame:Tag(tag, sets.str)
end
F.CreateIcon = function(frame, unit, iconType, sets)
    local icon = frame:CreateTexture(nil, 'OVERLAY', frame)
	icon:SetSize(sets.size, sets.size)
	
	local anchorto = frame
	if sets.to and frame[sets.to] then anchorto = frame[sets.to] end
	icon:SetPoint(sets.anchor, anchorto, sets.relative, sets.x, sets.y)
	
	if sets.texture then icon:SetTexture(sets.texture) end
	if sets.color then icon:SetVertexColor(unpack(sets.color)) end
	if sets.coord then icon:SetTexCoord(unpack(sets.coord)) end
	
    frame[iconType] = icon
end

F.PlayerBuffs = function(frame, sets)
    local fbuff = CreateFrame("Frame", nil, frame)
	fbuff.size = sets.size
    fbuff.num = sets.num
    fbuff.spacing = sets.spacing
    fbuff.onlyShowPlayer = false
	
	local rows = math.ceil(sets.num/sets.columns)
	local width = sets.columns*sets.size + (sets.columns+1)*sets.spacing
	local height = rows*sets.size + (rows+1)*sets.spacing
    fbuff:SetHeight(height)
    fbuff:SetWidth(width)
	
	local anchorto = frame
	if (sets.to == "UIParent") then anchorto = UIParent
	elseif sets.to and frame[sets.to] then anchorto = frame[sets.to] end
	fbuff:SetPoint(sets.anchor, anchorto, sets.relative, sets.x, sets.y)
	
	fbuff.initialAnchor = "TOPRIGHT"
	fbuff["growth-x"] = sets.growx or "LEFT"
	fbuff["growth-y"] = sets.growy or "DOWN"
    
    fbuff.PostCreateIcon = postCreateIcon
    fbuff.PostUpdateIcon = postUpdateIcon

    frame.Buffs = fbuff
end
F.PlayerDebuffs = function(frame, sets)
    local fdebuff = CreateFrame("Frame", nil, frame)
	fdebuff.size = sets.size
    fdebuff.num = sets.num
    fdebuff.spacing = sets.spacing
    fdebuff.onlyShowPlayer = false
	
	local rows = math.ceil(sets.num/sets.columns)
	local width = sets.columns*sets.size + (sets.columns+1)*sets.spacing
	local height = rows*sets.size + (rows+1)*sets.spacing
    fdebuff:SetHeight(height)
    fdebuff:SetWidth(width)
	
	local anchorto = frame
	if (sets.to == "UIParent") then anchorto = UIParent
	elseif sets.to and frame[sets.to] then anchorto = frame[sets.to] end
	fdebuff:SetPoint(sets.anchor, anchorto, sets.relative, sets.x, sets.y)
	
	fdebuff.initialAnchor = "BOTTOMRIGHT"
	fdebuff["growth-x"] = sets.growx or "LEFT"
	fdebuff["growth-y"] = sets.growy or "UP"

    fdebuff.PostCreateIcon = postCreateIcon
    fdebuff.PostUpdateIcon = postUpdateIcon

    frame.Debuffs = fdebuff
end
F.CreateAuras = function(frame, sets)
	local fauras = CreateFrame("Frame", nil, frame)
	fauras.size = sets.size
    fauras.numBuffs = sets.numBuffs
	fauras.numDebuffs = sets.numDebuffs
    fauras.spacing = sets.spacing
    fauras.onlyShowPlayer = false
	
	local num = sets.numBuffs + sets.numDebuffs
	local rows = math.ceil(num/sets.columns)
	local width = sets.columns*sets.size + (sets.columns+1)*sets.spacing
	local height = rows*sets.size + (rows+1)*sets.spacing
    fauras:SetHeight(height)
    fauras:SetWidth(width)
	
	local anchorto = frame
	if (sets.to == "UIParent") then anchorto = UIParent
	elseif sets.to and frame[sets.to] then anchorto = frame[sets.to] end
	fauras:SetPoint(sets.anchor, anchorto, sets.relative, sets.x, sets.y)
	
	fauras.onlyShowPlayer = sets.onlyplayer
	
	fauras.gap = true
	fauras.initialAnchor = sets.growanchor or "BOTTOMLEFT"
	fauras["growth-x"] = sets.growx or "RIGHT"		
	fauras["growth-y"] = sets.growy or "UP"
	fauras.PostCreateIcon = postCreateIcon
	fauras.PostUpdateIcon = postUpdateIcon
	frame.Auras = fauras
end

F.CreateClassBar = function(frame, sets)
	if F.BaseInfo.PlayerClass == "DRUID" then F.CreateCPoints(frame, sets)
	elseif F.BaseInfo.PlayerClass == "ROGUE" then F.CreateCPoints(frame, sets)
	elseif F.BaseInfo.PlayerClass == "DEATHKNIGHT" then F.CreateRunes(frame, sets)
	elseif F.BaseInfo.PlayerClass == "WARLOCK" then F.CreateShards(frame, sets)
	elseif F.BaseInfo.PlayerClass == "PALADIN" then F.CreateHolyPower(frame, sets)
	elseif F.BaseInfo.PlayerClass == "SHAMAN" then F.CreateTotemBar(frame, sets)
	elseif F.BaseInfo.PlayerClass == "MONK" then F.CreateChiBar(frame, sets)
	end
end
--DRUID,ROGUE ComboPoints
F.CreateCPoints = function(frame, sets)
	if F.BaseInfo.PlayerClass ~= "DRUID" and F.BaseInfo.PlayerClass ~= "ROGUE" then return end
	
	local bars = CreateFrame("Frame", nil, frame)
    bars:SetHeight(sets.height)
    bars:SetWidth(sets.width)
	bars:SetPoint(sets.anchor, frame, sets.relative, sets.x, sets.y)
	bars:SetFrameStrata("LOW")
		
	local maxnum = MAX_COMBO_POINTS
	for i = 1, maxnum do					
		bars[i] = CreateFrame("StatusBar", nil, bars)
		bars[i]:SetHeight(sets.height)					
		bars[i]:SetStatusBarTexture(sets.texture)
		bars[i]:GetStatusBarTexture():SetHorizTile(false)
							
		if i == 1 then
			bars[i]:SetPoint("LEFT", bars)
		else
			bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", 1, 0)
		end
		
		bars[i]:SetAlpha(0.15)
		bars[i]:SetWidth((bars:GetWidth()-(maxnum-1))/maxnum)
	end
		
	bars[1]:SetStatusBarColor(0.89, 0.89, 0)		
	bars[2]:SetStatusBarColor(0.89, 0.89, 0)
	bars[3]:SetStatusBarColor(0.89, 0.89, 0)
	bars[4]:SetStatusBarColor(0.89, 0.89, 0)
	bars[5]:SetStatusBarColor(0.89, 0.09, 0)
	
	if sets.style and type(sets.style) == "function" then sets.style(bars)
	else BaseStyle(bars) end
	
	frame.CPoints = bars
	--frame.CPoints.Override = CPointsUpdate
end
--DEATHKNIGHT Runes 
F.CreateRunes = function(frame, sets)
	if F.BaseInfo.PlayerClass ~= "DEATHKNIGHT" then return end
	local bars = CreateFrame("Frame", nil, frame)
    bars:SetHeight(sets.height)
    bars:SetWidth(sets.width)
	bars:SetPoint(sets.anchor, frame, sets.relative, sets.x, sets.y)
	bars:SetFrameStrata("LOW")
    bars.points = {}
	
	for i = 1, 6 do
		bars.points[i] = CreateFrame("StatusBar", nil, bars)
		bars.points[i]:SetHeight(sets.height)
		bars.points[i]:SetWidth((bars:GetWidth() - 5) / 6)

		if (i == 1) then
			bars.points[i]:SetPoint("LEFT", bars)
		else
			bars.points[i]:SetPoint("LEFT", bars.points[i-1], "RIGHT", 1, 0)
		end
		bars.points[i]:SetStatusBarTexture(sets.texture)
		bars.points[i]:GetStatusBarTexture():SetHorizTile(false)
	end
	
	if sets.style and type(sets.style) == "function" then sets.style(bars)
	else BaseStyle(bars) end
	
	frame.Runes = bars
end
--WARLOCK     Shards,DemonicFury and Ember  
F.CreateShards = function(frame, sets)
	if F.BaseInfo.PlayerClass ~= "WARLOCK" then return end
	local bars = CreateFrame("Frame", nil, frame)
    bars:SetHeight(sets.height)
    bars:SetWidth(sets.width)
	bars:SetPoint(sets.anchor, frame, sets.relative, sets.x, sets.y)
	bars:SetFrameStrata("LOW")
    bars.points = {}
	
	local maxnum = UnitPowerMax("player", SPELL_POWER_SOUL_SHARDS )
	for i = 1, maxnum do					
		bars.points[i] = CreateFrame("StatusBar", nil, bars)
		bars.points[i]:SetHeight(sets.height)					
		bars.points[i]:SetStatusBarTexture(sets.texture)
		bars.points[i]:GetStatusBarTexture():SetHorizTile(true)
		bars.points[i]:SetStatusBarColor(148/255, 130/255, 201/255)
					
		if i == 1 then
			bars.points[i]:SetPoint("LEFT", bars)
		else
			bars.points[i]:SetPoint("LEFT", bars.points[i-1], "RIGHT", 1, 0)
		end
		bars.points[i]:SetWidth((bars:GetWidth() - (maxnum - 1))/maxnum)
	end
		
	if sets.style and type(sets.style) == "function" then sets.style(bars)
	else BaseStyle(bars) end
		
	frame.SoulShards = bars		
end
--PALADIN     HolyPower
F.CreateHolyPower = function(frame, sets)
	if F.BaseInfo.PlayerClass ~= "PALADIN" then return end
	
	local bars = CreateFrame("Frame", nil, frame)
    bars:SetHeight(sets.height)
    bars:SetWidth(sets.width)
	bars:SetPoint(sets.anchor, frame, sets.relative, sets.x, sets.y)
	bars:SetFrameStrata("LOW")
	
	local maxnum = UnitPowerMax("player", SPELL_POWER_HOLY_POWER)
	for i = 1, maxnum do					
		bars[i]=CreateFrame("StatusBar", nil, bars)
		bars[i]:SetHeight(sets.height)					
		bars[i]:SetStatusBarTexture(sets.texture)
		bars[i]:GetStatusBarTexture():SetHorizTile(false)
		bars[i]:SetStatusBarColor(228/255,225/255,16/255)
		
		if i == 1 then
			bars[i]:SetPoint("LEFT", bars)
		else
			bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", 1, 0)
		end
		
		bars[i]:SetWidth((bars:GetWidth() - (maxnum-1))/maxnum)
	end
	
	if sets.style and type(sets.style) == "function" then sets.style(bars)
	else BaseStyle(bars) end
	
	frame.HolyPower = bars	
end
--SHANMAN     Totem
F.CreateTotemBar = function(frame, sets)
	if F.BaseInfo.PlayerClass ~= "SHAMAN" then return end

	local bars = CreateFrame('Frame', nil, frame)
	bars:SetHeight(sets.height)
    bars:SetWidth(sets.width)
	bars:SetPoint(sets.anchor, frame, sets.relative, sets.x, sets.y)
	bars:SetFrameStrata("LOW")
	
	bars.Destroy = true
	bars.colors = {{233/255, 46/255, 16/255};{173/255, 217/255, 25/255};{35/255, 127/255, 255/255};{178/255, 53/255, 240/255};}

	for i = 1, 4 do
		bars[i] = CreateFrame("StatusBar", nil, bars)
		bars[i]:SetHeight(sets.height)
		bars[i]:SetWidth((bars:GetWidth() - 3)/4)
		bars[i]:SetStatusBarTexture(sets.texture)
		bars[i]:GetStatusBarTexture():SetHorizTile(false)
		bars[i]:SetMinMaxValues(0, 1)
		bars[i]:SetFrameLevel(11)
		
		if (i == 1) then
			bars[i]:SetPoint("LEFT", bars, "LEFT", 0, 0)
		else
			bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", 1, 0)
		end

		bars[i].bg = bars[i]:CreateTexture(nil, "BORDER")
		bars[i].bg:SetAllPoints()
		bars[i].bg:SetTexture(sets.texture)
		bars[i].bg:SetVertexColor(.05, .05, .05,.15)
	end	
	
	if sets.style and type(sets.style) == "function" then sets.style(bars)
	else BaseStyle(bars) end
	
	frame.TotemBar = bars
end
--MONK        Chi
F.CreateChiBar = function(frame, sets)
	if F.BaseInfo.PlayerClass ~= "MONK" then return end
	
	local bars = CreateFrame("Frame", nil, frame)
	bars:SetHeight(sets.height)
    bars:SetWidth(sets.width)
	bars:SetPoint(sets.anchor, frame, sets.relative, sets.x, sets.y)
	bars:SetFrameStrata("LOW")
	bars.points = {}
    
	local maxnum = UnitPowerMax("player", SPELL_POWER_CHI)
	for i = 1, maxnum do					
		bars.points[i] = CreateFrame("StatusBar", nil, bars)
		bars.points[i]:SetHeight(sets.height)					
		bars.points[i]:SetStatusBarTexture(sets.texture)
		bars.points[i]:GetStatusBarTexture():SetHorizTile(false)
        bars.points[i]:SetStatusBarColor(0, 1, .6, .9)
					
		if i == 1 then
			bars.points[i]:SetPoint("LEFT", bars)
		else
			bars.points[i]:SetPoint("LEFT", bars.points[i-1], "RIGHT", 1, 0)
		end

		bars.points[i]:SetWidth((bars:GetWidth() - (maxnum - 1))/maxnum)
	end

	if sets.style and type(sets.style) == "function" then sets.style(bars)
	else BaseStyle(bars) end

	frame.ChiBar = bars	
end

F.CreateAltPower = function(frame, sets)
	local AltPowerBar = CreateFrame("StatusBar", nil, frame)
	AltPowerBar:SetFrameLevel(frame:GetFrameLevel() + 1)

	AltPowerBar:SetStatusBarTexture(sets.texture)
	AltPowerBar:GetStatusBarTexture():SetHorizTile(false)
	AltPowerBar:EnableMouse(true)
	AltPowerBar:SetFrameStrata("HIGH")
	AltPowerBar:SetFrameLevel(5)
	
	local anchorto = GetSetsTo(frame, sets.to)

	AltPowerBar:SetPoint(sets.anchor, anchorto, sets.relative, sets.x, sets.y)
	AltPowerBar:SetWidth(sets.width)
	AltPowerBar:SetHeight(sets.height)

	AltPowerBar.text = Lib.EasyFontString(AltPowerBar, sets.font, sets.fontsize, sets.fontflag)
	AltPowerBar.text:SetPoint("CENTER")
	AltPowerBar.text:SetJustifyH("CENTER")
	frame:Tag(AltPowerBar.text, '[altpower]')
	
	if sets.style and type(sets.style) == "function" then sets.style(AltPowerBar)
	else BaseStyle(AltPowerBar) end
	
	frame.AltPowerBar = AltPowerBar		
	frame.AltPowerBar.PostUpdate = AltPowerBarPostUpdate
end
F.CreateThreatBar = function(frame, sets)
	local ThreatBar = CreateFrame("StatusBar", nil, frame)
	ThreatBar:SetFrameLevel(5)  
    local colors = sets.colors or {
        [1] = {12/255, 151/255,  15/255,.9},
        [2] = {166/255, 171/255,  26/255,.9},
        [3] = {163/255,  24/255,  24/255,.9},
    }
	ThreatBar.Colors = colors
	ThreatBar:SetStatusBarTexture(sets.texture)
	ThreatBar:GetStatusBarTexture():SetHorizTile(false)	   

	local anchorto = GetSetsTo(frame, sets.to)
	
	ThreatBar:SetPoint(sets.anchor, anchorto, sets.relative, sets.x, sets.y)
	ThreatBar:SetWidth(sets.width)
	ThreatBar:SetHeight(sets.height)
	
	ThreatBar.Text = Lib.EasyFontString(ThreatBar, sets.font, sets.fontsize, sets.fontflag)
	ThreatBar.Text:SetPoint("CENTER")	
	ThreatBar.Text:SetJustifyH("CENTER")	
	  
	ThreatBar.useRawThreat = false
	
    ThreatBar.usePlayerTarget = true
    
	if sets.style and type(sets.style) == "function" then sets.style(ThreatBar)
	else BaseStyle(ThreatBar) end
	
	frame.ThreatBar = ThreatBar
end

F.Test = function()
	UnitAura = function()
		return 'penancelol', 'Rank 2', 'Interface\\Icons\\Spell_Holy_Penance', random(5), 'Magic', 0, 0, "player"
	end
	if(oUF) then
		for i, v in pairs(MoeUF.FrameList) do
			if(v.UNIT_AURA) then
				v:UnregisterAllEvents()
				v:UNIT_AURA("UNIT_AURA", v.unit)
				v.UpdateAllElements = nil
				v:Show()
			end
		end
	end
end






