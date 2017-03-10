local addon, namespace = ...
local Lib = namespace.Moe.Lib
local Media = namespace.Moe.Media
local Theme = namespace.Moe.Theme
---------------------------------------------
----GUI Theme                            ----
---------------------------------------------
local UIDB = {
	--µ×²¿²¿·Ö
    {   name = "BG_BottomLeft",         parent = "UIParent",				
        point = {"BOTTOMLEFT", 0, 0},
        level = 1,
        height = 180, width = 0.24*GetScreenWidth(),
        grad = {"HORIZONTAL", 0, 0, 0, .7, 0, 0, 0, 0},
        color = {1, 1, 1, 1},
	},
	{   name = "BG_BottomLeftLine1",    parent = "UIParent",
        point = {"BOTTOMLEFT", "Moe_BG_BottomLeft", "BOTTOMLEFT", 0, 18}, 
        level = 1, 
        height = 2, width = 0.24*GetScreenWidth(),
        grad = {"HORIZONTAL", 1, 1, 1, .5, 1, 1, 1, 0}, 
        color = {1, 1, 1, 1},
	},
    {   name = "BG_BottomLeftLine2",    parent = "UIParent",	
		point = {"TOPLEFT", "Moe_BG_BottomLeft", "TOPLEFT", 0, -18},
		level = 1,
		height = 2, width = 0.24*GetScreenWidth(),
		grad = {"HORIZONTAL",  1, 1, 1, .5, 1, 1, 1, 0},
		color = {1, 1, 1, 1},
	},
    {   name = "BG_BottomLeftLine3",    parent = "UIParent",	
		point = {"BOTTOMLEFT", "Moe_BG_BottomLeft", "TOPLEFT", 0, 0},
		level = 1,
		height = 2, width = 0.24*GetScreenWidth(),
		grad = {"HORIZONTAL",  1, 1, 1, .5, 1, 1, 1, 0},
		color = {1, 1, 1, 1},
	},
    {   name = "BG_BottomRight",        parent = "UIParent",
        point = {"BOTTOMRIGHT", 0, 0},
        level = 1,
        height = 180, width = 0.24*GetScreenWidth(),
        grad = {"HORIZONTAL", 0, 0, 0, 0, 0, 0, 0, .5},
        color = {1, 1, 1, 1},
	},
	{   name = "BG_BottomRightLine1",   parent = "UIParent",
        point = {"BOTTOMRIGHT", "Moe_BG_BottomRight", "BOTTOMRIGHT", 0, 18}, 
        level = 1,
        height = 2, width = 0.24*GetScreenWidth(),
        grad = {"HORIZONTAL", 1, 1, 1, 0, 1, 1, 1, .5},
        color = {1, 1, 1, 1},
	},
    {   name = "BG_BottomRightLine2",   parent = "UIParent",
        point = {"TOPRIGHT", "Moe_BG_BottomRight", "TOPRIGHT", 0, -18}, 
        level = 1,
        height = 2, width = 0.24*GetScreenWidth(),
        grad = {"HORIZONTAL", 1, 1, 1, 0, 1, 1, 1, .5},
        color = {1, 1, 1, 1},
	},
    {   name = "BG_BottomRightLine3",   parent = "UIParent",
        point = {"BOTTOMRIGHT", "Moe_BG_BottomRight", "TOPRIGHT", 0, 0}, 
        level = 1,
        height = 2, width = 0.24*GetScreenWidth(),
        grad = {"HORIZONTAL", 1, 1, 1, 0, 1, 1, 1, .5},
        color = {1, 1, 1, 1},
	},
}

local StyleSkada = function()
	if not IsAddOnLoaded("Skada") then return end
	if(SkadaDB) then table.wipe(SkadaDB) end

	SkadaDB = {
		["hasUpgraded"] = true,
        ["profiles"] = {
            ["Default"] = {
                ["windows"] = {
                    {
                        ["barheight"] = 16,
                        ["barslocked"] = true,
                        ["y"] = 20,
                        ["x"] = 0,
                        ["title"] = {
                            ["color"] = {
                                ["a"] = 0,
                                ["b"] = 0,
                                ["g"] = 0,
                                ["r"] = 0,
                            },
                            ["font"] = "ÁÄÌì",
                            ["fontsize"] = 13,
                            ["fontflags"] = "OUTLINE",
                            ["texture"] = "GradientH",
                        },
                        ["barorientation"] = 3,
                        ["mode"] = "ÉËº¦",
                        ["bartexture"] = "GradientH",
                        ["barwidth"] = 325,
                        ["barspacing"] = 1,
                        ["point"] = "BOTTOMRIGHT",
                        ["barfontsize"] = 13,
                        ["background"] = {
                            ["height"] = 138.999954223633,
                        },
                        ["buttons"] = {
                            ["report"] = false,
                            ["menu"] = false,
                            ["mode"] = false,
                            ["reset"] = false,
                        },
                    }, -- [1]
                },
                ["icon"] = {
                    ["hide"] = true,
                },
                ["report"] = {
                    ["channel"] = "raid",
                    ["mode"] = "ÉËº¦",
                },
                ["onlykeepbosses"] = true,
            },
        },
	}
    
    C_Timer.After(4, function()
        SkadaBarWindowSkada.button:ClearAllPoints()
        SkadaBarWindowSkada.button:SetPoint("BOTTOM", SkadaBarWindowSkada, "TOP", 0, 3)
    end)
end
local StyleCoolline = function()
    if not IsAddOnLoaded("CoolLine") then return end
	if(CoolLineDB) then table.wipe(CoolLineDB) end
    CoolLineDB = {
        ["hidebag"] = true,
        ["bgcolor"] = {
            ["a"] = 1,
            ["b"] = 0.14,
            ["g"] = 0.14,
            ["r"] = 0.14,
        },
        ["border"] = "Blizzard Tooltip",
        ["borderinset"] = 2,
        ["h"] = 25,
        ["fontsize"] = 14,
        ["block"] = {
            ["Â¯Ê¯"] = true,
        },
        ["vertical"] = false,
        ["iconplus"] = 4,
        ["spellcolor"] = {
            ["a"] = 1,
            ["b"] = 0,
            ["g"] = 0.4,
            ["r"] = 0.8,
        },
        ["x"] = 0,
        ["nospellcolor"] = {
            ["a"] = 1,
            ["b"] = 0,
            ["g"] = 0,
            ["r"] = 0,
        },
        ["inactivealpha"] = 0.5,
        ["bordercolor"] = {
            ["a"] = 0,
            ["b"] = 0,
            ["g"] = 0,
            ["r"] = 0,
        },
        ["w"] = 371,
        ["hidepet"] = true,
        ["y"] = -163,
        ["activealpha"] = 1,
        ["dbinit"] = 3,
        ["reverse"] = false,
        ["bordersize"] = 8,
        ["font"] = "ÉËº¦Êý×Ö",
        ["fontcolor"] = {
            ["a"] = 0.8,
            ["b"] = 1,
            ["g"] = 1,
            ["r"] = 1,
        },
        ["statusbar"] = "GradientC",
    }
end
local StyleChatFrame = function()
    local cf1 = _G["ChatFrame1"]
    local screenWidth, screenHeight = GetScreenWidth(), GetScreenHeight()
    local xOffset = 2/screenWidth
    local yOffset = 24/screenHeight
    SetChatWindowSavedPosition(cf1:GetID(), "BOTTOMLEFT", xOffset, yOffset)
	SetChatWindowSavedDimensions(cf1:GetID(), 0.22 * GetScreenWidth(), 132)
    SetChatWindowAlpha(cf1:GetID(), 0)
    SetCVar("chatStyle","classic")
end
local StyleAddons = function() 
    StyleSkada()
    StyleCoolline()
    StyleChatFrame()
end
local GUITheme = {
    Frames = UIDB,
    StyleAddons = StyleAddons,
    Logo = nil,
}

---------------------------------------------
----UF Theme                             ----
---------------------------------------------
local MoeUF = namespace.Moe.Modules:Get("UnitFrame")
local dfont = Media.Fonts.Default
local bar_texture = Media.Bar.GradV
local bar_texture2 = Media.Bar.GradC
local bar_texture3 = Media.Bar.GradCR
local bar_normal = Media.Bar.Armory
local bar_hgrad = Media.Bar.GradH
local arrow_width = 1
local arrow_font = Media.Fonts.Default
local arrow_fontsize = 15
local arrow_fontflag = "THINOUTLINE"
local style_color = {1, 1, 1, .9}
local style_lineheight = 1
local style_brwidth = 1

local function HealthUpdate(self, event, unit)
	if(self.unit ~= unit) then return end
	local health = self.Health

	if(health.PreUpdate) then health:PreUpdate(unit) end

	local min, max = UnitHealth(unit), UnitHealthMax(unit)
	local disconnected = not UnitIsConnected(unit)
	health:SetMinMaxValues(0, max)

	if(disconnected) then
		health:SetValue(max)
	else
		health:SetValue(max - min)
	end

	health.disconnected = disconnected

	local r, g, b, t
	if(health.colorTapping and not UnitPlayerControlled(unit) and
		UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit) and not
		UnitIsTappedByAllThreatList(unit)) then
		t = self.colors.tapped
	elseif(health.colorDisconnected and not UnitIsConnected(unit)) then
		t = self.colors.disconnected
	elseif(health.colorClass and UnitIsPlayer(unit)) or
		(health.colorClassNPC and not UnitIsPlayer(unit)) or
		(health.colorClassPet and UnitPlayerControlled(unit) and not UnitIsPlayer(unit)) then
		local _, class = UnitClass(unit)
		t = self.colors.class[class]
	elseif(health.colorReaction and UnitReaction(unit, 'player')) then
		t = self.colors.reaction[UnitReaction(unit, "player")]
	elseif(health.colorSmooth) then
		r, g, b = self.ColorGradient(min, max, unpack(health.smoothGradient or self.colors.smooth))
	elseif(health.colorHealth) then
		t = self.colors.health
	end

	if(t) then
		r, g, b = t[1], t[2], t[3]
	end

	if(b) then
		health:SetStatusBarColor(r, g, b)

		local bg = health.bg
		if(bg) then local mu = bg.multiplier or 1
			bg:SetVertexColor(r * mu, g * mu, b * mu)
		end
	end

	if(health.PostUpdate) then
		return health:PostUpdate(unit, min, max)
	end
end
local function PowerUpdate(self, event, unit)
	if(self.unit ~= unit) then return end
	local power = self.Power

	if(power.PreUpdate) then power:PreUpdate(unit) end

	local displayType, min
	if power.displayAltPower then
		displayType, min = GetDisplayPower(unit)
	end
	local cur, max = UnitPower(unit, displayType), UnitPowerMax(unit, displayType)
	local disconnected = not UnitIsConnected(unit)
	power:SetMinMaxValues(min or 0, max)

	if(disconnected) then
		power:SetValue(max)
	else
		power:SetValue(max - cur)
	end

	power.disconnected = disconnected

	local r, g, b, t
	if(power.colorTapping and not UnitPlayerControlled(unit) and
		UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit) and not
		UnitIsTappedByAllThreatList(unit)) then
		t = self.colors.tapped
	elseif(power.colorDisconnected and disconnected) then
		t = self.colors.disconnected
	elseif(displayType == ALTERNATE_POWER_INDEX and power.altPowerColor) then
		t = power.altPowerColor
	elseif(power.colorPower) then
		local ptype, ptoken, altR, altG, altB = UnitPowerType(unit)

		t = self.colors.power[ptoken]
		if(not t) then
			if(power.GetAlternativeColor) then
				r, g, b = power:GetAlternativeColor(unit, ptype, ptoken, altR, altG, altB)
			elseif(altR) then
				r, g, b = altR, altG, altB
			else
				t = self.colors.power[ptype]
			end
		end
	elseif(power.colorClass and UnitIsPlayer(unit)) or
		(power.colorClassNPC and not UnitIsPlayer(unit)) or
		(power.colorClassPet and UnitPlayerControlled(unit) and not UnitIsPlayer(unit)) then
		local _, class = UnitClass(unit)
		t = self.colors.class[class]
	elseif(power.colorReaction and UnitReaction(unit, 'player')) then
		t = self.colors.reaction[UnitReaction(unit, "player")]
	elseif(power.colorSmooth) then
        local adjust = 0 - (min or 0)
		r, g, b = self.ColorGradient(cur + adjust, max + adjust, unpack(power.smoothGradient or self.colors.smooth))
	end

	if(t) then
		r, g, b = t[1], t[2], t[3]
	end

	if(b) then
		power:SetStatusBarColor(r, g, b, .5)
	end

	if(power.PostUpdate) then
		return power:PostUpdate(unit, cur, max, min)
	end
end
local function HealthArrowMove(self, event)
	--if unit ~= self.unit then return end
	local perchp = UnitHealthMax(self.unit) == 0 and 0 or UnitHealth(self.unit)/UnitHealthMax(self.unit)
	local bar = self:GetParent()

	self:ClearAllPoints()

	if self.unit == "player" then
		self:SetPoint("CENTER", bar, "LEFT", bar:GetWidth()*perchp, 0)
	elseif self.unit == "target" then
		self:SetPoint("CENTER", bar, "RIGHT", bar:GetWidth()*-perchp, 0)
	end
end
local function PowerArrowMove(self, event)
	--if unit ~= self.unit then return end
	local percpp = UnitPowerMax(self.unit) == 0 and 0 or UnitPower(self.unit)/UnitPowerMax(self.unit)
	local bar = self:GetParent()
	
	self:ClearAllPoints()

	if self.unit == "player" then
		self:SetPoint("CENTER", bar, "LEFT", bar:GetWidth()*percpp, 0)
	elseif self.unit == "target" then
		self:SetPoint("CENTER", bar, "RIGHT", bar:GetWidth()*-percpp, 0)
	end
end
local function CreateMoveArrow(frame, unit, bar)
	local arrow = CreateFrame("Frame", nil, frame[bar])
	arrow:SetPoint("CENTER",0,0)
	arrow.bg = arrow:CreateTexture(nil,"ARTWORK")
	arrow.bg:SetTexture(bar_texture)
	arrow.bg:SetVertexColor(.9,.9,.3,.9)
	arrow.bg:SetAllPoints()
	arrow:SetHeight(frame[bar]:GetHeight())
	arrow:SetWidth(arrow_width)
	
	arrow.unit = unit
	if bar == "Health" then
		arrow:RegisterEvent("UNIT_HEALTH")
		arrow:RegisterEvent("PLAYER_TARGET_CHANGED")
		arrow:SetScript("OnEvent", HealthArrowMove)
		HealthArrowMove(arrow, "UNIT_HEALTH", unit)
	elseif bar == "Power" then
		Lib.Flip(arrow.bg, "VERTICAL")
		arrow:RegisterEvent("UNIT_POWER")
		arrow:RegisterEvent("PLAYER_TARGET_CHANGED")
		arrow:SetScript("OnEvent", PowerArrowMove)
		PowerArrowMove(arrow, "UNIT_POWER", unit)
	end
	
end
local function PlayerTargetStyle(frame, unit)
	local r, g, b, a = unpack(style_color)
	local middleLine = frame:CreateTexture(nil, 'OVERLAY', frame)
	middleLine:SetWidth(frame.Health:GetWidth() + 2)
	middleLine:SetHeight(style_lineheight)
	middleLine:SetPoint("TOP", frame.Health, "BOTTOM", 0, 0)
	middleLine:SetTexture(Media.Texture.Blank)

	local hLeftBr = frame:CreateTexture(nil, 'OVERLAY', frame)
	hLeftBr:SetWidth(style_brwidth)
	hLeftBr:SetHeight(frame.Health:GetHeight())
	hLeftBr:SetPoint("RIGHT", frame.Health, "LEFT", 0, 0)
	hLeftBr:SetGradientAlpha("VERTICAL", r, g, b, a, r, g, b, 0)
	hLeftBr:SetTexture(Media.Texture.Blank)
	local hRightBr = frame:CreateTexture(nil, 'OVERLAY', frame)
	hRightBr:SetWidth(style_brwidth)
	hRightBr:SetHeight(frame.Health:GetHeight())
	hRightBr:SetPoint("LEFT", frame.Health, "RIGHT", 0, 0)
	hRightBr:SetGradientAlpha("VERTICAL", r, g, b, a, r, g, b, 0)
	hRightBr:SetTexture(Media.Texture.Blank)
	
	local pLeftBr = frame:CreateTexture(nil, 'OVERLAY', frame)
	pLeftBr:SetWidth(style_brwidth)
	pLeftBr:SetHeight(frame.Power:GetHeight())
	pLeftBr:SetPoint("RIGHT", frame.Power, "LEFT", 0, 0)
	pLeftBr:SetGradientAlpha("VERTICAL", r, g, b, 0, r, g, b, a)
	pLeftBr:SetTexture(Media.Texture.Blank)
	local pRightBr = frame:CreateTexture(nil, 'OVERLAY', frame)
	pRightBr:SetWidth(style_brwidth)
	pRightBr:SetHeight(frame.Power:GetHeight())
	pRightBr:SetPoint("LEFT", frame.Power, "RIGHT", 0, 0)
	pRightBr:SetGradientAlpha("VERTICAL", r, g, b, 0, r, g, b, a)
	pRightBr:SetTexture(Media.Texture.Blank)
	
	CreateMoveArrow(frame, unit, "Health")
	CreateMoveArrow(frame, unit, "Power")
	frame.Health.Override = HealthUpdate
	frame.Power.Override = PowerUpdate
end
local function PetToTStyle(frame, unit)
	local r, g, b, a = unpack(style_color)
	local bottomLine = frame:CreateTexture(nil, 'OVERLAY', frame)
	bottomLine:SetWidth(frame.Health:GetWidth())
	bottomLine:SetHeight(style_lineheight)
	bottomLine:SetPoint("TOP", frame.Health, "BOTTOM", 0, 0)
	bottomLine:SetTexture(Media.Texture.Blank)

	if unit == "pet" then
		frame:SetPoint("BOTTOMRIGHT", MoeUF.FrameList["player"].Health, "BOTTOMLEFT", -1, 0)
		frame.locked = true
		bottomLine:SetGradientAlpha("HORIZONTAL", r, g, b, 0, r, g, b, a)
	elseif unit == "targettarget" then
		frame:SetPoint("BOTTOMLEFT", MoeUF.FrameList["target"].Health, "BOTTOMRIGHT", 1, 0)
		frame.locked = true
		bottomLine:SetGradientAlpha("HORIZONTAL", r, g, b, a, r, g, b, 0)
	end
	frame.Health.Override = HealthUpdate
end
local function FocusStyle(frame, unit)
	Lib.CreateBorder(frame.Health, 1, {1,1,1,0}, {1,1,1,.9})
	Lib.CreateBorder(frame.Power, 1, {1,1,1,0}, {1,1,1,.9})	
	frame.Health.Override = HealthUpdate
	frame.Power.Override = PowerUpdate
end
local function FocusTargetStyle(frame, unit)
	Lib.CreateBorder(frame.Health, 1, {1,1,1,0}, {1,1,1,.9})
	frame.Health.Override = HealthUpdate
end
local function CastBarStyle(bar, unit)
	local r, g, b, a = unpack(style_color)
	local line = bar:CreateTexture(nil, 'OVERLAY', bar)
	line:SetWidth(bar:GetWidth() + 2)
	line:SetHeight(style_lineheight)
	line:SetTexture(Media.Texture.Blank)
	
	local a1, a2 = a, 0
	if (unit == "player") then 
		a1, a2 = 0, a 
		Lib.Flip(bar.Spark, "VERTICAL")
        Lib.Flip(bar.SafeZone, "VERTICAL")
		Lib.Flip(bar:GetStatusBarTexture(), "VERTICAL")
		line:SetPoint("BOTTOM", bar, "TOP", 0, 0)
	else
		line:SetPoint("TOP", bar, "BOTTOM", 0, 0)
	end
	
	local hLeftBr = bar:CreateTexture(nil, 'OVERLAY', bar)
	hLeftBr:SetWidth(style_brwidth)
	hLeftBr:SetHeight(bar:GetHeight())
	hLeftBr:SetPoint("RIGHT", bar, "LEFT", 0, 0)
	hLeftBr:SetGradientAlpha("VERTICAL", r, g, b, a1, r, g, b, a2)
	hLeftBr:SetTexture(Media.Texture.Blank)
	local hRightBr = bar:CreateTexture(nil, 'OVERLAY', bar)
	hRightBr:SetWidth(style_brwidth)
	hRightBr:SetHeight(bar:GetHeight())
	hRightBr:SetPoint("LEFT", bar, "RIGHT", 0, 0)
	hRightBr:SetGradientAlpha("VERTICAL", r, g, b, a1, r, g, b, a2)
	hRightBr:SetTexture(Media.Texture.Blank)
end
local function GlobalStyle(frames)
    if frames["player"].ThreatBar then
        frames["player"].ThreatBar:SetPoint("TOPLEFT",frames["target"],"BOTTOMLEFT",0,-5)
    end
end

local UFTheme = {
	Unit = {
		player = {
			width = 220, height = 51,
			health = {
				texture = bar_texture,
				reverse = true,
				height = 30, width = 220,
				color = {r = .95, g = 0.05, b = 0.05, a = .5},
				anchor = "TOP", relative = "TOP", x = 0, y = 0,
				flipv = false, 
				background = {
					texture = bar_texture,
					color = {r = .05, g = .05, b = .05, a = .7},
				}
			},
			power = {
				texture = bar_texture,
				reverse = true,
				height = 20, width = 160,
				usepowercolor = true,
				color = {r = 0, g = 0, b = 0, a = .5},
				anchor = "BOTTOMRIGHT", relative = "BOTTOMRIGHT", x = 0, y = 0,
				background = {
					texture = bar_texture,
					color = {r = .05, g = .05, b = .05, a = .6},
				},
				flipv = true, 
			},
			icons = {
				["Combat"] = {anchor = "TOPRIGHT", relative = "TOPLEFT", x = -1, y = 0, size = 20, to = "Power", texture = bar_texture2, color = {.9,.1,.05,1}},
				--["Leader"] = {anchor = "TOPRIGHT", relative = "TOPLEFT", x = -2, y = 0, size = 12 },
				--["Assistant"] = {anchor = "TOPRIGHT", relative = "TOPLEFT", x = -2, y = -14, size = 12 },
				--["MasterLooter"] = {anchor = "TOPRIGHT", relative = "TOPLEFT", x = -2, y = -28, size = 12 },
				["RaidIcon"] = {anchor = "CENTER", relative = "TOP", x = 0, y = 5, size = 16, texture = "Interface\\TARGETINGFRAME\\UI-RaidTargetingIcons"},
			},
			tags = {
				name = { str = "[color][name][afkdnd]", font = dfont, size = 12, flag = "THINOUTLINE", align = "RIGHT", anchor = "BOTTOMRIGHT", relative = "TOPRIGHT", x = 0, y = 3, },
				hp = { str = "[dothp]", frequentUpdates = 0.1, font = Media.Fonts.C, size = 14, flag = "THINOUTLINE", align = "LEFT", anchor = "BOTTOMLEFT", relative = "TOPLEFT", x = 0, y = 2, },
				dperhp = { str = "[dperhp]", frequentUpdates = 0.1, font = Media.Fonts.NUM1, size = 14, flag = "THINOUTLINE", align = "RIGHT", anchor = "RIGHT", relative = "RIGHT",  to = "Health", x = 0, y = -4, },
				pp = { str = "[dperpp]", frequentUpdates = 0.1, font = Media.Fonts.NUM1, size = 14, flag = "THINOUTLINE", align = "RIGHT", anchor = "RIGHT", relative = "RIGHT", to = "Power", x = 0, y = -3, },
			},
			castbar = {
				height = 20, width = 235,
				anchor = "TOP", relative = "CENTER", x = 0, y = -128, to = "UIParent",
				text = {font = dfont, size = 12, flag = "THINOUTLINE", anchor = "LEFT", relative = "LEFT", x = 2, y = 1 },
				time = {font = dfont, size = 12, flag = "THINOUTLINE", anchor = "RIGHT", relative = "RIGHT", x = -2, y = 1 },
				lag  = {font = dfont, size = 10, flag = "THINOUTLINE", anchor = "RIGHT", relative = "RIGHT", x = -2, y = -10 },
				icon = {show = false, size = 14, anchor = "RIGHT", relative = "LEFT", x = -4, y = 0 },
				style = CastBarStyle,
			},
			highlight = {
				Texture = bar_texture,
				Color = {160/255, 160/255, 160/255, .3},
			},
			buffs = {
				size = 24, num = 40, spacing = 8, anchor = "TOPRIGHT", relative = "TOPRIGHT", to = "UIParent",
				x = -150, y = -10, columns = 10,
			},
			debuffs = {
				size = 25, num = 21, spacing = 7, anchor = "BOTTOMRIGHT", relative = "TOPRIGHT",
				x = 0, y = 25, columns = 7,
			},
			style = PlayerTargetStyle,
		},
		target = {
			width = 220, height = 51,
			health = {
				texture = bar_texture,
				reverse = false,
				height = 30, width = 220,
				color = {r = .95, g = .05, b = .05, a = 1},
				anchor = "TOP", relative = "TOP", x = 0, y = 0,
				background = {
					texture = bar_texture,
					color = {r = .05, g = .05, b = .05, a = .7},
				},
				flipv = false,
			},
			power = {
				texture = bar_texture,
				reverse = false,
				height = 20, width = 160,
				color = {r = 0, g = 0, b = 0, a = .5},
				usepowercolor = true,
				anchor = "BOTTOMLEFT", relative = "BOTTOMLEFT", x = 0, y = 0,
				background = {
					texture = bar_texture,
					color = {r = .05, g = .05, b = .05, a = .9},
				},
				flipv = true,
			},
			icons = {
				["RaidIcon"] = {anchor = "CENTER", relative = "TOP", x = 0, y = 2, size = 16, texture = "Interface\\TARGETINGFRAME\\UI-RaidTargetingIcons"},
				["QuestIcon"] = {anchor = "TOPLEFT", relative = "TOPLEFT", x = 0, y = 8, size = 16}
			},
			tags = {
				name = { str = "[level] [color][name][afkdnd]", font = dfont, size = 12, flag = "THINOUTLINE", align = "LEFT", anchor = "BOTTOMLEFT", relative = "TOPLEFT", x = 0, y = 3, },
				hp = { str = "[dothp]", frequentUpdates = 0.1, font = Media.Fonts.C, size = 14, flag = "THINOUTLINE", align = "RIGHT", anchor = "BOTTOMRIGHT", relative = "TOPRIGHT", x = 0, y = 2, },
				dperhp = { str = "[dperhp]", frequentUpdates = 0.1, font = Media.Fonts.NUM1, size = 14, flag = "THINOUTLINE", align = "LEFT", anchor = "LEFT", relative = "LEFT", to = "Health", x = 3, y = -5, },
				pp = { str = "[dperpp]", frequentUpdates = 0.1, font = Media.Fonts.NUM1, size = 14, flag = "THINOUTLINE", align = "LEFT", anchor = "LEFT", relative = "LEFT", to = "Power", x = 3, y = -3, },
			},
			castbar = {
				height = 20, width = 235, reverse = true,
				anchor = "BOTTOM", relative = "CENTER", x = 0, y = -78, to = "UIParent",
				text = {font = dfont, size = 12, flag = "THINOUTLINE", anchor = "LEFT", relative = "LEFT", x = 2, y = 1 },
				time = {font = dfont, size = 12, flag = "THINOUTLINE", anchor = "RIGHT", relative = "RIGHT", x = -2, y = 1 },
				icon = {size = 14, anchor = "LEFT", relative = "RIGHT", x = 4, y = 0 },
				style = CastBarStyle,
			},
			highlight = {
				Texture = bar_texture,
				Color = {160/255, 160/255, 160/255, .3},
			},
			auras = {
				size = 16, numBuffs = 16, numDebuffs = 33, spacing = 6, anchor = "BOTTOMLEFT", relative = "TOPLEFT",
				onlyplayer = false, growx = "RIGHT", growy = "UP", 
				x = 0, y = 25, columns = 10,
			},
			style = PlayerTargetStyle,
		},
		pet = {
			width = 120, height = 30,
			health = {
				texture = bar_texture2,
				reverse = false,
				height = 30, width = 120,
				color = {r = .95, g = .05, b = .05, a = 1},
				anchor = "TOP", relative = "TOP", x = 0, y = 0,
				flipv = true,
				background = {
					texture = bar_texture2,
					color = {r = .05, g = .05, b = .05, a = .9},
				},
			},
			highlight = {
				Texture = bar_texture2,
				flipv = true,
				Color = {160/255, 160/255, 160/255, .3},
			},
			tags = {
				name = { str = "[color][name] | [dperhp]", font = Media.Fonts.T, size = 12, flag = "THINOUTLINE", align = "RIGHT", anchor = "TOPRIGHT", relative = "BOTTOMRIGHT", x = 0, y = -2, },
				--perhp = { str = "[dperhp]", font = Media.FONT, size = 12, flag = "THINOUTLINE", align = "RIGHT", anchor = "RIGHT", relative = "RIGHT", x = 0, y = 0, },
			},
			style = PetToTStyle,
		},
		targettarget = {
			width = 120, height = 30,
			health = {
				texture = bar_texture2,
				reverse = true,
				height = 30, width = 120,
				color = {r = .95, g = .05, b = .05, a = 1},
				anchor = "TOP", relative = "TOP", x = 0, y = 0,
				flipv = true, fliph = true, 
				background = {
					texture = bar_texture2,
					color = {r = .05, g = .05, b = .05, a = .9},
				},
			},
			highlight = {
				Texture = bar_texture2,
				flipv = true, fliph = true, 
				Color = {160/255, 160/255, 160/255, .3},
			},
			tags = {
				name = { str = "[dperhp] | [color][name]", font = Media.Fonts.T, size = 12, flag = "THINOUTLINE", align = "LEFT", anchor = "TOPLEFT", relative = "BOTTOMLEFT", x = 0, y = -2, },
				--perhp = { str = "[dperhp]", font = Media.FONT, size = 12, flag = "THINOUTLINE", align = "LEFT", anchor = "LEFT", relative = "LEFT", x = 0, y = 0, },
			},
			style = PetToTStyle,
		},
		focus = {
			width = 150, height = 38,
			health = {
				texture = bar_hgrad,
				reverse = true,
				height = 25, width = 150,
				color = {r = .95, g = 0.05, b = 0.05, a = 1},
				anchor = "TOP", relative = "TOP", x = 0, y = 0,
			},
			power = {
				texture = bar_normal,
				reverse = true,
				height = 10, width = 150,
				usepowercolor = true,
				color = {r = 0, g = 0, b = 0, a = 1},
				anchor = "BOTTOM", relative = "BOTTOM", x = 0, y = 0,
			},
			tags = {
				name = { str = "[color][name] | [dperhp]", font = Media.Fonts.T, size = 12, flag = "THINOUTLINE", align = "RIGHT", anchor = "RIGHT", relative = "RIGHT", to = "Health", x = 0, y = 0, },
				--perhp = { str = "", font = Media.FONT, size = 12, flag = "THINOUTLINE", align = "RIGHT", anchor = "RIGHT", relative = "RIGHT", to = "Health", x = 0, y = 0, },
			},
			auras = {
				show = true,
				size = 18, numBuffs = 4, numDebuffs = 12, spacing = 6, 
				anchor = "BOTTOMRIGHT", relative = "TOPRIGHT",
				onlyplayer = true, growx = "LEFT", growy = "UP", growanchor = "BOTTOMRIGHT",
				x = 0, y = 5, columns = 8,
			},
			castbar = {
				show = true,
				height = 15, width = 150,
				anchor = "TOP", relative = "BOTTOM", x = 0, y = -4,
				text = {font = dfont, size = 12, flag = "THINOUTLINE", anchor = "LEFT", relative = "LEFT", x = 2, y = 1 },
				time = {font = dfont, size = 12, flag = "THINOUTLINE", anchor = "RIGHT", relative = "RIGHT", x = -2, y = 1 },
				icon = {show = false, size = 14, anchor = "RIGHT", relative = "LEFT", x = -4, y = 0 },
				border = true,
			},
			style = FocusStyle,
		},
		focustarget = {
			width = 150, height = 20,
			health = {
				texture = bar_hgrad,
				reverse = true,
				height = 20, width = 150,
				color = {r = .95, g = 0.05, b = 0.05, a = 1},
				anchor = "TOP", relative = "TOP", x = 0, y = 0,
			},
			tags = {
				name = { str = "[color][name] | [dperhp]", font = Media.Fonts.T, size = 12, flag = "THINOUTLINE", align = "RIGHT", anchor = "RIGHT", relative = "RIGHT", x = 0, y = 0, },
				--perhp = { str = "[dperhp]", font = Media.FONT, size = 12, flag = "THINOUTLINE", align = "RIGHT", anchor = "RIGHT", relative = "RIGHT", x = 0, y = 0, },
			},
			style = FocusTargetStyle,
		},
		boss = {
			width = 150, height = 20,
			health = {
				texture = bar_normal,
				reverse = true,
				height = 20, width = 150,
				color = {r = .95, g = 0.05, b = 0.05, a = .4},
				anchor = "TOP", relative = "TOP", x = 0, y = 0,
				fliph = true,
			},
			tags = {
				name = { str = "[dperhp] | [color][name]", font = Media.Fonts.T, size = 12, flag = "THINOUTLINE", align = "LEFT", anchor = "LEFT", relative = "LEFT", x = 0, y = 0, },
				--perhp = { str = "[dperhp]", font = Media.FONT, size = 12, flag = "THINOUTLINE", align = "RIGHT", anchor = "RIGHT", relative = "RIGHT", x = 0, y = 0, },
			},
			style = FocusTargetStyle,
		}
	},
	Global = {
		castbar = {
			Texture           = bar_texture, --"Interface\\AddOns\\Moe_UF\\media\\textures\\normTex",
			SparkTexture      = bar_texture,
			Color		      = { 95/255, 182/255, 255/255, .7},
			CastingColor      = { 95/255, 182/255, 255/255},
			CompleteColor     = { 20/255, 208/255,   0/255},
			FailColor         = {255/255,  12/255,   0/255},
			ChannelingColor   = { 95/255, 182/255, 255/255},
			SafeZoneColor     = {255/255,  30/255,   0/255, .6},
			NotInterruptColor = {255/255, 32/255, 16/255, 1},
		},
		highlight = {
			Texture         = bar_normal,
			Color           = {128/255, 128/255, 128/255, .1},
		},
		classbar = {
			show = true,
			texture = bar_normal,
			font = dfont, fontsize = 12, fontflag = "THINOUTLINE",
			height = 6, width = 160,
			anchor = "TOPRIGHT", relative = "BOTTOMRIGHT", x = 0, y = -5,
		},
		altpowerbar = {
			show = true,
			texture = bar_normal,
			font = dfont, fontsize = 12, fontflag = "THINOUTLINE",
			height = 5, width = 220,
			anchor = "CENTER", relative = "CENTER", x = 0, y = -145, to = "UIParent"
		},
		threatbar = {
			show = true,
			texture = bar_normal,
			font = dfont, fontsize = 12, fontflag = "THINOUTLINE",
			height = 6, width = 160,
			anchor = "TOPLEFT", relative = "BOTTOMLEFT", x = 0, y = -5, to = "target",
		},
        style = GlobalStyle,
    }
}

---------------------------------------------
----Minimap Theme                        ----
---------------------------------------------
local function StyleMinimap(MMModule)
    Lib.CreateBorder(MMModule.Map, 1, {0,0,0,0},{1,1,1,.9})
    
    Moe.Lib.CreatePanel({name = "MiniMap_TopLine", parent = "UIParent",				
        point = {"BOTTOM", MMModule.Map, "TOP", 0, 4},   
        texture = Media.Bar.GradCE,
        level = 1, 
        height = 3, width = MMModule.Map:GetWidth() + 28,
        color = {1,1,1,1},
	})
end
local MMTheme = {
    ClockPos    = {"TOP",    "Minimap", "BOTTOM", 0,  -2},
    MailPos     = {"TOP",    "Minimap", "BOTTOM", 0, -18},
    LocationPos = {"BOTTOM", "Minimap", "TOP",    0,   9},
    CoordsPos   = {"TOP",    "Minimap", "TOP",    0,  -1},
    Style = StyleMinimap,
}

---------------------------------------------
----ActionBar Theme                      ----
---------------------------------------------
local function StyleBarSwitch(switch)
    Moe.Lib.CreatePanel({   
        name = "BarSwitch_BG", parent = "UIParent",				
        point = {"BOTTOM", 0, 12},   
        texture = Media.Texture.Arrow,
        level = 1,
        height = 15, width = 15,
        color = {1, 1, 1, .85},
	})
end
local function EnSwitch(self)
    --self.bg:SetVertexColor(1, 1, 1, .85)
	Lib.Flip(self.bg, "VERTICAL")
end
local function DisSwitch(self)
    --self.bg:SetVertexColor(.4, .4, .4, .85)
	Lib.Flip(self.bg, "VERTICAL")
end
local ButtonStyle = {
    backdrop = {
        bgFile   = Media.Button.BG,
        edgeFile = Media.Button.Shadow,
        tile     = false,
        tileSize = 0,
        edgeSize = 1,
        insets   = { left = 3, right = 3, top = 3, bottom = 3, },
    },
    background = {
        backgroundcolor   	= { 0.92, 0.92, 0.92, .1},
        shadowcolor       	= { 1, 1, 1, 1},
        showbg      		= true,
        showshadow			= true,
        classcolored		= false,
        useflatbackground	= false,
    },
    hotkeys = {
        font 				= Media.Fonts.Default,
        fontsize 			= 12,
        fontflags 			= "THINOUTLINE",
        point 				= { "TOPRIGHT", 0, 0 }
    },
    macroname = {
        font 				= Media.Fonts.Default,
        fontsize 			= 12,
        fontflags 			= "THINOUTLINE",
        point 				= { "BOTTOMLEFT", 0, 0 }
    },
    itemcount = {
        font 				= Media.Fonts.Default,
        fontsize 			= 12,
        fontflags 			= "THINOUTLINE",
        point 				= { "BOTTOMRIGHT", 0, 0 }
    },
    cooldown = {
        spacing 			= 0,
    },
    color = {
        normal            	= { 0.94, 0.94, 0.97, .9 },
        equipped          	= { 0.1, 0.5, 0.1, 1 },
    },
    textures = {
        normal         = Media.Button.Gloss,
        flash          = Media.Button.Flash,
        hover          = Media.Button.Hover,
        pushed         = Media.Button.Pushed,
        checked        = Media.Button.Checked,
        equipped       = Media.Button.Grey,
        buttonback     = Media.Button.BG,
        buttonbackflat = Media.Button.BGFlat,
        outer_shadow   = Media.Button.Glow,
    }
}
local SwitchStyle = {
    show = true,
    Enter = function(self) self.bg:SetVertexColor(.95, .95, .25, .8) end,
    Leave = function(self) self.bg:SetVertexColor(.95, .95, .95, .8) end,
    texture = Media.Texture.Arrow,
    point = {"BOTTOMRIGHT", "UIParent", "BOTTOM", -183, 17},
    color = {.95, .95, .95, .8},
    enable = EnSwitch,
    disable = DisSwitch,
    width = 15, height = 8,
    --style = StyleBarSwitch,
}
local ActBarTheme = {
    Button = ButtonStyle,
    Switch = SwitchStyle,
}

---------------------------------------------
----InfoBar Theme                        ----
---------------------------------------------
local infoTheme = {
    barwidth = 600, barheight = 25,
    bargrad = false, flip_v = true,
    barbg = Media.Bar.GradV, barcolor = {.92, .92, .92, .85},
    switch = {
        texture = nil, 
        color = {.0, .0, .0, .0},
        height = 25, width = 100,
        fs = {
            size = 16, outline = "THINOUTLINE",
            anchor = "BOTTOM", align = "CENTER",
            x_off = 0, y_off = 2, textcolor = {0.81,0.13,0.94,.9},
            font = Media.Fonts.NUM1,
        },
    },
    mover = {
        texture = Media.Bar.GradV, color = {.92, .92, .92, .85},
        height = 25, width = 25, flip_v = true,
        backdrop = bdrop, bordercolor = {0,0,0,1},
        intext = "<", outtext = ">"
    },
}


---------------------------------------------
----Register                             ----
---------------------------------------------
local logo = Media.Path.."Texture\\Logo"
Theme:New("Default", logo)
Theme:Register("Default", "GUI",       GUITheme)
Theme:Register("Default", "UnitFrame", UFTheme)
Theme:Register("Default", "Minimap",   MMTheme)
Theme:Register("Default", "ActionBar", ActBarTheme)
Theme:Register("Default", "InfoBar",   infoTheme)

