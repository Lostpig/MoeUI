local _, ns = ...
local Moe = ns.Moe

local Media = Moe.Media
local Theme = Moe.Theme
local bar_texture = "Interface\\AddOns\\Moe_Theme_Dark\\Texture\\Flat"
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

Theme:Register("KanColle", "GUI", GUITheme)