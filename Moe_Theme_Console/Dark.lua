local Moe = _G["Moe"]

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
---------------------------------------------
----GUI Theme                            ----
---------------------------------------------
local UIDB = {
	--µ×²¿²¿·Ö
    {   name = "BG_BottomLeft",         parent = "UIParent",				
        point = {"BOTTOMLEFT", 0, 1},   
        texture = bar_texture,
        level = 1, backdrop = bdrop, bordercolor = {0,0,0,1},
        height = 181, width = 0.24 * GetScreenWidth(),
        color = {.12, .12, .12, .85},
	},
    {   name = "BG_BottomLeft2",        parent = "UIParent",				
        point = {"BOTTOMLEFT", 0, 22},  
        texture = bar_texture, level = 2, 
        height = 1, width = 0.24 * GetScreenWidth(),
        color = {0, 0, 0, 1},
	},
	{   name = "BG_BottomLeft3",        parent = "UIParent",
        point = {"BOTTOMLEFT", 0, 159},  
        texture = bar_texture, level = 2, 
        height = 1, width = 0.24*GetScreenWidth(),
        color = {0, 0, 0, 1},
	},
    --right
    {   name = "BG_BottomRight",        parent = "UIParent",				
        point = {"BOTTOMRIGHT", 0, 1},   
        texture = bar_texture,
        level = 1, backdrop = bdrop, bordercolor = {0,0,0,1},
        height = 181, width = 0.24 * GetScreenWidth(),
        color = {.12, .12, .12, .85},
	},
    {   name = "BG_BottomRight2",       parent = "UIParent",				
        point = {"BOTTOMRIGHT", 0, 22},  
        texture = bar_texture, level = 2, 
        height = 1, width = 0.24 * GetScreenWidth(),
        color = {0, 0, 0, 1},
	},
	{   name = "BG_BottomRight3",       parent = "UIParent",
        point = {"BOTTOMRIGHT", 0, 159},  
        texture = bar_texture, level = 2, 
        height = 1, width = 0.24*GetScreenWidth(),
        color = {0, 0, 0, 1},
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
                        ["bartexture"] = "TukTex",
                        ["barwidth"] = 327,
                        ["barspacing"] = 1,
                        ["point"] = "BOTTOMRIGHT",
                        ["barfontsize"] = 13,
                        ["background"] = {
                            ["height"] = 139,
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
end
local StyleCoolline = function()
    if not IsAddOnLoaded("CoolLine") then return end
	if(CoolLineDB) then table.wipe(CoolLineDB) end
    CoolLineDB = {
        ["hidebag"] = true,
        ["bgcolor"] = {
            ["a"] = 0.85,
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
            ["a"] = 1,
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
        ["statusbar"] = "TukTex",
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
local function CBorder(f, level, bgcolor)
    Moe.Lib.CreateShadow(f, 3, bgcolor, {0,0,0,1}, 3)
    f.border:SetFrameLevel(level)
end
local function StyleBars(frame, unit)
    CBorder(frame.Health, 1, {.9,.1,.1,.3})
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
				width = 200, height = 9, 
				usepowercolor = true,
				color = {r = 0, g = 0, b = 0, a = .5},
				anchor = "BOTTOM", relative = "BOTTOM", to = "Health", x = 0, y = -4,
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
				name = { str = "[color][name][afkdnd]", font = namefont, size = 14, flag = "THINOUTLINE", align = "LEFT", anchor = "LEFT", relative = "LEFT", to = "Health", x = 2, y = 2, },
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
			style = StyleBars,
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
				height = 9, width = 200,
				color = {r = 0, g = 0, b = 0, a = .5},
				usepowercolor = true,
				anchor = "BOTTOM", relative = "BOTTOM", to = "Health", x = 0, y = -4,
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

---------------------------------------------
----Minimap Theme                        ----
---------------------------------------------
local function StyleMinimap(MMModule)
    local border = CreateFrame("Frame", nil, MMModule.Map)
    border:SetFrameLevel(1)
    border:SetPoint("TOPLEFT", MMModule.Map, "TOPLEFT", -2, 2)
	border:SetPoint("BOTTOMRIGHT", MMModule.Map, "BOTTOMRIGHT", 2, -2)
    border:SetBackdrop({ 
        edgeFile = "Interface\\AddOns\\Moe_Theme_Dark\\Texture\\roth",
        bgFile = bar_texture, 
        edgeSize = 3,
        tile = false,
        tileSize = 0,
        insets = {left = 1, right = 1, top = 1, bottom = 1},
    })
	border:SetBackdropColor(.12, .12, .12, 1)
	border:SetBackdropBorderColor(0, 0, 0, 1)
    
    Moe.Lib.CreatePanel({name = "MiniMap_LocBG", parent = "UIParent",				
        point = {"BOTTOM", MMModule.Map, "TOP", 0, 1},   
        texture = bar_texture,
        level = 1, backdrop = bdrop, bordercolor = {0,0,0,1},
        height = 22, width = MMModule.Map:GetWidth() + 4,
        color = {.22, .22, .22, .85},
	})
    Moe.Lib.CreatePanel({name = "MiniMap_ClockBG", parent = MMModule.Map:GetName(),				
        point = {"TOP", MMModule.Map, "BOTTOM", 0, -1},   
        texture = bar_texture,
        level = 1, backdrop = bdrop, bordercolor = {0,0,0,1},
        height = 18, width = MMModule.Map:GetWidth() + 4,
        color = {.22, .22, .22, .85},
	})
end
local MMTheme = {
    ClockPos    = {"TOP",    "Minimap", "BOTTOM", 0,  -5},
    MailPos     = {"TOP",    "Minimap", "BOTTOM", 0, -21},
    LocationPos = {"BOTTOM", "Minimap", "TOP",    0,   5},
    CoordsPos   = {"TOP",    "Minimap", "TOP",    0,  -1},
    Style = StyleMinimap,
}

---------------------------------------------
----ActionBar Theme                      ----
---------------------------------------------
local function StyleBarSwitch(switch)
    Moe.Lib.CreatePanel({   
        name = "BarSwitch_BG", parent = "UIParent",				
        point = {"BOTTOM", 0, 1},   
        texture = bar_texture,
        level = 1, backdrop = bdrop, bordercolor = {0,0,0,1},
        height = 12, width = 360,
        color = {.12, .12, .12, .85},
	})
end
local function EnSwitch(self)
    Moe.Lib.Flip(self.bg, "VERTICAL")
end
local ButtonStyle = {
    backdrop = {
        bgFile   = Media.Button.BG,
        edgeFile = "Interface\\AddOns\\Moe_Theme_Dark\\Texture\\roth",
        tile     = false,
        tileSize = 0,
        edgeSize = 1,
        insets   = { left = 4, right = 4, top = 4, bottom = 4, },
    },
    background = {
        backgroundcolor   	= { 0.12, 0.12, 0.12, .8},
        shadowcolor       	= { 0, 0, 0, 1},
        showbg      		= true,
        showshadow			= false,
        classcolored		= false,
        useflatbackground	= true,
        inset				= 5,
        insetsize			= 5,
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
        normal            	= { 0.14, 0.14, 0.17, .9 },
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
    Enter = function(self) self:SetAlpha(.8) end,
    Leave = function(self) self:SetAlpha(.4) end,
    texture = Media.Texture.Arrow,
    point = {"BOTTOM", 0, 2},
    color = {.85, .14, .96, .4},
    enable = EnSwitch,
    disable = EnSwitch,
    width = 24, height = 8,
    style = StyleBarSwitch,
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
    bargrad = false,
    barbg = bar_texture, barcolor = {.12, .12, .12, .85},
    backdrop = bdrop, bordercolor = {0,0,0,1},
    switch = {
        texture = nil, 
        color = {.0, .0, .0, .0},
        height = 25, width = 100,
        backdrop = bdrop, bordercolor = {0,0,0,1},
        fs = {
            size = 16, outline = "THINOUTLINE",
            anchor = "BOTTOM", align = "CENTER",
            x_off = 0, y_off = 2, textcolor = {0.81,0.13,0.94,.9},
            font = Media.Fonts.NUM1,
        },
    },
    mover = {
        texture = bar_texture, color = {.12, .12, .12, .85},
        height = 25, width = 25,
        backdrop = bdrop, bordercolor = {0,0,0,1},
        intext = "<", outtext = ">"
    },
}

---------------------------------------------
----Register                             ----
---------------------------------------------
local logo = "Interface\\AddOns\\Moe_Theme_Dark\\Texture\\LogoDark"
Theme:New("Dark", logo)
Theme:Register("Dark", "GUI",       GUITheme)
Theme:Register("Dark", "UnitFrame", UFTheme)
Theme:Register("Dark", "Minimap",   MMTheme)
Theme:Register("Dark", "ActionBar", ActBarTheme)
Theme:Register("Dark", "InfoBar",   infoTheme)

