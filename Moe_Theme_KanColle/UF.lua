local _, ns = ...
local Moe = ns.Moe

local Media = Moe.Media
local Theme = Moe.Theme

local dfont = Media.Fonts.Default
local namefont = Media.Fonts.F
local bar_texture = "Interface\\AddOns\\Moe_Theme_Dark\\Texture\\Flat"
local healthcolor = {r = .26, g = .26, b = .26, a = .9}
local bdrop = { 
    edgeFile = "Interface\\AddOns\\Moe_Theme_Dark\\Texture\\roth",
    bgFile = nil, 
    edgeSize = 4,
    tile = false,
    tileSize = 0,
    insets = {left = 2, right = 2, top = 2, bottom = 2},
}

local htex = "Interface\\AddOns\\Moe_Theme_KanColle\\media\\HBar"
local hbgtex = "Interface\\AddOns\\Moe_Theme_KanColle\\media\\BarBG"
local avatartex = "Interface\\AddOns\\Moe_Theme_KanColle\\media\\avatar"
local avatartex2 = "Interface\\AddOns\\Moe_Theme_KanColle\\media\\avatar2"
local sicbb = "Interface\\AddOns\\Moe_Theme_KanColle\\media\\BB"
local sicmb = "Interface\\AddOns\\Moe_Theme_KanColle\\media\\MB"
---------------------------------------------
----UF Theme                             ----
---------------------------------------------
local function CBorder(f, level, bgcolor)
    Moe.Lib.CreateShadow(f, 3, bgcolor, {0,0,0,1}, 3)
    f.border:SetFrameLevel(level)
end
local function StyleBars(frame, unit)
    CBorder(frame.Health, 1, {.6,.1,.1,.5})
    if frame.Power then 
        CBorder(frame.Power, 1, {.1,.1,.1,.9}) 
        frame.Power:SetFrameLevel(4)
        frame.Power.shadow:SetFrameLevel(3)
    end
    if frame.Castbar then 
        if frame.Castbar.Icon then
            CBorder(frame.Castbar.Iconbg,1,{.3,.3,.3,.3}) 
        end
        CBorder(frame.Castbar,1,{.3,.3,.3,.3}) 
    end
end
local function GlobalStyle(frames)
    if frames["player"].ThreatBar then
        frames["player"].ThreatBar:SetPoint("BOTTOM",frames["target"],"TOP",0,3)
    end
end
local function ClassBarStyle(bar)
    CBorder(bar, 1, {.16,.16,.16,.9})
    bar:SetFrameLevel(4)
    bar.shadow:SetFrameLevel(3)
end

local function PlayerHealthPost(bar, unit, curhp, maxhp)
    local perc = maxhp > 0  and curhp / maxhp or 0
    if perc < 0.3 and bar.s > 1 then 
        bar.s = 1
        bar.avatar:SetTexture(avatartex)
        bar.sicon:SetTexture(sicbb)
    elseif perc < 0.6 and bar.s > 2 then 
        bar.s = 2
        bar.avatar:SetTexture(avatartex)
        bar.sicon:SetTexture(sicmb)
    elseif perc > 0.65 then
        bar.s = 3
        bar.avatar:SetTexture(avatartex2)
        bar.sicon:SetTexture(nil)
    end
end
local function StylePlayerBars(frame)
    StyleBars(frame, "player")
    frame.Health.avatar = frame.Health:CreateTexture(nil, "OVERLAY")
    frame.Health.avatar:SetTexture(avatartex2)
    frame.Health.avatar:SetPoint("TOPLEFT", 0, 0)
    frame.Health.avatar:SetPoint("BOTTOMRIGHT", -40, 0)
    frame.Health.avatar:SetVertexColor(1,1,1,1)
    
    frame.Health.s = 1
    frame.Health.sicon = frame.Health:CreateTexture(nil, "OVERLAY")
    frame.Health.sicon:SetSize(30,30)
    frame.Health.sicon:SetPoint("CENTER",25,0)
    frame.Health.PostUpdate = PlayerHealthPost
end


local UFTheme = {
	Unit = {
		player = {
			width = 220, height = 45,
			health = {
				texture = bar_texture,
				reverse = false,
				width = 220, height = 30, 
				color = healthcolor,
				anchor = "TOP", relative = "TOP", x = 0, y = 0,
			},
			power = {
				texture = bar_texture,
				reverse = false,
				width = 220, height = 7, 
				usepowercolor = true,
				color = {r = 0, g = 0, b = 0, a = .5},
				anchor = "TOP", relative = "BOTTOM", to = "Health", x = 0, y = -3,
				flipv = true, 
			},
			icons = {
				["Combat"] = {anchor = "TOPLEFT", relative = "TOPRIGHT", x = 3, y = 1, size = 12, texture = "Interface\\CharacterFrame\\UI-StateIcon", coord = {0.58, 0.90, 0.08, 0.41},},
				["Leader"] = {anchor = "TOPLEFT", relative = "TOPLEFT", x = 3, y = -1, size = 12 },
				["Assistant"] = {anchor = "TOPLEFT", relative = "TOPLEFT", x = 3, y = -1, size = 12 },
				["MasterLooter"] = {anchor = "TOPLEFT", relative = "TOPLEFT", x = 17, y = -1, size = 12 },
				["RaidIcon"] = {anchor = "CENTER", relative = "TOP", x = 0, y = 8, size = 16, texture = "Interface\\TARGETINGFRAME\\UI-RaidTargetingIcons"},
			},
			tags = {
				--name = { str = "[color][name][afkdnd]", font = namefont, size = 14, flag = "THINOUTLINE", align = "LEFT", anchor = "LEFT", relative = "LEFT", to = "Health", x = 2, y = 2, },
				hp   = { str = "[shp] | [perhp]%", frequentUpdates = 0.1, font = dfont, size = 14, flag = "THINOUTLINE", align = "RIGHT", anchor = "RIGHT", relative = "RIGHT", to = "Health", x = -2, y = 2, },
				pp   = { str = "[powercolor]", frequentUpdates = 0.1, font = dfont, size = 14, flag = "THINOUTLINE", align = "RIGHT", anchor = "RIGHT", relative = "RIGHT", to = "Power", x = -2, y = -3, },
			},
			castbar = {
				height = 14, width = 220,
				anchor = "TOP", relative = "BOTTOM", to = "Power", x = 0, y = -7,
				text = {font = dfont, size = 12, flag = "THINOUTLINE", anchor = "LEFT", relative = "LEFT", x = 2, y = 1 },
				time = {font = dfont, size = 12, flag = "THINOUTLINE", anchor = "RIGHT", relative = "RIGHT", x = -2, y = 1 },
				lag  = {font = dfont, size = 12, flag = "THINOUTLINE", anchor = "CENTER", relative = "CENTER", x = -2, y = 17 },
				icon = {show = true, size = 31, anchor = "BOTTOMRIGHT", relative = "BOTTOMLEFT", x = -5, y = 0 },
				--style = CastBarStyle,
			},
			highlight = {
				Texture = bar_texture,
				Color = {208/255, 208/255, 208/255, .3},
			},
			buffs = {
				size = 24, num = 40, spacing = 8, anchor = "TOPRIGHT", relative = "TOPRIGHT", to = "UIParent",
				x = -150, y = -10, columns = 10,
			},
			debuffs = {
				size = 20, num = 21, spacing = 6, anchor = "BOTTOMRIGHT", relative = "TOPRIGHT",
				x = 0, y = 19, columns = 9,
			},
			style = StylePlayerBars,
		},
		target = {
			width = 220, height = 45,
			health = {
				texture = bar_texture,
				reverse = true,
				height = 30, width = 220,
				color = healthcolor,
				anchor = "TOP", relative = "TOP", x = 0, y = 0,
			},
			power = {
				texture = bar_texture,
				reverse = true,
				height = 7, width = 220,
				color = {r = 0, g = 0, b = 0, a = .5},
				usepowercolor = true,
				anchor = "TOP", relative = "BOTTOM", to = "Health", x = 0, y = -3,
			},
			icons = {
				["RaidIcon"] = {anchor = "CENTER", relative = "TOP", x = 0, y = 2, size = 16, texture = "Interface\\TARGETINGFRAME\\UI-RaidTargetingIcons"},
				["QuestIcon"] = {anchor = "TOPLEFT", relative = "TOPLEFT", x = 0, y = 8, size = 16}
			},
			tags = {
				name = { str = "[color][name][afkdnd]", font = namefont, size = 14, flag = "THINOUTLINE", align = "RIGHT", anchor = "RIGHT", relative = "RIGHT",to = "Health", x = -2, y = 2, },
				level = { str = "[level]", font = dfont, size = 14, flag = "THINOUTLINE", align = "RIGHT", anchor = "RIGHT", relative = "RIGHT", to = "Power", x = -2, y = -3, },
                hp   = { str = "[perhp]% | [shp]", frequentUpdates = 0.1, font = dfont, size = 14, flag = "THINOUTLINE", align = "LEFT", anchor = "LEFT", relative = "LEFT", to = "Health", x = 2, y = 2, },				
				pp   = { str = "[powercolor]", frequentUpdates = 0.1, font = dfont, size = 14, flag = "THINOUTLINE", align = "LEFT", anchor = "LEFT", relative = "LEFT", to = "Power", x = 2, y = -3, },
			},
			castbar = {
				height = 14, width = 220, reverse = true,
				anchor = "TOP", relative = "BOTTOM", to = "Power", x = 0, y = -7,
				text = {font = dfont, size = 12, flag = "THINOUTLINE", anchor = "LEFT", relative = "LEFT", x = 2, y = 1 },
				time = {font = dfont, size = 12, flag = "THINOUTLINE", anchor = "RIGHT", relative = "RIGHT", x = -2, y = 1 },
				icon = {show = true, size = 31, anchor = "BOTTOMLEFT", relative = "BOTTOMRIGHT", x = 5, y = 0 },
				--style = CastBarStyle,
			},
			highlight = {
				Texture = bar_texture,
				Color = {208/255, 208/255, 208/255, .3},
			},
			auras = {
				size = 16, numBuffs = 16, numDebuffs = 33, spacing = 6, anchor = "BOTTOMLEFT", relative = "TOPLEFT",
				onlyplayer = false, growx = "RIGHT", growy = "UP", 
				x = 0, y = 19, columns = 10,
			},
			style = StyleBars,
		},
		pet = {
			width = 120, height = 18,
			health = {
				texture = bar_texture,
				reverse = false,
				height = 18, width = 120,
				color = healthcolor,
				anchor = "TOP", relative = "TOP", x = 0, y = 0,
			},
			tags = {
				name = { str = "[color][name]", font = namefont, size = 12, flag = "THINOUTLINE", align = "LEFT", anchor = "LEFT", relative = "LEFT", x = 0, y = 0, },
                perhp = { str = "[perhp]%", font = dfont, size = 12, flag = "THINOUTLINE", align = "RIGHT", anchor = "RIGHT", relative = "RIGHT", x = 0, y = 0, },
            },
			style = StyleBars,
		},
		targettarget = {
			width = 120, height = 18,
			health = {
				texture = bar_texture,
				reverse = true,
				height = 18, width = 120,
				color = healthcolor,
				anchor = "TOP", relative = "TOP", x = 0, y = 0,
			},
			tags = {
				name = { str = "[color][name]", font = namefont, size = 12, flag = "THINOUTLINE", align = "RIGHT", anchor = "RIGHT", relative = "RIGHT", x = 0, y = 0, },
                perhp = { str = "[perhp]%", font = dfont, size = 12, flag = "THINOUTLINE", align = "LEFT", anchor = "LEFT", relative = "LEFT", x = 0, y = 0, },
			},
			style = StyleBars,
		},
		focus = {
			width = 150, height = 29,
			health = {
				texture = bar_texture,
				reverse = true,
				height = 22, width = 150,
				color = healthcolor,
				anchor = "TOP", relative = "TOP", x = 0, y = 0,
			},
			power = {
				texture = bar_texture,
				reverse = true,
				height = 6, width = 150,
				usepowercolor = true,
				color = {r = .05, g = .05, b = .05, a = .9},
				anchor = "BOTTOM", relative = "BOTTOM", x = 0, y = 0,
			},
			tags = {
				name = { str = "[color][name]", font = namefont, size = 12, flag = "THINOUTLINE", align = "LEFT", anchor = "LEFT", relative = "LEFT", x = 0, y = 0, },
                perhp = { str = "[perhp]%", font = dfont, size = 12, flag = "THINOUTLINE", align = "RIGHT", anchor = "RIGHT", relative = "RIGHT", x = 0, y = 0, },
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
			style = StyleBars,
		},
		focustarget = {
			width = 150, height = 20,
			health = {
				texture = bar_texture,
				reverse = true,
				height = 20, width = 150,
				color = healthcolor,
				anchor = "TOP", relative = "TOP", x = 0, y = 0,
			},
			tags = {
				name = { str = "[color][name]", font = namefont, size = 12, flag = "THINOUTLINE", align = "LEFT", anchor = "LEFT", relative = "LEFT", x = 0, y = 0, },
                perhp = { str = "[perhp]%", font = dfont, size = 12, flag = "THINOUTLINE", align = "RIGHT", anchor = "RIGHT", relative = "RIGHT", x = 0, y = 0, },
			},
			style = StyleBars,
		},
		boss = {
			width = 150, height = 20,
			health = {
				texture = bar_texture,
				reverse = true,
				height = 20, width = 150,
				color = healthcolor,
				anchor = "TOP", relative = "TOP", x = 0, y = 0,
			},
			tags = {
				name = { str = "[color][name]", font = namefont, size = 12, flag = "THINOUTLINE", align = "LEFT", anchor = "LEFT", relative = "LEFT", x = 0, y = 0, },
                perhp = { str = "[perhp]%", font = dfont, size = 12, flag = "THINOUTLINE", align = "RIGHT", anchor = "RIGHT", relative = "RIGHT", x = 0, y = 0, },
			},
			style = StyleBars,
		}
	},
	Global = {
		castbar = {
			Texture         = bar_texture, --"Interface\\AddOns\\Moe_UF\\media\\textures\\normTex",
			SparkTexture    = bar_texture,
			Color		    = { 95/255, 182/255, 255/255, .7},
			CastingColor    = { 95/255, 182/255, 255/255},
			CompleteColor   = { 20/255, 208/255,   0/255},
			FailColor       = {255/255,  12/255,   0/255},
			ChannelingColor = { 95/255, 182/255, 255/255},
			SafeZoneColor   = {255/255,  30/255,   0/255, .6},
		},
		highlight = {
			Texture         = bar_texture,
			Color           = {192/255, 192/255, 192/255, .3},
		},
		classbar = {
			show = true,
			texture = bar_texture,
			font = dfont, fontsize = 12, fontflag = "THINOUTLINE",
			height = 6, width = 220,
			anchor = "BOTTOM", relative = "TOP", x = 0, y = 3,
            style = ClassBarStyle,
		},
		altpowerbar = {
			show = true,
			texture = bar_texture,
			font = dfont, fontsize = 12, fontflag = "THINOUTLINE",
			height = 6, width = 160,
			anchor = "CENTER", relative = "CENTER", x = 0, y = -125, to = "UIParent"
		},
		threatbar = {
			show = true,
			texture = bar_texture,
			font = dfont, fontsize = 12, fontflag = "THINOUTLINE",
			height = 6, width = 220,
			anchor = "BOTTOM", relative = "TOP", x = 0, y = 3, to = "target",
            style = ClassBarStyle,
		},
        style = GlobalStyle,
    }
}

Theme:Register("KanColle", "UnitFrame", UFTheme)