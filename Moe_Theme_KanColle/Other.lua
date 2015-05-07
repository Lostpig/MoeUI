local _, ns = ...
local Moe = ns.Moe

local Media = Moe.Media
local Theme = Moe.Theme

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

Theme:Register("KanColle", "Minimap",   MMTheme)
Theme:Register("KanColle", "ActionBar", ActBarTheme)
Theme:Register("KanColle", "InfoBar",   infoTheme)